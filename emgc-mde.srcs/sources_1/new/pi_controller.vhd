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
use IEEE.MATH_REAL.ALL;

entity pi_controller is
    Generic ( Kp : real := 2.0;     -- P unit constant
              Ki : real := 0.125;   -- I unit constant
              Ts : real := 0.01;    -- Sample period
              Sh : integer := 17);  -- Shift amount (for small numbers)
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_valid : in STD_LOGIC; -- HIGH when input is good (acts as an enable)
           input_data : in STD_LOGIC_VECTOR(15 downto 0); -- input range -15 to +15
           output_valid : out STD_LOGIC; -- HIGH when output is good
           output_data : out STD_LOGIC_VECTOR(7 downto 0)); -- output range -10 to +10 signed
end pi_controller;

architecture Behavioral of pi_controller is
    -- Constants
    constant C0 : integer := integer(Kp * real(2**Sh));
    constant C1 : integer := integer((-Kp + (Ts * Ki)) * real(2**Sh));
    
    -- Pipeline
    signal valid_reg : STD_LOGIC;
    signal input_0, input_1, output_1, output_buf1 : SIGNED(31 downto 0);
    signal output_0, output_buf0 : SIGNED(63 downto 0);
    
begin
    -- type conversions
    input_0 <= resize(SIGNED(input_data), 32);
    -- !! check bit cropping
    output_buf0 <= (3 * shift_right(output_0(31 downto 0), Sh)) / 16;   -- Denom and Gain
    output_buf1 <= (255 * (output_buf0(15 downto 0) + 160)) / 320;      -- Convert to byte
    output_data <= STD_LOGIC_VECTOR(output_buf1(7 downto 0));           -- Output typecast
    output_valid <= valid_reg;
    
    -- arithmetic
    -- assume steady input at t=-1 when input becomes valid
--    output_0 <= (C0 * input_0) + (C1 * input_0) when
--        (input_valid = '1' and valid_reg = '0') else
--        (C0 * input_0) + (C1 * input_1) + output_1;
    output_0 <= (C0 * input_0) + (C1 * input_1) + output_1;

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
                output_1 <= output_0(31 downto 0);
                valid_reg <= input_valid;
            end if;
        end if;
    end process;

end Behavioral;
