----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE Department
-- Engineer: Kaden Marlin
-- 
-- Create Date: 01/23/2023 02:57:53 PM
-- Design Name: Saturating Timer Module
-- Module Name: saturating_timer - Behavioral
-- Project Name: Extendable Mast Gimbal Controller (EMGC)
-- Target Devices: Arty A7 FPGA (xc7a100tcsg324-1)
-- Tool Versions: Xilinx Vivado
-- Description: A standard saturating timer, which will count
--              up when enabled and output a single bit when its
--              maximum has been reached, rather than rolling over.
-- 
-- Dependencies: None
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
