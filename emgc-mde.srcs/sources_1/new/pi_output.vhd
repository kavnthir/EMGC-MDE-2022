----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2022 09:39:06 AM
-- Design Name: 
-- Module Name: pi_output - Behavioral
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

entity pi_output is
    Port ( clk : in STD_LOGIC;
           p_input : in STD_LOGIC_VECTOR(7 downto 0);
           i_input : in STD_LOGIC_VECTOR(7 downto 0);
           output : out STD_LOGIC_VECTOR(7 downto 0));
end pi_output;

architecture Behavioral of pi_output is
-- Signal declarations (wires)
begin
-- Functional VHDL code (logic)

end Behavioral;
