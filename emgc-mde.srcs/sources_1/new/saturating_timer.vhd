----------------------------------------------------------------------------------
-- Company: Virginia Tech
-- Engineer: Kaden Marlin
-- 
-- Create Date: 01/23/2023 02:57:53 PM
-- Design Name: Max-out Timer
-- Module Name: stability_sensor - Behavioral
-- Project Name: EMGC
-- Target Devices: -
-- Tool Versions: -
-- Description: 
-- clock automatically ticks up its value when enabled
-- stops counting and outputs HIGH on "max" when
-- it reaches its maximum value
-- resets to zero when rst is set HIGH
-- 
-- Dependencies: -
-- 
-- Revision: 1.0
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity saturating_timer is
    Generic ( bitsize : integer := 8);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           max : out STD_LOGIC);
end saturating_timer;

architecture Behavioral of saturating_timer is
    signal count : UNSIGNED(bitsize-1 downto 0);
    
begin

    timer : process (clk) begin
        if (RISING_EDGE(clk)) then
            if (rst = '1') then
                count <= (others => '0');
            elsif (en = '1' and count /= 2**bitsize-1) then
                count <= count + 1;
            end if;
        end if;
    end process;
    
    -- combinational output for max
    max <= '1' when count = 2**bitsize-1 else '0';

end Behavioral;
