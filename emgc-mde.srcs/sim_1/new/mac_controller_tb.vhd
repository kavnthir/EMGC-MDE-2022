----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2023 12:51:36 AM
-- Design Name: 
-- Module Name: mac_controller_tb - Behavioral
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
use STD.ENV.STOP;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mac_controller_tb is
end mac_controller_tb;

architecture Behavioral of mac_controller_tb is
    signal clk : STD_LOGIC := '0';
    signal master_enable, mast_limit : STD_LOGIC := '0'; -- inputs from GPIO
    signal x_int_channel, y_int_channel : integer := 0;
    signal x_channel, y_channel : STD_LOGIC_VECTOR(15 downto 0);
    signal sys_enable, sys_reset, mast_extend : STD_LOGIC; -- outputs from controller

begin

    x_channel <= STD_LOGIC_VECTOR(TO_SIGNED(x_int_channel, x_channel'length));
    y_channel <= STD_LOGIC_VECTOR(TO_SIGNED(y_int_channel, y_channel'length));

    UUT : entity work.mac_controller port map (clk => clk,
                                               master_enable => master_enable,
                                               mast_limit => mast_limit,
                                               x_channel => x_channel,
                                               y_channel => y_channel,
                                               sys_enable => sys_enable,
                                               sys_reset => sys_reset,
                                               mast_extend => mast_extend);
    
    -- clock frequecy of 2 Hz                                         
    clk <= not clk after 1 ns;

    stimulus : process begin
        -- reset/setup (reset is linked to master_enable switch)
        master_enable <= '1';
        wait for 5 ns;
        master_enable <= '0', '1' after 10 ns;
        wait for 10 ns;
        x_int_channel <= 15;
        y_int_channel <= -15;
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        assert mast_extend = '0' report "mast should not extend" severity failure;
        wait for 4 ns;
        -- start at +15 degrees to test out control combinations,
        -- then switch to -15 degrees and keep switching +/-
        -- untill the value is < 0.5 (8)
        for i in 1 to 15 loop
            x_int_channel <= x_int_channel - 1;
            y_int_channel <= y_int_channel + 1;
            wait for 6 ns;
        end loop;
        
        wait until mast_extend = '1';
        wait for 8 ns;
        mast_limit <= '1';
        wait for 8 ns;

        STOP;
    end process;

end Behavioral;
