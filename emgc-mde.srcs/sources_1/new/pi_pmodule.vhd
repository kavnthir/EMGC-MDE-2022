----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2022 09:39:06 AM
-- Design Name: 
-- Module Name: pi_pmodule - Behavioral
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

entity pi_pmodule is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR(15 downto 0);
           output : out STD_LOGIC_VECTOR(15 downto 0));
end pi_pmodule;

architecture Behavioral of pi_pmodule is
-- Signal declarations (wires)
    constant Kp : integer := 3;
    signal int_input, int_output : integer; -- !!! consider using SIGNED(15 downto 0) instead
    
begin
-- Functional VHDL code (logic)
    int_input <= TO_INTEGER(unsigned(input));
    int_output <= int_input * Kp;
    output <= STD_LOGIC_VECTOR(TO_UNSIGNED(int_output, output'length));
    
end Behavioral;
