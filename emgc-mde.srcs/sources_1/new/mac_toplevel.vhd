----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE Department
-- Engineer: Kaden Marlin, Kavin Thirukonda
-- 
-- Create Date: 11/04/2022 11:20:53 PM
-- Design Name: Mast Assemby Controller (MAC)
-- Module Name: mac_toplevel - Behavioral
-- Project Name: Extendable Mast Gimbal Controller (EMGC)
-- Target Devices: Arty A7 FPGA (xc7a100tcsg324-1)
-- Tool Versions: Xilinx Vivado
-- Description: MAC toplevel module. Connects the below
--              modules for synthesis with Arty A7 FPGA.
-- 
-- Dependencies: clk_div, gpio_interface, stability_sensor, 
--               lowpass, pi_controller, uart_interface,
--               pmod_dac_ad7303
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mac_toplevel is
    Port ( CLK100MHZ : in STD_LOGIC;
           -- Buttons/Switches/LEDs
           btn : in STD_LOGIC_VECTOR(3 downto 0);
           sw : in STD_LOGIC_VECTOR(3 downto 0);
           led : out STD_LOGIC_VECTOR(3 downto 0);
           -- UART pins
           uart_rx : in STD_LOGIC;
           -- DAC Pmod pins
           ja : inout STD_LOGIC_VECTOR(3 downto 0)
           ); 
end mac_toplevel;

architecture Behavioral of mac_toplevel is
    
--CLOCKS------------------------------------------------------
    signal clk_100M, clk_100, clk_timer : STD_LOGIC;
    
--CONTROL SIGNALS------------------------------------------------------
    signal reset : STD_LOGIC;
    signal enable : STD_LOGIC;
    signal limit : STD_LOGIC;
    
--STATUS SIGNALS------------------------------------------------------
    signal zeroed : STD_LOGIC;
    signal extend : STD_LOGIC;
    
--DATA SIGNALS------------------------------------------------------
    signal pitch_angle, roll_angle : STD_LOGIC_VECTOR(15 downto 0);
    signal pitch_angle_lpf, roll_angle_lpf : STD_LOGIC_VECTOR(15 downto 0);
    signal pitch_volts, roll_volts : STD_LOGIC_VECTOR(7 downto 0);
    
--UART SIGNALS------------------------------------------------------
    
--DAC SIGNALS------------------------------------------------------
    signal dac_busy : STD_LOGIC;
    signal D0, D1 : STD_LOGIC;
    signal sclk : STD_LOGIC;
    signal sync_n : STD_LOGIC_VECTOR(0 DOWNTO 0);

begin

--CONNECTIONS------------------------------------------------------
    clk_100M <= CLK100MHZ;
    
    led(0) <= enable;
    led(1) <= zeroed;
    led(2) <= extend;
    
    ja <= sclk & D1 & D0 & sync_n;

--MODULES------------------------------------------------------

--CLOCK DIV------------------------------------------------------
    clk_div_100 : entity work.clk_div 
    generic map (in_Hz => 100_000_000,
                 out_Hz => 100)
    port map (rst => reset,
              clk_in => clk_100M,
              clk_out => clk_100);
    clk_div_timer : entity work.clk_div
    generic map (in_Hz => 100_000_000,
                 out_Hz => 128)
    port map (rst => reset,
              clk_in => clk_100M,
              clk_out => clk_timer);
              
--I/O CONTROLLERS------------------------------------------------------
    control_sync : entity work.gpio_interface
    port map (clk => clk_100M,
              data_clock => clk_100,
              reset_in => btn(0),
              enable_in => sw(0),
              limit_in => sw(1),
              reset_out => reset,
              enable_out => enable,
              limit_out => limit);
    uart_interface : entity work.uart_interface
    port map (sys_clk => clk_100M,
              rst => reset,
              rxd => uart_rx,
              x_data => pitch_angle,
              y_data => roll_angle);
    dac_interface : entity work.pmod_dac_ad7303
    port map (clk => clk_100M,
              reset_n => '1',
              dac_tx_ena => '1',
              dac_1_ctrl => "110000",
              dac_1_data => pitch_volts,
              dac_2_ctrl => "110000",
              dac_2_data => roll_volts,
              busy => dac_busy,
              mosi_0 => D0,
              mosi_1 => D1,
              sclk => sclk,
              ss_n => sync_n);       

--STABILITY CONTROLLER------------------------------------------------------
    stability_module : entity work.stability_sensor
    port map (clk => clk_100,
              timer_clock => clk_timer,
              mast_enable => enable,
              mast_limit => limit,
              x_channel => pitch_angle_lpf,
              y_channel => roll_angle_lpf,
              mast_zeroed => zeroed,
              mast_extend => extend);

--LOWPASS FILTERS------------------------------------------------------
    pitch_lowpass : entity work.lowpass
    port map (clk => clk_100,
              en => enable,
              rst => reset,
              input_data => pitch_angle,
              output_data => pitch_angle_lpf);
    roll_lowpass : entity work.lowpass
    port map (clk => clk_100,
              en => enable,
              rst => reset,
              input_data => roll_angle,
              output_data => roll_angle_lpf);

--PI CONTROLLERS------------------------------------------------------
    pitch_PI_controller : entity work.pi_controller 
    port map (clk => clk_100,
              rst => reset,
              input_data => pitch_angle_lpf,
              output_data => pitch_volts);
    roll_PI_controller : entity work.pi_controller 
    port map (clk => clk_100,
              rst => reset,
              input_data => roll_angle_lpf,
              output_data => roll_volts);

end Behavioral;
