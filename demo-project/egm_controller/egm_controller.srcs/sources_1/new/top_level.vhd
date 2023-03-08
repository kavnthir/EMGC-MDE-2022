----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 07:51:47 PM
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
  Port ( CLK100MHZ : in STD_LOGIC;
  btn : in STD_LOGIC_VECTOR (3 downto 0);
  sw : in STD_LOGIC_VECTOR (3 downto 0);
  led : out STD_LOGIC_VECTOR (3 downto 0)
);

end top_level;

architecture Behavioral of top_level is
signal clk_100 : STD_LOGIC;

begin




-- clock div from 100MHz to 100Hz and ?? Hz for RS422
clk_div_100 : entity work.clk_div 
generic map (in_Hz => 100_000_000,
             out_Hz => 1)
port map (rst => btn(0),
          clk_in => CLK100MHZ,
          clk_out => clk_100);


process (clk_100)
begin
    if (sw(0) = '1') then
    led(0) <= clk_100;
    else
    led(0) <= '0';
    end if;
    
end process;


end Behavioral;
