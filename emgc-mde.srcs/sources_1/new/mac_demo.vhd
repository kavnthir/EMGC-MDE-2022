----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2023 11:45:28 AM
-- Design Name: 
-- Module Name: mac_demo - Behavioral
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

entity mac_demo is
--  Port ( );
end mac_demo;

architecture Behavioral of mac_demo is

begin

-- clock div from 100MHz to 100Hz and ?? Hz for RS422
clk_div_100 : entity work.clk_div generic map (in_Hz => 100_000_000,
                                               out_Hz => 100)
                                  port map ()

-- RS422 interface
-- mac_controller with mast extend connected to an LED

end Behavioral;
