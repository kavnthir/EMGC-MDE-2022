----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/23/2022 01:56:56 PM
-- Design Name: 
-- Module Name: my_lp_filter_tb - Behavioral
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

entity my_lp_filter_tb is
end my_lp_filter_tb;

architecture Behavioral of my_lp_filter_tb is
	--Input 
	file input_file : TEXT open READ_MODE is "testwave.txt";
	file output_file : TEXT open WRITE_MODE is "testwave_out.txt";
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
              input_data                       => data_in,
              output_data                       => data_out      );
	
	
	--setting up clock
	
	clk <= not clk after 50 ns;
	
	--clk <= not clk after 5 ms;
	
	
	
	--setting start values for tb
	process begin
	enable <= '0';
	reset <= '0';
	wait for 10 ns;
	reset <= '1';
	wait for 1000 ns;
	reset <= '0';
	enable <= '1';
	wait for 1000 ns;
	
	wait for 100000000 ns;
	end process;
	
	
	--Reads new input data into in_val at sample rate hz -> ns
	process(clk)
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
