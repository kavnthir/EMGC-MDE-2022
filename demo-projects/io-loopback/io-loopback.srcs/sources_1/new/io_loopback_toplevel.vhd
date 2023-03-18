----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kavin Thirukonda
-- 
-- Create Date: 03/17/2023 06:21:46 PM
-- Design Name: 
-- Module Name: io_loopback_toplevel - Behavioral
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

entity io_loopback_toplevel is
  Port ( CLK100MHZ : in STD_LOGIC;
  btn : in STD_LOGIC_VECTOR (3 downto 0);
  led : out STD_LOGIC_VECTOR (3 downto 0);
  ledr : out STD_LOGIC_VECTOR (3 downto 0);
  ja : out STD_LOGIC_VECTOR (3 downto 0));
end io_loopback_toplevel;

architecture Behavioral of io_loopback_toplevel is
    signal CLK100 : STD_LOGIC;
    
    signal x_count : STD_LOGIC_VECTOR(7 downto 0);
    signal y_count : STD_LOGIC_VECTOR(7 downto 0);
    signal x_counter_rst : STD_LOGIC;
    signal y_counter_rst : STD_LOGIC;
    
    signal dac_rst : STD_LOGIC;
    signal dac_busy : STD_LOGIC;
    signal D0, D1 : STD_LOGIC;
    signal sclk : STD_LOGIC;
    signal sync_n : STD_LOGIC_VECTOR(0 DOWNTO 0);
begin

    ja <=   sclk & D1 & D0 & sync_n;
    led <= btn;
    ledr <= (x_counter_rst & y_counter_rst & dac_rst & dac_busy);
    
    clk_div_100 : entity work.clk_div generic map (in_Hz => 100_000_000,
                                                   out_Hz => 100)
                                      port map (rst => btn(0),
                                                clk_in => CLK100MHZ,
                                                clk_out => CLK100);

    x_counter_rst <= btn(3) and btn(2);
    x_counter : entity work.counter_8bit port map (clk => CLK100,
                                                   inc =>  btn(3),
                                                   dec => btn(2),
                                                   rst => x_counter_rst, 
                                                   count => x_count);
                                                 
    y_counter_rst <= btn(1) and btn(0);
    y_counter : entity work.counter_8bit port map (clk => CLK100,
                                                   inc =>  btn(1),
                                                   dec => btn(0),
                                                   rst => y_counter_rst, 
                                                   count => y_count);
                                                   
    dac_rst <= not (btn(3) and btn(2) and btn(1) and btn(0));                                                   
    dac_interface : entity work.pmod_dac_ad7303 port map (clk => CLK100MHZ,
                                                          reset_n => dac_rst,
                                                          dac_tx_ena => '1',
                                                          dac_1_ctrl => "110000",
                                                          dac_1_data => x_count,
                                                          dac_2_ctrl => "110000",
                                                          dac_2_data => y_count,
                                                          busy => dac_busy,
                                                          mosi_0 => D0,
                                                          mosi_1 => D1,
                                                          sclk => sclk,
                                                          ss_n => sync_n);

end Behavioral;
