----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2023 01:47:48 PM
-- Design Name: 
-- Module Name: gpio_interface - Behavioral
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

entity gpio_interface is
    Port ( clk, data_clock : in STD_LOGIC;
           reset_in, enable_in, limit_in : in STD_LOGIC;
           reset_out, enable_out, limit_out : out STD_LOGIC);
end gpio_interface;

architecture Behavioral of gpio_interface is
    
    signal reset_sync, enable_sync, limit_sync : STD_LOGIC;
    
begin

    process (clk) begin
        if (RISING_EDGE(clk)) then
            reset_sync <= reset_in;
            reset_out <= reset_sync;
        end if;
    end process;

    process (data_clock) begin
        if (RISING_EDGE(data_clock)) then
            enable_sync <= enable_in;
            limit_sync <= limit_in;
            enable_out <= enable_sync;
            limit_out <= limit_sync;
        end if;
    end process;

end Behavioral;
