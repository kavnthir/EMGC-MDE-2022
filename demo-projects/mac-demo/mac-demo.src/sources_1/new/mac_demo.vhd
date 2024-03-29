----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2023 11:45:28 AM
-- Design Name: 
-- Module Name: mac_demo - Behavioral
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

entity mac_demo is
    Port ( CLK100MHZ : in STD_LOGIC;
           -- Buttons/Switches
           btn : in STD_LOGIC_VECTOR(3 downto 0);
           sw : in STD_LOGIC_VECTOR(3 downto 0);
           led : out STD_LOGIC_VECTOR(3 downto 0);
           -- test GPIO in
           --speedgoat_16bit_in : in STD_LOGIC_VECTOR(15 downto 0);
           -- UART pins
           uart_rx : in STD_LOGIC;
           -- DAC pins
           ja : out STD_LOGIC_VECTOR (3 downto 0)
            ); 
end mac_demo;

architecture Behavioral of mac_demo is

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

    -- !!! for no-IO synthesis, use thise inputs
    -- map the four switches to x input * 4
--    GPIO_sync : process (clk_100) begin
--        speedgoat_16bit_in_sync <= speedgoat_16bit_in;
--        x_angle <= speedgoat_16bit_in_sync;
--    end process;
--    led(2) <= x_angle(0);
--    y_angle <= "0000000000" & sw(3 downto 0) & "00";

    pitch_out : entity work.pi_output
    port map (input_data => pitch_angle,
              output_data => pitch_volts);
    roll_out : entity work.pi_output
    port map (input_data => roll_angle,
              output_data => roll_volts);

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

----STABILITY CONTROLLER------------------------------------------------------
--    stability_control : entity work.stability_sensor
--    port map (clk => clk_100,
--              timer_clock => clk_timer,
--              mast_enable => enable,
--              mast_limit => limit,
--              x_channel => pitch_angle_lpf,
--              y_channel => roll_angle_lpf,
--              mast_zeroed => zeroed,
--              mast_extend => extend);
--
----LOWPASS FILTERS------------------------------------------------------
--    pitch_lowpass : entity work.lowpass
--    port map (clk => clk_100,
--              en => enable,
--              rst => reset,
--             input_data => pitch_angle,
--              output_data => pitch_angle_lpf);
--    roll_lowpass : entity work.lowpass
--    port map (clk => clk_100,
--              en => enable,
--              rst => reset,
--              input_data => roll_angle,
--              output_data => roll_angle_lpf);
--
----PI CONTROLLERS------------------------------------------------------
--    pitch_PI_controller : entity work.pi_controller 
--    port map (clk => clk_100,
--              rst => reset,
--              input_data => pitch_angle_lpf,
--              output_data => pitch_volts);
--    roll_PI_controller : entity work.pi_controller 
--    port map (clk => clk_100,
--              rst => reset,
--              input_data => roll_angle_lpf,
--              output_data => roll_volts);
    
end Behavioral;
