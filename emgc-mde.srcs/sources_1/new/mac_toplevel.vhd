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
    Port ( CLK100MHZ : in STD_LOGIC;
           -- Buttons/Switches
           btn : in STD_LOGIC_VECTOR(3 downto 0);
           sw : in STD_LOGIC_VECTOR(3 downto 0);
           -- LED pins
           led : out STD_LOGIC_VECTOR(3 downto 0);
           -- rs422 Pmod pins
           ja : inout STD_LOGIC_VECTOR(7 downto 0);
           -- dac Pmod pins
           jd : inout STD_LOGIC_VECTOR(7 downto 0)
           ); 
end mac_toplevel;

architecture Behavioral of mac_toplevel is
    signal clk_100, clk_timer, clk_RS422, clk_DAC : STD_LOGIC; -- clock signals
    signal reset, enable, limit, extend : STD_LOGIC;
    signal pitch_angle, roll_angle : STD_LOGIC_VECTOR(15 downto 0); 
    signal pitch_angle_lpf, roll_angle_lpf : STD_LOGIC_VECTOR(15 downto 0);
    signal pitch_voltage_raw, roll_voltage_raw : STD_LOGIC_VECTOR(15 downto 0);
    signal pitch_voltage, roll_voltage : STD_LOGIC_VECTOR(7 downto 0);
    
    signal pitch_lowpass_valid, roll_lowpass_valid : STD_LOGIC;
    signal pitch_pi_valid, roll_pi_valid : STD_LOGIC;
begin
    
    sysclk : entity work.sys_clk
    generic map (clk_timer_Hz => 256,
                 clk_RS422_Hz => 1600,
                 clk_DAC_Hz => 8000)
    port map (clk_in => CLK100MHZ,
              reset => reset,
              clk_100 => clk_100,
              clk_timer => clk_timer,
              clk_RS422 => clk_RS422,
              clk_DAC => clk_DAC);
    
    -- !! interface?
    rs422_in : entity work.rs422_interface 
    port map (sys_clk => clk_100,
              fast_clk => clk_RS422,
              rst => reset,
              rxd => ??,
              x_data => pitch_angle,
              y_data => roll_angle);
    
    -- GPIO interface (button/switch synchronizer)
    gpio : entity work.gpio_interface
    port map (clk => clk_100,
              reset_in => btn(0),
              enable_in => sw(0),
              limit_in => sw(1),
              reset_out => reset,
              enable_out => enable,
              limit_out => limit);
    led(0) <= enable;
    led(1) <= extend;
    
    -- controller module, lights led when mast signaled to extend
    control : entity work.mac_controller
    port map (clk => clk_100,
              rst => reset,
              timer_clock => clk_timer,
              master_enable => enable,
              mast_limit => limit,
              x_channel => pitch_angle_lpf,
              y_channel => roll_angle_lpf,
              mast_extend => extend);

    pitch_lowpass : entity work.lowpass
    port map (clk => clk_100,
              en => enable,
              rst => reset,
              input_data => pitch_angle,
              output_valid => pitch_lowpass_valid,
              output_data => pitch_angle_lpf);
    roll_lowpass : entity work.lowpass
    port map (clk => clk_100,
              en => enable,
              rst => reset,
              input_data => roll_angle,
              output_valid => roll_lowpass_valid,
              output_data => roll_angle_lpf);
    
    -- pi controller modules                                    
    pitch_pi_ctrl : entity work.pi_controller
    port map (clk => clk_100,
              rst => reset,
              input_valid => pitch_lowpass_valid,
              input_data => pitch_angle_lpf,
              output_valid => pitch_pi_valid,
              output_data => pitch_voltage_raw);
    roll_pi_ctrl : entity work.pi_controller
    port map (clk => clk_100,
              rst => reset,
              input_valid => roll_lowpass_valid,
              input_data => roll_angle_lpf,
              output_valid => roll_pi_valid,
              output_data => roll_voltage_raw);
              
    -- pi output modules
    pitch_pi_out : entity work.pi_output
    port map (input_data => pitch_voltage_raw,
              output_data => pitch_voltage);
    
    roll_pi_out : entity work.pi_output
    port map (input_data => roll_voltage_raw,
              output_data => roll_voltage);
    
    -- what are the rest of the output ports from this module?                                              
    dac_out : entity work.dac_interface
    port map (clk => clk_100,
              sclk => clk_DAC,
              x_data => pitch_voltage,
              y_data => roll_voltage);

end Behavioral;
