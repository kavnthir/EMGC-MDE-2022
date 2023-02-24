----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2023 07:08:18 PM
-- Design Name: 
-- Module Name: sys_clk_tb - Behavioral
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

entity sys_clk_tb is
end sys_clk_tb;

architecture Behavioral of sys_clk_tb is
    signal clk, rst : STD_LOGIC := '0';
    signal sysclk, tclk, iclk, oclk : STD_LOGIC;
begin

    UUT : entity work.sys_clk generic map (clk_timer_Hz => 250,
                                           clk_RS422_Hz => 400,
                                           clk_DAC_Hz => 1600)
                              port map (clk_in => clk,
                                        reset => rst,
                                        clk_100 => sysclk,
                                        clk_timer => tclk,
                                        clk_RS422 => iclk,
                                        clk_DAC => oclk);

    -- clock period of 10 ns                                       
    clk <= not clk after 10 ns;

    stimulus : process begin
        wait for 5 ns;
        rst <= '1', '0' after 20 ns;
        wait for 20 ns;
        
        wait for 1000 ms;
        
        STOP;
    end process;

end Behavioral;
