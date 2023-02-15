----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/15/2023 11:17:16 AM
-- Design Name: 
-- Module Name: board_IO_tb - Behavioral
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

entity board_IO_tb is
end board_IO_tb;

architecture Behavioral of board_IO_tb is

    signal board_clk : STD_LOGIC;           -- FPGA system clock (eg. 50MHz)
    
    signal sw_master_enable : STD_LOGIC;    -- SWITCH input from customer (technically reset_n)
    signal sw_mast_limit : STD_LOGIC;       -- SWITCH input from VSAT
    signal pin_mast_extend : STD_LOGIC;     -- Active high PIN out to VSAT
    signal pin_x_sign_bit : STD_LOGIC;      -- Active high PIN out to x H-bridge
    signal pin_y_sign_bit : STD_LOGIC;      -- Active high PIN out to y H-bridge
    
    signal master_enable : STD_LOGIC;       -- synchronized active high INPUT (out from UUT)
    signal mast_limit : STD_LOGIC;          -- synchronized active high INPUT (out from UUT)
    signal mast_extend : STD_LOGIC;         -- synchronous active high OUTPUT (in to UUT)
    signal x_sign_bit : STD_LOGIC;          -- synchronous active high OUTPUT (in to UUT)
    signal y_sign_bit : STD_LOGIC;          -- synchronous active high OUTPUT (in to UUT)

begin

    -- interface:
    -- sw_master_enable -> master_enable (get switch input for MAC)
    -- sw_mast_limit -> mast_limit (get limit switch input for MAC)
    -- mast_extend -> pin_mast_extend (send extend signal through pin)
    -- x_sign_bit -> pin_x_sign_bit (send negative bit to H-bridge)
    -- y_sign_bit -> pin_y_sign_bit (send negative bit to H-bridge)
    UUT : entity work.gpio_interface port map (clk => board_clk,
                                               master_enable_in => sw_master_enable,
                                               mast_limit_in => sw_mast_limit,
                                               mast_extend_in => mast_extend,
                                               x_sign_bit_in => x_sign_bit,
                                               y_sign_bit_in => y_sign_bit,
                                               master_enable_out => master_enable,
                                               mast_limit_out => mast_limit,
                                               mast_extend_out => pin_mast_extend,
                                               x_sign_bit_out => pin_x_sign_bit,
                                               y_sign_bit_out => pin_y_sign_bit);

    -- setup clock?

end Behavioral;
