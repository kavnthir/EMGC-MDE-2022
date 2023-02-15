----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kaden Marlin, Kavin Thirukonda
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
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR(15 downto 0);
           output : out STD_LOGIC_VECTOR(7 downto 0)); -- DAC takes 8 bits of input
end pi_controller;

architecture Behavioral of pi_controller is
    -- !!! precompile math to solve for constants
    signal pi_response : STD_LOGIC_VECTOR(15 downto 0);
    signal pi_memory : STD_LOGIC_VECTOR(15 downto 0);
begin

    pi_response <= pi_memory; -- insert PI equation here as function of previous values
    
    -- !!! may want to have multi-stage circuit here
    
    output <= input; -- insert output scaling from 16 to 8 bit

end Behavioral;
