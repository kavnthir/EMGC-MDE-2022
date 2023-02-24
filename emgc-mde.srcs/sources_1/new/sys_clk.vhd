----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/25/2022 03:16:39 PM
-- Design Name: 
-- Module Name: sys_clk - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: temp file can be remade or modified at will
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


-- !!! THIS MODULE does clock divisions for the various modules 

entity sys_clk is
    Generic ( input_Hz : integer := 50_000_000;
              clk_100_Hz : integer := 100;
              clk_timer_Hz : integer;
              clk_RS422_Hz : integer;
              clk_DAC_Hz : integer);
    Port ( clk_in : in STD_LOGIC; -- Input FPGA hardware clock
           reset : in STD_LOGIC; -- reset clock timers
           clk_100 : out STD_LOGIC; -- main sys_clk 100 Hz
           clk_timer : out STD_LOGIC; -- MAC stability timer
           clk_RS422 : out STD_LOGIC; -- RS422 deserializer clock
           clk_DAC : out STD_LOGIC); -- DAC serializer clock 
end sys_clk;

architecture Behavioral of sys_clk is

begin

    clk_div_100 : entity work.clk_div generic map (in_Hz => input_Hz,
                                                   out_Hz => clk_100_Hz)
                                      port map (rst => reset,
                                                clk_in => clk_in,
                                                clk_out => clk_100);
    
    clk_div_timer : entity work.clk_div generic map (in_Hz => input_Hz,
                                                     out_Hz => clk_timer_Hz)
                                        port map (rst => reset,
                                                  clk_in => clk_in,
                                                  clk_out => clk_timer);
                                                  
    clk_div_RS422 : entity work.clk_div generic map (in_Hz => input_Hz,
                                                     out_Hz => clk_RS422_Hz)
                                        port map (rst => reset,
                                                  clk_in => clk_in,
                                                  clk_out => clk_RS422);
                                               
    clk_div_DAC : entity work.clk_div generic map (in_Hz => input_Hz,
                                                   out_Hz => clk_DAC_Hz)
                                      port map (rst => reset,
                                                clk_in => clk_in,
                                                clk_out => clk_DAC);

end Behavioral;
    