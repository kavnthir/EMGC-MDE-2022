----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 03:17:40 PM
-- Design Name: 
-- Module Name: datapath_tb - Behavioral
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

entity datapath_tb is
end datapath_tb;

architecture Behavioral of datapath_tb is

    signal clk_100M : STD_LOGIC := '1';
    signal clk_100 : STD_LOGIC;
    signal reset : STD_LOGIC := '0';
    signal input : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal output: STD_LOGIC_VECTOR(7 downto 0);

begin

    -- clock div from 100MHz to 100Hz and ?? Hz for RS422
    clk_div_100 : entity work.clk_div 
    generic map (in_Hz => 100_000_000,
                 out_Hz => 100)
    port map (rst => reset,
              clk_in => clk_100M,
              clk_out => clk_100);

    PI_controller : entity work.pi_controller 
    port map (clk => clk_100,
              rst => reset,
              input_data => input,
              output_data => output);
           
    -- Clock signal: 100MHz = 10ns period
    clk_100M <= not clk_100M after 5 ns;
              
    stimulus : process is
        file input_file : text;
        file output_file : text;
        variable in_line : line;
        variable in_val : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    begin
        file_open(input_file, "pi_test_in.txt", read_mode);
        file_open(output_file, "pi_test_out.txt", write_mode);
   
        wait until RISING_EDGE(clk_100); -- reset pulse
        reset <= '1';
        wait until RISING_EDGE(clk_100); -- reset pulse
        reset <= '0';
        wait until RISING_EDGE(clk_100); -- reset pulse
        
        while not endfile(input_file) loop
            readline(input_file, in_line);
            read(in_line, in_val);
            input <= in_val;
            wait until RISING_EDGE(clk_100); -- reset pulse
        end loop;
    
        STOP;
    end process;

end Behavioral;
