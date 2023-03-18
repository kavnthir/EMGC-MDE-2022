----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 3/17/2023 05:33:29 PM
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

entity counter_8bit is
    Port ( clk :in STD_LOGIC;
           inc : in STD_LOGIC;
           dec : in STD_LOGIC;
           rst : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR(7 downto 0) );
end counter_8bit;

architecture Behavioral of counter_8bit is
    signal counter : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
begin
    process(rst,inc,dec) begin
  
        if (rst = '1') then 
           counter <=  "00000000";
        end if;
        
        if (clk'event and clk = '1') then
        
            if (inc = '1') then
                counter <= counter + '1';
            end if;
            
            if (dec = '1') then
                counter <= counter - '1';
            end if;
            
        end if;
        
    end process;
    count <= counter;
end Behavioral;