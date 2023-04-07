----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE Department
-- Engineer: Kaden Marlin
-- 
-- Create Date: 02/23/2023 05:49:14 PM
-- Design Name: Generic Clock Divider
-- Module Name: clk_div - Behavioral
-- Project Name: Extendable Mast Gimbal Controller (EMGC)
-- Target Devices: Arty A7 FPGA (xc7a100tcsg324-1)
-- Tool Versions: Xilinx Vivado
-- Description: A Generic clock divider module that takes
--              input frequency and output frequency in Hz
--              and computes the necessary math to produce
--              the desired clock frequency.
-- 
-- Dependencies: None
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity clk_div is 
    Generic ( in_Hz : integer;
              out_Hz : integer);
    Port ( rst : in STD_LOGIC;
           clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_div;

architecture Behavioral of clk_div is
    constant count_max : integer := in_Hz / (2 * out_Hz) - 1;
    constant bit_max : integer := integer(ceil(log2(real(count_max))));
    signal count : UNSIGNED(bit_max downto 0);
    signal div_clk : STD_LOGIC;
    signal rst_reg, rst_pulse : STD_LOGIC;
begin

    rst_pulse <= rst and not rst_reg;
    pulserst : process (clk_in) begin
        if (RISING_EDGE(clk_in)) then
            rst_reg <= rst;
        end if;
    end process;

    divider : process (clk_in) begin
        if (RISING_EDGE(clk_in)) then
            if (rst_pulse = '1') then
                count <= (others => '0');
                div_clk <= '1';
            elsif (count = count_max) then
                count <= (others => '0');
                div_clk <= not div_clk;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    clk_out <= div_clk;

end Behavioral;
