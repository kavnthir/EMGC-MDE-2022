----------------------------------------------------------------------------------
-- Company: Virginia Tech
-- Engineer: Kaden Marlin
-- 
-- Create Date: 01/23/2023 01:30:57 PM
-- Design Name: MAC Control Module
-- Module Name: mac_controller - Behavioral
-- Project Name: EMGC
-- Target Devices: -
-- Tool Versions: -
-- Description: Main control logic for the MAC. Senses when the angle error
--              signal has stabilized around zero, and signals mast extension.
-- 
-- Dependencies: maxout_timer.vhd
-- 
-- Revision: 1.0
-- Revision 0.01 - File Created
-- Additional Comments: Implements logic according to design diagram,
--                      corrections will likely be necessary.
--
-- !!! Currently untested
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mac_controller is
    Generic ( bit_precision : integer := 3); -- comparator precision
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           timer_clock : in STD_LOGIC; -- Fast clock to run timer
           master_enable: in STD_LOGIC; -- enable input from GPIO
           mast_limit : in STD_LOGIC; -- mast limit switch input from GPIO
           x_channel, y_channel : in STD_LOGIC_VECTOR(15 downto 0); -- filtered x and y angles
           mast_extend: out STD_LOGIC); -- mast extend output for GPIO
end mac_controller;

architecture Behavioral of mac_controller is
    constant comp_val : integer := 2**bit_precision; 
    signal int_x_channel, int_y_channel : integer;
    signal x_comp_wire, y_comp_wire : STD_LOGIC := '0';
    signal timer_enable, timer_reset, timer_max : STD_LOGIC := '0';
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
    
    timer_enable <= master_enable and x_comp_wire and y_comp_wire;
    timer_reset <= not timer_enable;
    
    -- set timer_clock to 256 Hz to maxout the 8-bit timer in 1 sec
    timer : entity work.maxout_timer
    port map (clk => timer_clock,
              en => timer_enable,
              rst => timer_reset,
              max => timer_max);
                                               
    mast_extend <= master_enable and timer_max and not mast_limit;

end Behavioral;
