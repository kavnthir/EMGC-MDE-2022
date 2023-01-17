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
           input : in STD_LOGIC_VECTOR(15 downto 0);
           output : out STD_LOGIC_VECTOR(15 downto 0)); -- DAC takes 16 bits of input
end pi_controller;

architecture Behavioral of pi_controller is
    signal p_wire, i_wire : STD_LOGIC_VECTOR(15 downto 0);
begin

    pmodule : entity work.pi_pmodule port map (clk => clk,
                                               input => input,
                                               output => p_wire);
                                               
    imodule : entity work.pi_imodule port map (clk => clk,
                                               input => input,
                                               output => i_wire);
                                               
    omodule : entity work.pi_output port map (clk => clk,
                                              p_input => p_wire,
                                              i_input => i_wire,
                                              output => output);

end Behavioral;
