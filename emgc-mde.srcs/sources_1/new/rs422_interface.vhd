----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- -- Create Date: 11/04/2022 11:23:19 PM -- Design Name: 
-- Module Name: rs422_interface - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rs422_interface is
    Port ( sys_clk, fast_clk : in STD_LOGIC;
		   rst : in STD_LOGIC;
		   rxd : in STD_LOGIC;
           x_data, y_data : out STD_LOGIC_VECTOR(15 downto 0));
end rs422_interface;

architecture Behavioral of rs422_interface is
	signal data : STD_LOGIC_VECTOR(7 downto 0);
	signal rx_data_ready : STD_LOGIC;
	signal reg_bus_0, 
		   reg_bus_1, 
		   reg_bus_2, 
		   reg_bus_3, 
		   reg_bus_4, 
		   reg_bus_5, 
		   reg_bus_6, 
		   reg_bus_7 : STD_LOGIC_VECTOR(7 downto 0);
	signal load_clk : STD_LOGIC;
	signal data_valid : STD_LOGIC_VECTOR(23 downto 0);
	signal x_data_raw : STD_LOGIC_VECTOR(15 downto 0);
	signal y_data_raw : STD_LOGIC_VECTOR(15 downto 0);
begin

	load_clk_8bit <= rx_data_ready AND sys_clk;
	load_clk_16bit <= data_valid AND sys_clk; -- may replace sys_clk with 100Hz clk as IMU polling goes no greater than that

	data_valid_check <= reg_bus_7 & reg_bus_6 & reg_bus_5;
	data_valid <= '1' when data_valid_check = x"ABCDEF" else '0';

	x_data_raw <= reg_bus_4 & reg_bus_3;
	y_data_raw <= reg_bus_2 & reg_bus_1;

	uart_reciever : entity work.uart_rx
		port map ( 
			clk => sys_clk,
			rst => rst,
			rx_di => rxd,
			rx_do => data,
			rx_dr => rx_data_ready);

	reg_16bit_x : entity work.register_16bit
		port map (
			clk => load_clk_16bit,
			rst => rst,
			D => x_data_raw,
			Q => x_data);

	reg_16bit_y : entity work.register_16bit
		port map (
			clk => load_clk_16bit,
			rst => rst,
			D => y_data_raw,
			Q => y_data);
	
	-- Refactor below instantiations into 8 bit FIFO module
	reg_8bit_0 : entity work.register_8bit
		port map (
			clk => load_clk_8bit,
			rst => rst,
			D => data,
			Q => reg_bus_0);

	reg_8bit_1 : entity work.register_8bit
		port map (
			clk => load_clk_8bit,
			rst => rst,
			D => reg_bus_0,
			Q => reg_bus_1);

	reg_8bit_2 : entity work.register_8bit
		port map (
			clk => load_clk_8bit,
			rst => rst,
			D => reg_bus_1,
			Q => reg_bus_2);

	reg_8bit_3 : entity work.register_8bit
		port map (
			clk => load_clk_8bit,
			rst => rst,
			D => reg_bus_2,
			Q => reg_bus_3);

	reg_8bit_4 : entity work.register_8bit
		port map (
			clk => load_clk_8bit,
			rst => rst,
			D => reg_bus_3,
			Q => reg_bus_4);

	reg_8bit_5 : entity work.register_8bit
		port map (
			clk => load_clk_8bit,
			rst => rst,
			D => reg_bus_4,
			Q => reg_bus_5);

	reg_8bit_6 : entity work.register_8bit
		port map (
			clk => load_clk_8bit,
			rst => rst,
			D => reg_bus_5,
			Q => reg_bus_6);

	reg_8bit_7 : entity work.register_8bit
		port map (
			clk => load_clk_8bit,
			rst => rst,
			D => reg_bus_6,
			Q => reg_bus_7);

end Behavioral;
