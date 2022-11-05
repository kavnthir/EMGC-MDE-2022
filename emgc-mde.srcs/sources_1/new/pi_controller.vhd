----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 11/04/2022 11:14:57 PM
-- Design Name: 
-- Module Name: pi_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: pi_imodule.vhd, pi_output.vhd, pi_pmodule.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pi_controller is
    Port ( clk : in STD_LOGIC; 
           data : out STD_LOGIC_VECTOR(15 downto 0)); -- DAC takes 16 bits of input
end pi_controller;

architecture Behavioral of pi_controller is

begin


end Behavioral;
