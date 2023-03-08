----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 11/05/2022 05:33:29 PM
-- Design Name: UART receiver 
-- Module Name: uart_rx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--		State machine for interpreting UART signal send from IMU
--      UART DATA FRAME CONFIG: 1 start bit, 8 bits data, no parity bit, 1 stop bit
-- 
-- Additional Comments:
-- IP CORE SOURCED
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
	Generic( clk_baudrate : integer := 5208 );					-- (clk / baud_rate)

	Port (	clk : in std_logic;									-- clock
			rst : in std_logic;									-- reset
			rx_di : in std_logic;							-- RX line input
			rx_do : out std_logic_vector(7 downto 0);		-- 8 bit data received
			rx_dr : out std_logic );						-- active when data is received
end uart_rx;

architecture Behavioral of uart_rx is
	type state_type is (idle_state,start_state,data_state,stop_state);
	signal current_state : state_type := idle_state;
	signal count_8 : integer range 0 to 7 := 0;
	signal count_clk : integer range 0 to (clk_baudrate - 1) := 0;
	signal data : std_logic_vector (7 downto 0) := (others => '0');
	signal data_ready : std_logic := '0';
begin
	process(clk, rst) begin
		if (rst = '1') then
			current_state <= idle_state;
			count_8 <= 0;
			count_clk <= 0;
			data <= (others => '0');
			data_ready <= '0';
		elsif (rising_edge(clk)) then

			case current_state is

				when idle_state =>
					count_8 <= 0;
					count_clk <= 0;
					data_ready <= '0';

					if (rx_di = '0') then
						current_state <= start_state;
					else
						current_state <= idle_state;
					end if;

				when start_state =>

					if count_clk = (clk_baudrate - 1)/2 then
						if (rx_di = '0') then		
							count_clk <= 0;
							current_state <= data_state;
						else
							current_state <= idle_state;
						end if;
					else
						count_clk <= count_clk + 1;
						current_state <= start_state;
					end if;

				when data_state =>

					if count_clk < (clk_baudrate - 1) then
						count_clk <= count_clk + 1;
						current_state <= data_state;
					else
						count_clk <= 0;
						data(count_8) <= rx_di;

						if count_8 < 7 then
							count_8 <= count_8 + 1;
							current_state <= data_state;
						else
							count_8 <= 0;
							current_state <= stop_state;
						end if;
					end if;

				when stop_state =>

					if count_clk < (clk_baudrate - 1) then
						count_clk <= count_clk + 1;
						current_state <= stop_state;
					else
						if ( rx_di = '1' ) then		
							count_clk <= 0;
							data_ready <= '1';
							current_state <= idle_state;
						end if;
					end if;

				when others =>
					current_state <= idle_state;
			end case;
		end if;
	end process;
	rx_do <= data;
	rx_dr <= data_ready;
end Behavioral;
