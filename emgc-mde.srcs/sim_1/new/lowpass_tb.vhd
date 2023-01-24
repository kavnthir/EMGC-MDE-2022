----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2022 07:09:54 PM
-- Design Name: 
-- Module Name: lowpass_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.STOP;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- require for writing/reading std_logic etc.
use ieee.numeric_std.all;

entity lowpass_tb is
--  Port ( );
end lowpass_tb;

architecture Behavioral of lowpass_tb is
    --Input 
	file input_file : TEXT open READ_MODE is "noisy_sine_wave.txt";
	file output_file : TEXT open WRITE_MODE is "filtered_sine_wave.txt";
	signal data_in : std_logic_vector(15 DOWNTO 0);
	signal data_out : std_logic_vector(15 DOWNTO 0);
	signal clk : std_logic := '0';
	signal sample : std_logic := '0';
	signal reset : std_logic := '0';
	signal enable : std_logic := '0';
	signal in_val : std_logic_vector(15 DOWNTO 0);
	
	
	begin
	
	 u_low_pass_filter: entity work.lowpass
	 PORT MAP (
              clk                              => clk,
              en                       => enable,
              rst                            => reset,
              input                       => data_in,
              output                       => data_out      );
	
	
	--setting up clock
	clk <= not clk after 50 ns;
	
	
	--setting start values for tb
	process begin
	enable <= '0';
	reset <= '0';
	wait for 10 ns;
	reset <= '1';
	wait for 10 ns;
	reset <= '0';
	enable <= '1';
	wait for 100000000 ns;
	end process;
	
	
	--Reads new input data into in_val at sample rate hz -> ns
	process(sample)
	variable input_line : line;
	variable in_var : std_logic_vector(15 DOWNTO 0);
	
	begin
	
	readline(input_file, input_line);
	read(input_line, in_var);
	in_val <= in_var;
	data_in <= in_val;
	end process;
	
	
	--Timer to simulate how fast adc is sampled
	process begin
	sample <= not sample ;
	wait for 100000 ns;
	end process;
	
	
	--Lowpass is active at everyclock edge
	process(clk) begin
	
	--if rising_edge(clk) then 
	
	--data_in <= in_val;
	--out_val <= data_out;
	--end if;

	
	end process;
	
	
	
	
	--process(clk) --maybe add risedge here
	--variable output_line : line;
	--variable out_val : std_logic_vector(15 DOWNTO 0);
	--begin
	
	--writeline(output_file, output_line);
	--write(output_line, data_out);
	
	--end process;
end Behavioral;
