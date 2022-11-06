----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 11/05/2022 02:06:28 AM
-- Design Name: 
-- Module Name: spi_master - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: counter_4bit.vhd
-- 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_master is
    Port ( clk : in STD_LOGIC;
           sclk : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR(15 downto 0);
           cs_out : out STD_LOGIC;
           din_out : out STD_LOGIC );
end spi_master;

architecture Behavioral of spi_master is
    signal rst : STD_LOGIC := '0';
    signal overflow : STD_LOGIC;
    signal count : STD_LOGIC_VECTOR(3 downto 0);
begin

    counter : entity work.counter_4bit port map (clk => sclk,
                                                 rst => rst,
                                                 overflow => overflow,
                                                 count => count);
                                                
    cs_out <= overflow;
    din_out <= data(TO_INTEGER(UNSIGNED(count)));

end Behavioral;
