----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 11/04/2022 11:16:59 PM
-- Design Name: Digital To Analog Pmod Interface
-- Module Name: dac_interface - Behavioral
-- Project Name: 
-- Target Devices: Arty A7: Artix-7, Digilent PmodDA3
-- Tool Versions: Vivado v2022.2 (64-bit)
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

entity dac_interface is
    Port ( clk : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR(15 downto 0);
           cs : out STD_LOGIC;
           din : out STD_LOGIC;
           ldac : out STD_LOGIC;
           sclk : out STD_LOGIC ); 
end dac_interface;

architecture Behavioral of dac_interface is

begin


end Behavioral;
