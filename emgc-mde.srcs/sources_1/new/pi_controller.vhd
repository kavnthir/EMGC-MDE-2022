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

entity pi_controller is
    Generic (Ts : integer := 1;  -- it might not be feasible to use generics
             Kp : integer := 1;  -- here because we need reals
             Ki : integer := 2);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_valid : in STD_LOGIC; -- HIGH when input is good (acts as an enable)
           input_data : in STD_LOGIC_VECTOR(15 downto 0); -- input range -15 to +15
           output_valid : out STD_LOGIC; -- HIGH when output is good
           output_data : out STD_LOGIC_VECTOR(15 downto 0)); -- output range -10 to +10 signed
end pi_controller;

architecture Behavioral of pi_controller is
    -- Constants
    constant C0 : integer := Kp;
    constant C1 : integer := -Kp + (Ts * Ki);
    
    -- Pipeline
    signal valid_reg : STD_LOGIC;
    signal input_0, input_1, output_1 : SIGNED(15 downto 0);
    signal output_0 : SIGNED(31 downto 0);
    
begin
    -- type conversions
    input_0 <= SIGNED(input_data);
    output_data <= STD_LOGIC_VECTOR(output_0(15 downto 0));
    output_valid <= valid_reg;
    
    -- arithmetic
    -- assume steady input at t=-1 when input becomes valid
    output_0 <= (C0 * input_0) + (C1 * input_0) when
        (input_valid = '1' and valid_reg = '0') else
        (C0 * input_0) + (C1 * input_1) + output_1;

    -- synchronous pipeline
    pipeline : process (clk) begin
        if (RISING_EDGE(clk)) then
            -- synchronous reset for the registers.
            if (rst = '1') then
                input_1 <= (others => '0');
                output_1 <= (others => '0');
                valid_reg <= '0';
            -- PI controller pipeline
            else
                input_1 <= input_0;
                output_1 <= output_0(15 downto 0);
                valid_reg <= input_valid;
            end if;
        end if;
    end process;

end Behavioral;
