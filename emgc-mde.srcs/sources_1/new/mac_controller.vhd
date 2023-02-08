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
    Port ( clk : in STD_LOGIC; -- Fast clock to run timer
           master_enable: in STD_LOGIC; -- enable input from GPIO
           mast_limit : in STD_LOGIC; -- mast limit switch input from GPIO
           x_channel, y_channel : in STD_LOGIC_VECTOR(15 downto 0); -- filtered x and y angles
           sys_enable : out STD_LOGIC; -- enable for modules
           sys_reset : out STD_LOGIC; -- reset for modules
           mast_extend: out STD_LOGIC); -- mast extend output for GPIO
end mac_controller;

architecture Behavioral of mac_controller is
    signal int_x_channel, int_y_channel : integer;
    signal x_comp_wire, y_comp_wire : STD_LOGIC := '0';
    signal timer_enable, timer_reset, timer_max : STD_LOGIC := '0';
begin
    int_x_channel <= TO_INTEGER(SIGNED(x_channel));
    int_y_channel <= TO_INTEGER(SIGNED(y_channel));

    -- comparators:
    -- x_comp_wire and y_comp_wire are '1' when
    -- the corresponding input is < 0.5 degrees (fixed point)
    
    -- !!! maybe fix this by doing actual bit shift and compare instead of relying on integers
    process(clk) begin
        if (clk'event and clk = '1') then
            if (int_x_channel < 8 and int_x_channel > -8) then
                x_comp_wire <= '1';
            else
                x_comp_wire <= '0';
            end if;
            
            if (int_y_channel < 8 and int_y_channel > -8) then
                y_comp_wire <= '1';
            else
                y_comp_wire <= '0';
            end if;
        end if;
    end process;        
    
    -- control for timer starting/resetting
    -- always reset the timer to zero when comparison is false
    -- extend mast when stable untill the limit is hit
    timer_enable <= master_enable and x_comp_wire and y_comp_wire;
    timer_reset <= not timer_enable;
    
    timer : entity work.maxout_timer port map (clk => clk,
                                               en => timer_enable,
                                               rst => timer_reset,
                                               max => timer_max);
                                               
    mast_extend <= master_enable and timer_max and not mast_limit;
    
    -- !!! rework this for any changes to logic
    -- right now, the system enable for all other modules is just
    -- directly connected to the GPIO enable, so the controller will
    -- continue to stabilize the mast after it is fully extended
    sys_enable <= master_enable;
    sys_reset <= not master_enable;

end Behavioral;
