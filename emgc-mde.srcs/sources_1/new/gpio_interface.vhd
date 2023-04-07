----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE Department
-- Engineer: Kaden Marlin
-- 
-- Create Date: 01/23/2023 01:47:48 PM
-- Design Name: GPIO Synchronizer Interface
-- Module Name: gpio_interface - Behavioral
-- Project Name: Extendable Mast Gimbal Controller (EMGC)
-- Target Devices: Arty A7 FPGA (xc7a100tcsg324-1)
-- Tool Versions: Xilinx Vivado
-- Description: Contains synchronizers for GPIO control
--              inputs, where reset is synchronized to 
--              the system clock, labeled clk.
-- 
-- Dependencies: None
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gpio_interface is
    Port ( clk, data_clock : in STD_LOGIC;
           reset_in, enable_in, limit_in : in STD_LOGIC;
           reset_out, enable_out, limit_out : out STD_LOGIC);
end gpio_interface;

architecture Behavioral of gpio_interface is
    signal reset_sync, enable_sync, limit_sync : STD_LOGIC;
begin

    sync_reset : process (clk) begin
        if (RISING_EDGE(clk)) then
            reset_sync <= reset_in;
            reset_out <= reset_sync;
        end if;
    end process;

    sync_controls : process (data_clock) begin
        if (RISING_EDGE(data_clock)) then
            enable_sync <= enable_in;
            limit_sync <= limit_in;
            enable_out <= enable_sync;
            limit_out <= limit_sync;
        end if;
    end process;

end Behavioral;
