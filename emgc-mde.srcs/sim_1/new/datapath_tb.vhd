----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE - EMGC Team
-- Engineer: Kaden Marlin
-- 
-- Create Date: 03/29/2023 03:17:40 PM
-- Design Name: 
-- Module Name: datapath_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL; -- require for writing/reading std_logic etc.
use STD.ENV.STOP;

entity datapath_tb is
end datapath_tb;

architecture Behavioral of datapath_tb is

--CLOCKS------------------------------------------------------
    signal clk_100M : STD_LOGIC := '0';
    signal clk_100, clk_timer : STD_LOGIC;
    
--CONTROL SIGNALS------------------------------------------------------
    signal reset : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '1';
    signal limit : STD_LOGIC := '0';
    
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

--STABILITY CONTROLLER------------------------------------------------------
    stability_control : entity work.mac_controller
    port map (clk => clk_100M,
              rst => reset,
              data_clock => clk_100,
              timer_clock => clk_timer,
              master_enable => enable,
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
    port map (clk => clk_100M,
              rst => reset,
              data_clock => clk_100,
              input_data => pitch_angle_lpf,
              output_data => pitch_volts);
    roll_PI_controller : entity work.pi_controller 
    port map (clk => clk_100M,
              rst => reset,
              data_clock => clk_100,
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
   
        wait until RISING_EDGE(clk_100M);
        reset <= '1';
        wait for 200 us; -- reset pulse
        reset <= '0';
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

end Behavioral;
