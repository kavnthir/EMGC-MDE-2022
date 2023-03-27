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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pi_output is
    Port ( input_data : in STD_LOGIC_VECTOR(15 downto 0);
           output_data : out STD_LOGIC_VECTOR(7 downto 0));
end pi_output;

architecture Behavioral of pi_output is
-- Signal declarations (wires)
    signal input : SIGNED(15 downto 0);
    signal output : SIGNED(63 downto 0);

begin
-- Functional VHDL code (logic)

    input <= SIGNED(input_data); 
    output <= (255 * (((3 * input) / 16) + 160)) / 320;
    output_data <= STD_LOGIC_VECTOR(output(7 downto 0));

end Behavioral;
