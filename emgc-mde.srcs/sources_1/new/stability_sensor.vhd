----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE Department
-- Engineer: Kaden Marlin
-- 
-- Create Date: 01/23/2023 01:30:57 PM
-- Design Name: Mast Stability Sensing Comparator Module
-- Module Name: stability_sensor - Behavioral
-- Project Name: Extendable Mast Gimbal Controller (EMGC)
-- Target Devices: Arty A7 FPGA (xc7a100tcsg324-1)
-- Tool Versions: Xilinx Vivado
-- Description: Produces the Mast EXTEND signal. Senses when the angle error
--              data signal has come within a small range of zero degrees for
--              a certain amount of time before signaling for mast extension.
-- 
-- Dependencies: saturating_timer
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stability_sensor is
    Generic ( bit_precision : integer := 3); -- comparator precision
    Port ( clk : in STD_LOGIC;
           timer_clock : in STD_LOGIC;
           mast_enable: in STD_LOGIC;
           mast_limit : in STD_LOGIC;
           x_channel, y_channel : in STD_LOGIC_VECTOR(15 downto 0);
           mast_zeroed : out STD_LOGIC;
           mast_extend : out STD_LOGIC);
end stability_sensor;

architecture Behavioral of stability_sensor is
    constant comp_val : integer := 2**bit_precision; 
    signal int_x_channel, int_y_channel : integer;
    signal x_comp_wire, y_comp_wire : STD_LOGIC;
    signal timer_enable, timer_reset, timer_max : STD_LOGIC;
    signal mast_extend_sync : STD_LOGIC;
begin

    -- concurrent assign to signed integer
    int_x_channel <= TO_INTEGER(SIGNED(x_channel));
    int_y_channel <= TO_INTEGER(SIGNED(y_channel));

    -- synchronus comparators:
    -- x_comp_wire and y_comp_wire are '1' when
    -- the corresponding input is < 0.5 degrees (0b'7 in fixed point)
    s_comparator : process (clk) begin
        if (RISING_EDGE(clk)) then
            if (int_x_channel < comp_val and int_x_channel > -comp_val) then
                x_comp_wire <= '1';
            else
                x_comp_wire <= '0';
            end if;
            
            if (int_y_channel < comp_val and int_y_channel > -comp_val) then
                y_comp_wire <= '1';
            else
                y_comp_wire <= '0';
            end if;
        end if;
    end process;        
    
    timer_enable <= mast_enable and x_comp_wire and y_comp_wire;
    timer_reset <= not timer_enable;
    
    timer : entity work.saturating_timer
    port map (clk => timer_clock,
              en => timer_enable,
              rst => timer_reset,
              max => timer_max);
    
    mast_zeroed <= timer_enable;
    output_sync : process (clk) begin
        if (RISING_EDGE(clk)) then                                     
            mast_extend_sync <= mast_enable and timer_max and not mast_limit;
            mast_extend <= mast_extend_sync;
        end if;
    end process;

end Behavioral;
