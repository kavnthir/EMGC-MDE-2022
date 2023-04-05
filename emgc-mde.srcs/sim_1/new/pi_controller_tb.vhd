----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2023 05:05:43 PM
-- Design Name: 
-- Module Name: pi_controller_tb - Behavioral
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
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL; -- require for writing/reading std_logic etc.
use STD.ENV.STOP;

entity pi_controller_tb is
end pi_controller_tb;

architecture Behavioral of pi_controller_tb is
    signal clk : STD_LOGIC := '1';
    signal rst : STD_LOGIC := '0';
    signal input : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal output: STD_LOGIC_VECTOR(7 downto 0);
    
    --signal num_input : integer := 0;
begin

    UUT : entity work.pi_controller 
    port map (clk => clk,
              rst => rst,
              input_data => input,
              output_data => output);
              
    -- Clock signal: 1ns period
    clk <= not clk after 0.5 ns;
    
    --input <= STD_LOGIC_VECTOR(TO_SIGNED(num_input, input'length));
    
    stimulus : process is 
        file input_file : text;
        file output_file : text;
        variable in_line : line;
        variable in_val : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    begin
        file_open(input_file, "pi_test_in.txt", read_mode);
        file_open(output_file, "pi_test_out.txt", write_mode);
    
        wait for 1 ns; -- reset pulse
        rst <= '1';
        wait for 1 ns;
        rst <= '0';
        wait for 1 ns;
        
        --num_input <= 16;
        
        while not endfile(input_file) loop
            readline(input_file, in_line);
            read(in_line, in_val);
            input <= in_val;
            wait for 1 ns;
        end loop;
        
        wait for 1000 ns;
        STOP;
    end process;
    
    
    
end Behavioral;
