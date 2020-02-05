library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.VComponents.all;

entity FTDI_mFIFO is
	port(
	-- external pins
		CLK  : in std_logic;
		DATA : inout std_logic_vector(7 downto 0);
		RXF_N  : in std_logic;       -- 1: don't read, 0: data available
		TXE_N  : in std_logic;       -- 1: don't write, 0: can write
		OE_N   : out std_logic;      -- output enable#, low for >=1 clock before WR_N
		RD_N   : out std_logic;      -- read#
		WR_N   : out std_logic;      -- write#
		-- internal interface
		rstn      : in std_logic;
		data_in   : in std_logic_vector(7 downto 0);
		data_out  : out std_logic_vector(7 downto 0);
		out_DV    : out std_logic;
		in_DV     : in std_logic;    -- input fifo not empty
		din_rd    : out std_logic;  -- read acknowledge
		pause_rcv : in std_logic   -- output fifo full
	);
end FTDI_mFIFO;


architecture syncr_FIFO_NF of FTDI_mFIFO is

	type state_arr is (idle, delay, rcv, snd);
	signal state : state_arr := idle;

	signal DATA_I, DATA_O : std_logic_vector(7 downto 0);
	signal DATA_dir : std_logic;

begin


	process(CLK)
	begin
		if rising_edge(CLK) then

		-- prioritize rcv over snd by default
			case state is

				when idle =>
					OE_N <= '1';
					if RXF_N = '0' and pause_rcv = '0' then
						OE_N <= '0';
						state <= delay;
					elsif TXE_N = '0' and in_DV = '1' then
						state <= snd;
					end if;

				when delay =>
					OE_N <= '0';
					state <= rcv;

				when rcv =>
					if RXF_N = '0' and pause_rcv = '0' then
						state <= rcv;
					else
						state <= idle;
					end if;

				when snd =>
					if TXE_N = '0' and in_DV = '1' then
						state <= snd;
					else
						state <= idle;
					end if;

			end case;

			if rstn = '0' then
				state <= idle;
			end if;

		end if;
	end process;


	DATA_dir <= '0' when state = snd else '1';

	-- tx data and rd ack signal
	DATA_I <= data_in;
	din_rd <= (not TXE_N) and (not WR_N);
	WR_N <= (not in_DV) when state = snd else '1';
	-- rx data and DV signal
	data_out <= DATA_O;
	out_DV <= (not RXF_N) and (not RD_N);
	RD_N <= pause_rcv when state = rcv else '1';

	IOBUF_gen: for n in 0 to 7 generate
		DATA_IOBUF: IOBUF
			port map(
				O  => DATA_O(n),
				IO => DATA(n),
				I  => DATA_I(n),
				T  => DATA_dir
			);
	end generate;

end syncr_FIFO_NF;
