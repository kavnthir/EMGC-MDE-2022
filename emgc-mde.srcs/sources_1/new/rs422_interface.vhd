----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2022 11:23:19 PM
-- Design Name: 
-- Module Name: rs422_interface - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rs422_interface is
    Port ( sys_clk, fast_clk, enable : in STD_LOGIC;
           -- Pmod pins
           x_data, y_data : out STD_LOGIC_VECTOR(15 downto 0));
end rs422_interface;

architecture Behavioral of rs422_interface is

begin


end Behavioral;
