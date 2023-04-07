----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2023 05:06:02 PM
-- Design Name: 
-- Module Name: saturating_timer_tb - Behavioral
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

entity saturating_timer_tb is
end saturating_timer_tb;

architecture Behavioral of saturating_timer_tb is
    
    signal clk, en, rst : STD_LOGIC := '0';
    signal max : STD_LOGIC;
    
begin

    UUT : entity work.maxout_timer port map (clk => clk,
                                             en => en,
                                             rst => rst,
                                             max => max);
    
    -- clock frequecy of 2 Hz                                         
    clk <= not clk after 1 ns;
    
    stimulus : process begin
        -- synchronus reset
        wait for 0.5 ns;
        rst <= '1', '0' after 1 ns;
        assert max = '0' report "reset failure" severity failure;
        
        -- two full loops
        wait until clk = '1';
        wait for 1.5 ns;
        en <= '1';
        
        wait until max = '1';
        assert max = '1' report "max was not set" severity failure;
        wait for 10 ns;
        assert max = '1' report "max did not stay set" severity failure;
        wait for 10 ns;
        
        rst <= '1', '0' after 3 ns;
        wait for 3 ns;
        assert max = '0' report "reset failure" severity failure;
        
        wait until max = '1';
        assert max = '1' report "max was not set" severity failure;
        wait for 10 ns;
        assert max = '1' report "max did not stay set" severity failure;
        wait for 10 ns;
        
        -- loops with reset in the middle
        rst <= '1', '0' after 3 ns;
        wait for 3 ns;
        assert max = '0' report "reset failure" severity failure;
        
        wait for 100 ns;
        en <= '0';
        wait for 10 ns;
        assert max = '0' report "max should not be reached after only 100ns" severity warning;
        en <= '1';
        wait for 100 ns;
        en <= '0';
        wait for 10 ns;
        assert max = '0' report "max should not be reached after only 200ns" severity warning;
        
        rst <= '1', '0' after 3 ns;
        wait for 3 ns;
        assert max = '0' report "reset failure" severity failure;
        
        en <= '1';
        wait until max = '1';
        assert max = '1' report "max was not set" severity failure;
        wait for 10 ns;
        assert max = '1' report "max did not stay set" severity failure;
        wait for 10 ns;
        
        -- imediate reset/switching
        -- off
        en <= '0';
        rst <= '1';
        wait for 10 ns;
        -- on
        en <= '1';
        rst <= '0';
        wait for 10 ns;
        -- off
        en <= '0';
        rst <= '1';
        wait for 10 ns;
        -- on
        en <= '1';
        rst <= '0';
        wait for 10 ns;
        
        -- single period
        -- off
        wait until clk = '1';
        en <= '0';
        rst <= '1';
        wait for 2 ns;
        -- on
        en <= '1';
        rst <= '0';
        wait for 2 ns;
        -- off
        en <= '0';
        rst <= '1';
        wait for 2 ns;
        -- on
        en <= '1';
        rst <= '0';
        wait for 2 ns;
        -- off
        en <= '0';
        rst <= '1';
        wait for 2 ns;
        
        STOP;
    end process;

end Behavioral;
