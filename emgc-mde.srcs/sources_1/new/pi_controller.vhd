----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kaden Marlin, Kavin Thirukonda
-- 
-- Create Date: 11/04/2022 11:14:57 PM
-- Design Name: 
-- Module Name: pi_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: pi_imodule.vhd, pi_output.vhd, pi_pmodule.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pi_controller is
    Generic (Ts : integer := 1;  -- it might not be feasible to use generics
             Kp : integer := 1;  -- here because we need reals
             Ki : integer := 1);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_valid : in STD_LOGIC; -- HIGH when input is good (acts as an enable)
           input_data : in STD_LOGIC_VECTOR(15 downto 0); -- input range -15 to +15
           output_valid : out STD_LOGIC; -- HIGH when output is good
           output_data : out STD_LOGIC_VECTOR(15 downto 0)); -- output range -10 to +10 signed
end pi_controller;

architecture Behavioral of pi_controller is
    -- Constants
    constant C0 : integer := 1;
    constant C1 : integer := 1;
    
    -- Pipeline
    signal valid_0, valid_1, valid_2: STD_LOGIC;
    signal input_0, input_1, output_0, output_1 : SIGNED(15 downto 0);
    
begin

    input_0 <= SIGNED(input_data);
    output_data <= STD_LOGIC_VECTOR(output_0);

    -- synchronous pipeline
    pipeline : process (clk) begin
        if (RISING_EDGE(clk)) then
            -- synchronous reset for everything.
            if (rst = '1') then
                input_1 <= (others => '0');
                output_0 <= (others => '0');
                output_1 <= (others => '0');
                valid_0 <= '0';
                valid_1 <= '0';
                valid_2 <= '0';
            -- flush pipeline with initial conditions on rising edge of input_valid
            elsif (input_valid = '1' and valid_0 = '0') then
                valid_0 <= input_valid;
                input_1 <= input_0;
                output_0 <= input_0;
                output_1 <= input_0;
            -- execute pipeline while input is good
            else
                -- valid pipeline
                valid_0 <= input_valid;
                valid_1 <= valid_0;
                valid_2 <= valid_1;
                output_valid <= valid_2;
                -- data pipeline 
                input_1 <= input_0;
                output_0 <= (C0 * input_0) + (C1 * input_1) + output_1;
                output_1 <= output_0;
            end if;
        end if;
    end process;

end Behavioral;
