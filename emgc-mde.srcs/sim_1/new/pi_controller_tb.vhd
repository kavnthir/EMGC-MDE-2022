----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2023 05:05:43 PM
-- Design Name: 
-- Module Name: pi_controller_tb - Behavioral
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
use STD.ENV.STOP;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pi_controller_tb is
end pi_controller_tb;

architecture Behavioral of pi_controller_tb is
    signal clk, rst : STD_LOGIC := '0';
    signal input : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal output: STD_LOGIC_VECTOR(15 downto 0);
begin

    UUT : entity work.pi_pmodule port map (clk => clk,
                                           input => input,
                                           output => output);
    -- Clock signal: 20ns period
    clk <= not clk after 10 ns;
    
    --stimulus : process begin
        --wait for 5 ns;
        --input <= STD_LOGIC_VECTOR(TO_SIGNED(1, input'length));
        --wait for 20 ns;
        --input <= STD_LOGIC_VECTOR(TO_SIGNED(2, input'length));
        --wait for 20 ns;
        --input <= STD_LOGIC_VECTOR(TO_SIGNED(-3, input'length));
        --wait for 20 ns;
        --input <= STD_LOGIC_VECTOR(TO_SIGNED(0, input'length));
        --wait for 20 ns;
        --STOP;
    --end process;
    
    
    
end Behavioral;
