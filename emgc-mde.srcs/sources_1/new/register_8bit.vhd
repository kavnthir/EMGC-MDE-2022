----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 11/05/2022 05:33:29 PM
-- Design Name: Eight bit register
-- Module Name: register_8bit - Behavioral
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

entity register_8bit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR(7 downto 0);
           Q : out STD_LOGIC_VECTOR(7 downto 0) );
end register_8bit;

architecture Behavioral of register_8bit is
    signal data : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(clk) begin
		if (clk = '1' and clk'event) then
			if (rst = '1') then
				data <= (others => '0');
			else
				data <= D;
			end if;
		else 
			data <= data;
		end if;
    end process;
    Q <= data;
end Behavioral;
