----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 11/05/2022 06:02:21 PM
-- Design Name: 
-- Module Name: counter_4bit_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.STOP;

entity counter_4bit_tb is
end counter_4bit_tb;

architecture Behavioral of counter_4bit_tb is
    signal clk, rst : STD_LOGIC := '0';
    signal overflow : STD_LOGIC;
    signal count : STD_LOGIC_VECTOR(3 downto 0);
begin

    UUT : entity work.counter_4bit port map (clk =>  clk,
                                             rst => rst,
                                             overflow => overflow, 
                                             count => count);     

    clk <= not clk after 10 ns;

    stimulus : process begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 480 ns;
        STOP;
    end process;
end Behavioral;
