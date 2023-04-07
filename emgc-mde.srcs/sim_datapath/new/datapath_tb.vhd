----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE Department
-- Engineer: Kaden Marlin
-- 
-- Create Date: 03/29/2023 03:17:40 PM
-- Design Name: Full Datapath Testbench
-- Module Name: datapath_tb - Simulation
-- Project Name: Extendable Mast Gimbal Controller (EMGC)
-- Target Devices: Vivado Simulator
-- Tool Versions: Xilinx Vivado
-- Description: Verifies full datapath functionality with an input file.
--              All modules except I/O are simulated here.
-- 
-- Dependencies: clk_div, gpio_interface, stability_sensor,
--               saturating_timer, pi_controller, lowpass
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL; -- require for writing/reading std_logic etc.
use STD.ENV.STOP;

entity datapath_tb is
end datapath_tb;

architecture Simulation of datapath_tb is

--CLOCKS------------------------------------------------------
    signal clk_100M : STD_LOGIC := '0';
    signal clk_100, clk_timer : STD_LOGIC;
    
--CONTROL SIGNALS------------------------------------------------------
    signal reset_in : STD_LOGIC := '0';
    signal enable_in : STD_LOGIC := '1';
    signal limit_in : STD_LOGIC := '0';

    signal reset : STD_LOGIC;
    signal enable : STD_LOGIC;
    signal limit : STD_LOGIC;
    
 --STATUS SIGNALS------------------------------------------------------
    signal zeroed : STD_LOGIC;
    signal extend : STD_LOGIC;
    
 --DATA SIGNALS------------------------------------------------------
    signal pitch_angle, roll_angle : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal pitch_angle_lpf, roll_angle_lpf : STD_LOGIC_VECTOR(15 downto 0);
    signal pitch_volts, roll_volts : STD_LOGIC_VECTOR(7 downto 0);

begin

--CONNECTIONS------------------------------------------------------


--MODULES------------------------------------------------------

--CLOCK DIV------------------------------------------------------
    clk_div_100 : entity work.clk_div 
    generic map (in_Hz => 100_000_000,
                 out_Hz => 10000)
    port map (rst => reset,
              clk_in => clk_100M,
              clk_out => clk_100);

    clk_div_timer : entity work.clk_div
    generic map (in_Hz => 100_000_000,
                 out_Hz => 12800)
    port map (rst => reset,
              clk_in => clk_100M,
              clk_out => clk_timer);

--I/O CONTROLLERS------------------------------------------------------
    control_sync : entity work.gpio_interface
    port map (clk => clk_100M,
              data_clock => clk_100,
              reset_in => reset_in,
              enable_in => enable_in,
              limit_in => limit_in,
              reset_out => reset,
              enable_out => enable,
              limit_out => limit);

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
              

--TESTBENCH------------------------------------------------------

--CLOCK 100MHz------------------------------------------------------
    clk_100M <= not clk_100M after 5 ns;

--STIMULUS------------------------------------------------------         
    stimulus : process is
        file input_file : text;
        file output_file : text;
        variable in_line : line;
        variable in_val : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    begin
        -- INPUT FILE MUST BE LOCATED IN: ./emgc-mde.sim/sim_datapath/behav/xsim
        file_open(input_file, "pi_test_in.txt", read_mode);
        file_open(output_file, "pi_test_out.txt", write_mode);
   
        -- reset clock dividers
        wait for 123 ns;
        reset_in <= '1';
        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);
        reset_in <= '0';

        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);
        wait until RISING_EDGE(clk_100);
        
        while not endfile(input_file) loop
            readline(input_file, in_line);
            read(in_line, in_val);
            pitch_angle <= in_val;
            roll_angle <= (others => '0');
            wait until RISING_EDGE(clk_100);
        end loop;
    
        STOP;
    end process;

end Simulation;
