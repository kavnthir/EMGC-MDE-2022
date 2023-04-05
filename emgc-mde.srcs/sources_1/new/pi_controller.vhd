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
           data_clock : STD_LOGIC;
           input_data : in STD_LOGIC_VECTOR(15 downto 0); -- input range -15 to +15
           output_data : out STD_LOGIC_VECTOR(7 downto 0)); -- output range -10 to +10 signed
end pi_controller;

architecture Behavioral of pi_controller is
    -- Constants
    constant C0 : integer := integer(Kp * real(2**Sh));
    constant C1 : integer := integer((-Kp + (Ts * Ki)) * real(2**Sh));
    
    -- Pipeline
    signal input_0, input_1, output_buf1 : SIGNED(31 downto 0);
    signal output_0, output_1, output_buf0 : SIGNED(63 downto 0);
    
begin
    -- type conversions (convert 64 bit value to 8 bit value)
    input_0 <= resize(SIGNED(input_data), 32);
    output_buf0 <= (3 * shift_right(output_0(31 downto 0), Sh)) / 16;   -- Denom and Gain
    output_buf1 <= (255 * (output_buf0(15 downto 0) + 160)) / 320;      -- Convert to byte
    output_data <= STD_LOGIC_VECTOR(output_buf1(7 downto 0));           -- Output typecast
    
    -- arithmetic (products and output_1 are 64 bit)
    output_0 <= (C0 * input_0) + (C1 * input_1) + output_1;

    -- synchronous pipeline
    pipeline : process (clk, data_clock) begin
        if (RISING_EDGE(clk) and rst = '1') then
            input_1 <= (others => '0');
            output_1 <= (others => '0');
        end if;
        if (RISING_EDGE(data_clock) and rst = '0') then
            input_1 <= input_0;
            output_1 <= output_0;
        end if;
    end process;

end Behavioral;
