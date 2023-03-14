----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2023 05:49:14 PM
-- Design Name: 
-- Module Name: clk_div - Behavioral
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
use IEEE.MATH_REAL.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
begin

    process (clk_in) begin
        if (RISING_EDGE(clk_in)) then
            if (rst = '1') then
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
