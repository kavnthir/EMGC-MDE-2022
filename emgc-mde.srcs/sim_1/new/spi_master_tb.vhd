----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 11/05/2022 11:21:30 PM
-- Design Name: 
-- Module Name: spi_master_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.STOP;

entity spi_master_tb is
end spi_master_tb;

architecture Behavioral of spi_master_tb is
    signal clk : STD_LOGIC := '0';
    signal sclk : STD_LOGIC := '0';
    signal data : STD_LOGIC_VECTOR(15 downto 0);
    signal cs_out : STD_LOGIC;
    signal din_out : STD_LOGIC;
begin

    UUT : entity work.spi_master port map (clk => clk,
                                           sclk => sclk,
                                           data => data,
                                           cs_out => cs_out,
                                           din_out => din_out);

    sclk <= not sclk after 5 ns;

    stimulus : process begin
        data <= "1010101010101010";
        wait for 160 ns;
        data <= "0000111100001111";
        wait for 160 ns;
        STOP;
    end process;
end Behavioral;
