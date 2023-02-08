----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2023 12:51:36 AM
-- Design Name: 
-- Module Name: mac_controller_tb - Behavioral
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

entity mac_controller_tb is
end mac_controller_tb;

architecture Behavioral of mac_controller_tb is
    signal clk : STD_LOGIC;
    signal master_enable, mast_limit : STD_LOGIC := '0'; -- inputs from GPIO
    signal x_channel, y_channel : STD_LOGIC_VECTOR(15 downto 0);
    signal sys_enable, sys_reset, mast_extend : STD_LOGIC; -- outputs from controller

begin

    UUT : entity work.mac_controller port map (clk => clk,
                                               master_enable => master_enable,
                                               mast_limit => mast_limit,
                                               x_channel => x_channel,
                                               y_channel => y_channel,
                                               sys_enable => sys_enable,
                                               sys_reset => sys_reset,
                                               mast_extend => mast_extend);
    
    -- clock frequecy of 2 Hz                                         
    clk <= not clk after 1 ns;

    stimulus : process begin
        -- start at +15 degrees to test out control combinations,
        -- then switch to -15 degrees and keep switching +/-
        -- untill the value is < 0.5 (8)
        STOP;
    end process;

end Behavioral;
