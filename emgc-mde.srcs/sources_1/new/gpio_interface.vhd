----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2023 01:47:48 PM
-- Design Name: 
-- Module Name: gpio_interface - Behavioral
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

entity gpio_interface is
    Port ( clk : in STD_LOGIC;
           master_enable_in, mast_limit_in : in STD_LOGIC; -- input from board
           mast_extend_in, x_sign_bit_in, y_sign_bit_in : in STD_LOGIC; -- input from MAC
           mast_extend_out, x_sign_bit_out, y_sign_bit_out : out STD_LOGIC; -- output to board
           master_enable_out, mast_limit_out : out STD_LOGIC); -- output to MAC
end gpio_interface;

architecture Behavioral of gpio_interface is

begin

    -- synchronize and debounce (if necessary) for switches
    -- do any kind of preprocessing for the gpio pins,
    -- or just pass them through if not
    
    -- test if the switches/pins can be assigned in here instead of top-level

end Behavioral;
