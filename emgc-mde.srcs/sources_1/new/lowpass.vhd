----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2022 09:39:06 AM
-- Design Name: 
-- Module Name: lowpass - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lowpass is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR(7 downto 0);
           output : out STD_LOGIC_VECTOR(7 downto 0));
end lowpass;

architecture Behavioral of lowpass is
-- Signal declarations (wires)
    constant K1 : integer := 3;
    constant K2 : integer := 3;
    constant denom : integer := 16;
    signal int_input, int_prev, int_output: integer;
    
begin
-- Functional VHDL code (logic)
    int_input <= TO_INTEGER(unsigned(input));
    int_prev <= int_input;
    int_output <= ((K1 * int_input) + (K2 * int_prev)) / denom;
    output <= STD_LOGIC_VECTOR(TO_UNSIGNED(int_output, output'length));

end Behavioral;
