----------------------------------------------------------------------------------
-- Company: Virginia Tech ECE Department
-- Engineer: Kaden Marlin, Kavin Thirukonda
-- 
-- Create Date: 11/04/2022 11:14:57 PM
-- Design Name: Pipelined Proportional-Integral (PI) Controller
-- Module Name: pi_controller - Behavioral
-- Project Name: Extendable Mast Gimbal Controller (EMGC)
-- Target Devices: Arty A7 FPGA (xc7a100tcsg324-1)
-- Tool Versions: Xilinx Vivado
-- Description: A digital PI controler/compensator implemented using
--              a pipelined architecture. Additional output arithmetic
--              is implemented to rescale the output to an unsigned byte.
-- 
-- Dependencies: None
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
              Sh : integer := 17);  -- Shift amount (for integer arithmetic)
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_data : in STD_LOGIC_VECTOR(15 downto 0); -- input range -15 to +15 signed
           output_data : out STD_LOGIC_VECTOR(7 downto 0)); -- output range -10 to +10 signed
end pi_controller;

architecture Behavioral of pi_controller is
    -- Constants
    constant C0 : integer := integer(Kp * real(2**Sh));
    constant C1 : integer := integer((-Kp + (Ts * Ki)) * real(2**Sh));
    
    -- Pipeline signed buffer values
    signal input_0 : SIGNED(31 downto 0);
    signal output_0 : SIGNED(63 downto 0);
    
    -- Pipeline registers
    signal input_1 : SIGNED(31 downto 0);
    signal output_1 : SIGNED(63 downto 0);
    
    -- Pipeline arithmetic buffer values
    signal prod_0 : SIGNED(63 downto 0);
    signal prod_1 : SIGNED(63 downto 0);
    
    -- Output arithmetic buffer values
    signal output_denom : SIGNED(31 downto 0);
    signal output_gain : SIGNED(31 downto 0);
    signal output_shift : SIGNED(31 downto 0);   
begin

    -- data typeconverts
    input_0 <= resize(SIGNED(input_data), 32);
    output_data <= STD_LOGIC_VECTOR(output_shift(7 downto 0));
    
    -- output arithmetic: output = (255/320)*(((3/16)*input)+160) = shr(19x,7)+128
    output_denom <= shift_right(output_0(31 downto 0), Sh);
    output_gain <= 19 * output_denom(15 downto 0);
    output_shift <= shift_right(output_gain, 7) + 128;
    
    -- pipeline arithmetic
    prod_0 <= C0 * input_0;
    prod_1 <= C1 * input_1;
    output_0 <= prod_0 + prod_1 + output_1;

    -- synchronous pipeline
    pipeline : process (clk) begin
        if (RISING_EDGE(clk)) then
            if (rst = '1') then
                input_1 <= (others => '0');
                output_1 <= (others => '0');
            else 
                input_1 <= input_0;
                output_1 <= output_0;
            end if;
        end if;
    end process;

end Behavioral;
