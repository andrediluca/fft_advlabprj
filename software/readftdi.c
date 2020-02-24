#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <ftdi.h>
#include <signal.h>

#define BUFF_SIZE 8000


struct ftdi_context *ftdi;
static int terminate = 0;


union data_buffer {
	uint8_t byte[BUFF_SIZE];
	uint32_t word[BUFF_SIZE/4];
};

struct data_packet{
	union data_buffer data;
	uint16_t count;
};


void sigint_handler(int signum) {
	printf("Stopping on user request: %i\n", signum);
	terminate = 1;
}


int packet_push_word(struct data_packet* packet, uint32_t word){

	if (packet->count == BUFF_SIZE-1)
		return -1;

	packet->data.word[packet->count/4] = word;
	packet->count = packet->count + 4;

	return 0;
}


int write_fifo(struct data_packet* packet){
	int ret;

	packet_push_word(packet, 0xffffffff); // EoP word
	ret = ftdi_write_data(ftdi, packet->data.byte, packet->count);

	if (ret<0)
		return ret;
	else if (ret != packet->count)
		return -1;

	packet->count = 0;
	return 0;
}


int read_fifo(struct data_packet* packet){
	int ret = 0, tryes = 0;

	while(ret == 0 && tryes < 3){
		ret = ftdi_read_data(ftdi, packet->data.byte, BUFF_SIZE);

		if (ret < 0)
			return -1;

		tryes++;
	}

	packet->count = ret;
	return 0;
}


int readout_loop(){
	signal(SIGINT, sigint_handler);

	union data_buffer buff;
	int count;
	FILE* outstrm = fopen("dout.raw", "w");

	printf("started..\n");
	while(!terminate){
		count = ftdi_read_data(ftdi, buff.byte, BUFF_SIZE);
		if (count <= 0) {
			usleep(1000);
			continue;
		}
		fwrite(buff.byte, 1, count, outstrm);
	}

	fclose(outstrm);
	return 0;
}


int main(int argc, char *argv[]){

	signal(SIGINT, sigint_handler);

	const int vendor_id = 0x403;
	const int product_id = 0x6010;
	int ret;

	ftdi = ftdi_new();
	ret = ftdi_set_interface(ftdi, INTERFACE_A);
	if (ret < 0){
		fprintf(stderr, "set_interface failed\n");
		return -1;
	}

	ret = ftdi_usb_open(ftdi, vendor_id, product_id);
	if (ret < 0){
		fprintf(stderr, "unable to open device: %i\n", ret);
		return -1;
	}

	ret = ftdi_usb_reset(ftdi);
	ret |= ftdi_set_bitmode(ftdi, 0xFF, BITMODE_RESET);
	if (ret < 0){
		fprintf(stderr, "Device reset failed\n");
		return -1;
	}

	ret = ftdi_set_bitmode(ftdi, 0xFF, BITMODE_SYNCFF);
	if (ret < 0){
		fprintf(stderr, "Unable to set bitmode SYNCFF\n");
		return -1;
	}

	ftdi_usb_purge_buffers(ftdi);

	struct data_packet packet = {.count = 0};
	readout_loop();


_Exit:
	ftdi_usb_close(ftdi);
	ftdi_free(ftdi);
	return 0;
}
