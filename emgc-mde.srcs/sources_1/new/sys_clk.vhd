----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/25/2022 03:16:39 PM
-- Design Name: 
-- Module Name: sys_clk - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: temp file can be remade or modified at will
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

entity sys_clk is
    Port ( enable : in STD_LOGIC;
           clk : out STD_LOGIC; -- main sys_clk
           sclk : out STD_LOGIC; -- serial clock
           uclk : out STD_LOGIC); -- uart clock
end sys_clk;

architecture Behavioral of sys_clk is
-- Signal declarations (wires)
begin
-- Functional VHDL code (logic)

end Behavioral;
