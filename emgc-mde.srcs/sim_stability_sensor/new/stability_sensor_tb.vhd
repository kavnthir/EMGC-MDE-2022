----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE Department
-- Engineer: Kaden Marlin
-- 
-- Create Date: 04/07/2023 04:49:42 PM
-- Design Name: Stability Sensor Testbench
-- Module Name: stability_sensor_tb - Simulation
-- Project Name: Extendable Mast Gimbal Controller (EMGC)
-- Target Devices: Vivado Simulator
-- Tool Versions: Xilinx Vivado
-- Description: Verifies functionality of stability sensor and
--              clock dividers with test input and reset pulse.
-- 
-- Dependencies: stability_sensor, saturating_timer, clk_div
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.STOP;

entity stability_sensor_tb is
end stability_sensor_tb;

architecture Simulation of stability_sensor_tb is

    signal clk_100M : STD_LOGIC := '0';
    signal clk_100, clk_timer : STD_LOGIC;
    signal reset_in : STD_LOGIC := '0';
    signal reset_sync, rst : STD_LOGIC;
    signal mast_enable, mast_limit : STD_LOGIC := '0'; -- inputs from GPIO
    signal x_int_channel, y_int_channel : integer := 0;
    signal x_channel, y_channel : STD_LOGIC_VECTOR(15 downto 0);
    signal mast_zeroed, mast_extend : STD_LOGIC; -- outputs from controller

begin

    x_channel <= STD_LOGIC_VECTOR(TO_SIGNED(x_int_channel, x_channel'length));
    y_channel <= STD_LOGIC_VECTOR(TO_SIGNED(y_int_channel, y_channel'length));

   rst_sync : process (clk_100M) begin
        if (RISING_EDGE(clk_100M)) then
            reset_sync <= reset_in;
            rst <= reset_sync;
        end if;
    end process;

    clk_div_100 : entity work.clk_div 
    generic map (in_Hz => 100_000_000,
                 out_Hz => 10000)
    port map (rst => rst,
              clk_in => clk_100M,
              clk_out => clk_100);

    clk_div_timer : entity work.clk_div
    generic map (in_Hz => 100_000_000,
                 out_Hz => 12800)
    port map (rst => rst,
              clk_in => clk_100M,
              clk_out => clk_timer);
              
    UUT : entity work.stability_sensor
    port map (clk => clk_100,
              timer_clock => clk_timer,
              mast_enable => mast_enable,
              mast_limit => mast_limit,
              x_channel => x_channel,
              y_channel => y_channel,
              mast_zeroed => mast_zeroed,
              mast_extend => mast_extend);
    
    -- clock period of 10 ns                                       
    clk_100M <= not clk_100M after 5 ns;

    stimulus : process begin
        -- reset clock dividers
        wait for 123 ns;
        reset_in <= '1';
        wait for 14583 ns;
        reset_in <= '0';
        wait for 585394 ns;
        
        -- reset/setup (reset is linked to master_enable switch)
        wait until RISING_EDGE(clk_100);
        mast_enable <= '1';
        wait until RISING_EDGE(clk_100);
        x_int_channel <= 15;
        y_int_channel <= -15;
        wait until RISING_EDGE(clk_100);
        -- start at +15 degrees to test out control combinations,
        -- then switch to -15 degrees and keep switching +/-
        -- untill the value is < 0.5 (8)
        for i in 1 to 15 loop
            x_int_channel <= x_int_channel - 1;
            y_int_channel <= y_int_channel + 1;
            wait until RISING_EDGE(clk_100);
        end loop;
        
        wait until mast_extend = '1';
        wait until RISING_EDGE(clk_100);
        mast_limit <= '1';
        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);

        STOP;
    end process;
    
end Simulation;
