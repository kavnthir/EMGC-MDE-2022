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
           -- LED pins
           led : out STD_LOGIC_VECTOR(3 downto 0)
           -- rs422 Pmod pins
           -- dac Pmod pins
            );
end mac_demo;

architecture Behavioral of mac_demo is

    signal clk_100, clk_timer : STD_LOGIC;
    signal reset, enable, limit, extend : STD_LOGIC;
    signal x_angle, y_angle : STD_LOGIC_VECTOR(15 downto 0);
    signal x_volts, y_volts : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- clock div from 100MHz to 100Hz and ?? Hz for RS422
    clk_div_100 : entity work.clk_div 
    generic map (in_Hz => 100_000_000,
                 out_Hz => 100)
    port map (rst => reset,
              clk_in => CLK100MHZ,
              clk_out => clk_100);
    
    -- clock div from 100MHz to 256Hz
    clk_div_timer : entity work.clk_div
    generic map (in_Hz => 100_000_000,
                 out_Hz => 256)
    port map (rst => reset,
              clk_in => CLK100MHZ,
              clk_out => clk_timer);
    
    -- !!! for no-IO synthesis, use thise inputs
    -- map the four switches to x input * 4
    x_angle <= "0000000000" & sw(3 downto 0) & "00";
    y_angle <= (others => '0');
    
    -- controller module, lights led when mast signaled to extend
    control : entity work.mac_controller
    port map (clk => clk_100,
              rst => reset,
              timer_clock => clk_timer,
              master_enable => enable,
              mast_limit => limit,
              x_channel => x_angle,
              y_channel => y_angle,
              mast_extend => extend);
    
    -- output modules, disconnected for synthesis
    x_pi_out : entity work.pi_output
    port map (input_data => x_angle,
              output_data => x_volts);
    
    y_pi_out : entity work.pi_output
    port map (input_data => y_angle,
              output_data => y_volts);
    
    -- GPIO interface (button/switch synchronizer)
    gpio : entity work.gpio_interface
    port map (clk => clk_100,
              reset_in => btn(0),
              enable_in => '1',--sw(0),
              limit_in => '0',--sw(1),
              reset_out => reset,
              enable_out => enable,
              limit_out => limit);
    
    led(0) <= enable;
    led(1) <= extend;
    
end Behavioral;
