----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 11/05/2022 05:33:29 PM
-- Design Name: Four bit counter
-- Module Name: counter_4bit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_4bit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           overflow : out STD_LOGIC;
           count : out STD_LOGIC_VECTOR(3 downto 0) );
end counter_4bit;

architecture Behavioral of counter_4bit is
    signal counter : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
    signal of_detect : STD_LOGIC := '0';
begin
    process(rst,clk) begin
        if (counter = "0000") then
            of_detect <= '0';
        end if;

        if (rst = '1') then 
            counter <=  "0000";
        elsif (clk'event and clk = '1') then

            if (counter = "1111") then
                of_detect <= '1';
            end if;

            counter <= counter + '1';

        end if;
    end process;
    count <= counter;
    overflow <= of_detect;
end Behavioral;
