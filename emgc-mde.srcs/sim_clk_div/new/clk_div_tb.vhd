----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kaden Marlin
-- 
-- Create Date: 11/05/2022 06:02:21 PM
-- Design Name: 
-- Module Name: clk_div_tb - Behavioral
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

entity clk_div_tb is
end clk_div_tb;

architecture Behavioral of clk_div_tb is
    signal clk, reset_in : STD_LOGIC := '0';
    signal clk_100 : STD_LOGIC;
    
    signal reset_sync, rst : STD_LOGIC;
begin

    rst_sync : process (clk) begin
        if (RISING_EDGE(clk)) then
            reset_sync <= reset_in;
            rst <= reset_sync;
        end if;
    end process;

    clk_div_100 : entity work.clk_div 
    generic map (in_Hz => 100_000_000,
                 out_Hz => 10000)
    port map (rst => rst,
              clk_in => clk,
              clk_out => clk_100);    

    clk <= not clk after 10 ns;

    stimulus : process begin
        wait for 123 ns;
        reset_in <= '1';
        wait for 14583 ns;
        reset_in <= '0';
        wait for 10000000 ns;
        STOP;
    end process;
    
end Behavioral;
