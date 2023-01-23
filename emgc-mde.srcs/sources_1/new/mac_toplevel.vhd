----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kaden Marlin, Kavin Thirukonda
-- 
-- Create Date: 11/04/2022 11:20:53 PM
-- Design Name: 
-- Module Name: mac_toplevel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: pi_controller.vhd, 
--               dac_interface.vhd, 
--               rs422_interface.vhd, 
--               sys_clk.vhd
-- 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mac_toplevel is
-- Port ( ); 
-- 4 output ports to DAC pmod pins, X input ports for RS422 pmod pins (defined in fpga datasheet)
end mac_toplevel;

architecture Behavioral of mac_toplevel is
    signal enable : STD_LOGIC := '1'; -- global enable
    signal master_enable, mast_limit, mast_extend : STD_LOGIC; -- global input output signals
    signal clk, sclk, uclk : STD_LOGIC; -- clock signals
    signal sys_enable, sys_reset : STD_LOGIC; -- control signals from control logic
    signal x_input_wire, x_lpf_wire, x_output_wire : STD_LOGIC_VECTOR(15 downto 0); 
    signal y_input_wire, y_lpf_wire, y_output_wire : STD_LOGIC_VECTOR(15 downto 0);
begin

    -- enable for sys_clock and rs422_interface should always be on
    -- clock signals need to be reworked.
    sysclk : entity work.sys_clk port map (enable => enable,
                                           clk => clk,
                                           sclk => sclk,
                                           uclk => uclk);
    
    rs422_in : entity work.rs422_interface port map (clk => uclk,
                                                     en => enable,
                                                     x_data => x_input_wire,
                                                     y_data => y_input_wire);
    
    gpio_in : entity work.gpio_interface port map (clk => clk,
                                                   mast_extend => mast_extend,
                                                   master_enable => master_enable,
                                                   mast_limit => mast_limit);
    
    mac_ctrl : entity work.mac_controller port map (clk => clk,
                                                    master_enable => master_enable,
                                                    mast_limit => mast_limit,
                                                    x_channel => x_lpf_wire,
                                                    y_channel => y_lpf_wire,
                                                    sys_enable => sys_enable,
                                                    sys_reset => sys_reset,
                                                    mast_extend => mast_extend);

    x_lowpass : entity work.lowpass port map (clk => clk,
                                              en => sys_enable,
                                              rst => sys_reset,
                                              input => x_input_wire,
                                              output => x_lpf_wire);
    y_lowpass : entity work.lowpass port map (clk => clk,
                                              en => sys_enable,
                                              rst => sys_reset,
                                              input => y_input_wire,
                                              output => y_lpf_wire);
                                          
    x_pi_ctrl : entity work.pi_controller port map (clk => clk,
                                                    en => sys_enable,
                                                    rst => sys_reset,
                                                    input => x_lpf_wire,
                                                    output => x_output_wire);
    y_pi_ctrl : entity work.pi_controller port map (clk => clk,
                                                    en => sys_enable,
                                                    rst => sys_reset,
                                                    input => y_lpf_wire,
                                                    output => y_output_wire);
    
    -- what are the rest of the output ports from this module?                                              
    dac_out : entity work.dac_interface port map (clk => clk,
                                                  sclk => sclk,
                                                  x_data => x_output_wire,
                                                  y_data => y_output_wire);

end Behavioral;
