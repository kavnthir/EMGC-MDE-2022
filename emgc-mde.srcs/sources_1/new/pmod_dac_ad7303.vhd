--------------------------------------------------------------------------------
--
--   FileName:         pmod_dac_ad7303.vhd
--   Dependencies:     spi_master_dual_mosi.vhd
--   Design Software:  Quartus Prime Version 17.0.0 Build 595 SJ Lite Edition
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 1/17/2022 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pmod_dac_ad7303 IS
  GENERIC(
    clk_freq    : INTEGER := 100;  --system clock frequency in MHz
    spi_clk_div : INTEGER := 2);  --spi_clk_div = clk_freq/60 (answer rounded up)
  PORT(
    clk        : IN      STD_LOGIC;                      --system clock
    reset_n    : IN      STD_LOGIC;                      --active low asynchronous reset
    dac_tx_ena : IN      STD_LOGIC;                      --enable transaction with DACs
    dac_1_ctrl : IN      STD_LOGIC_VECTOR(5 DOWNTO 0);   --control value to send to DAC 1
    dac_1_data : IN      STD_LOGIC_VECTOR(7 DOWNTO 0);   --data value to send to DAC 1
    dac_2_ctrl : IN      STD_LOGIC_VECTOR(5 DOWNTO 0);   --control value to send to DAC 2
    dac_2_data : IN      STD_LOGIC_VECTOR(7 DOWNTO 0);   --data value to send to DAC 2
    busy       : OUT     STD_LOGIC;                      --indicates when transactions with DACs can be initiated
    mosi_0     : OUT     STD_LOGIC;                      --SPI bus to DAC 1: master out, slave in (D0)
    mosi_1     : OUT     STD_LOGIC;                      --SPI bus to DAC 2: master out, slave in (D1)
    sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCK)
    ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0));  --SPI bus to DAC: slave select (~SYNC)
END pmod_dac_ad7303;

ARCHITECTURE behavior OF pmod_dac_ad7303 IS
  TYPE machine IS(start, pause, ready, send_data);       --needed states
  SIGNAL state         : machine := start;               --state machine
  SIGNAL spi_busy_prev : STD_LOGIC;                      --previous value of the SPI component's busy signal
  SIGNAL spi_busy      : STD_LOGIC;                      --busy signal from SPI component
  SIGNAL spi_ena       : STD_LOGIC;                      --enable for SPI component
  SIGNAL spi_tx_data_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);  --transmit data for SPI component, channel 0
  SIGNAL spi_tx_data_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);  --transmit data for SPI component, channel 1

  --declare SPI Master component
  COMPONENT spi_master_dual_mosi IS
    GENERIC(
      slaves  : INTEGER := 1;   --number of spi slaves
      d_width : INTEGER := 16); --data bus width
    PORT(
      clock     : IN     STD_LOGIC;                             --system clock
      reset_n   : IN     STD_LOGIC;                             --asynchronous reset
      enable    : IN     STD_LOGIC;                             --initiate transaction
      cpol      : IN     STD_LOGIC;                             --spi clock polarity
      cpha      : IN     STD_LOGIC;                             --spi clock phase
      cont      : IN     STD_LOGIC;                             --continuous mode command
      clk_div   : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
      addr      : IN     INTEGER;                               --address of slave
      tx_data_0 : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit, channel 0
      tx_data_1 : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit, channel 1
      miso      : IN     STD_LOGIC;                             --master in, slave out
      sclk      : BUFFER STD_LOGIC;                             --spi clock
      ss_n      : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
      mosi_0    : OUT    STD_LOGIC;                             --master out, slave in, channel 0
      mosi_1    : OUT    STD_LOGIC;                             --master out, slave in, channel 1
      busy      : OUT    STD_LOGIC;                             --busy / data ready signal
      rx_data   : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
  END COMPONENT spi_master_dual_mosi;

BEGIN

  --instantiate the SPI Master component
  spi_master_dual_mosi_0:  spi_master_dual_mosi
    GENERIC MAP(slaves => 1, d_width => 16)
    PORT MAP(clock => clk, reset_n => reset_n, enable => spi_ena, cpol => '0', cpha => '0',
             cont => '0', clk_div => spi_clk_div, addr => 0, tx_data_0 => spi_tx_data_0, 
             tx_data_1 => spi_tx_data_1, miso => '0', sclk => sclk, ss_n => ss_n, 
             mosi_0 => mosi_0, mosi_1 => mosi_1, busy => spi_busy, rx_data => open);
       
  PROCESS(clk, reset_n)
    VARIABLE count : INTEGER RANGE 0 TO clk_freq*100 := 0; --counter
  BEGIN
  
    IF(reset_n = '0') THEN              --reset activated
      spi_ena <= '0';                     --clear SPI component enable
      spi_tx_data_0 <= (OTHERS => '0');   --clear SPI component transmit data, channel 0
      spi_tx_data_1 <= (OTHERS => '0');   --clear SPI component transmit data, channel 1
      busy <= '1';                        --indication component is unavailable
      state <= start;                     --restart state machine
    ELSIF(clk'EVENT AND clk = '1') THEN --rising edge of system clock

      spi_busy_prev <= spi_busy;          --collect previous spi_busy
   
      CASE state IS                       --state machine

        --entry state, give DAC 100us to power up before communicating
        WHEN start =>
          busy <= '1';                     --component is busy, DAC not yet available
          IF(count < clk_freq*100) THEN    --100us not yet reached
            count := count + 1;              --increment counter
          ELSE                             --100us reached
            count := 0;                      --clear counter
            state <= pause;                  --advance to pause state
          END IF;
          
        --pauses at least 33ns between SPI transactions
        WHEN pause =>
          IF(count < clk_freq/30) THEN   --less than 33ns
            count := count + 1;            --increment counter
          ELSE                           --33ns has elapsed
            count := 0;                    --clear counter
            busy <= '0';                   --indicate component is ready for a transaction
            state <= ready;                --advance to ready state 
          END IF;
        
        --wait for a new transaction and latch it in
        WHEN ready =>
          IF(dac_tx_ena = '1') THEN                          --transaction to DAC requested
            spi_tx_data_0 <= "00" & dac_1_ctrl & dac_1_data;   --latch in data stream to send to DAC 1
            spi_tx_data_1 <= "00" & dac_2_ctrl & dac_2_data;   --latch in data stream to send to DAC 2
            busy <= '1';                                       --indicate transaction is in progress
            state <= send_data;                                --advance to sending transaction
          END IF;

        --performs SPI transaction to DAC  
        WHEN send_data =>
          IF(spi_busy = '0' AND spi_busy_prev = '0') THEN  --transaction not started
            spi_ena <= '1';                                  --enable SPI transaction
          ELSIF(spi_busy = '1') THEN                       --transaction underway
            spi_ena <= '0';                                  --clear enable                            
          ELSE                                             --transaction complete
            state <= pause;                                  --return to pause state
          END IF;

        --default to start state
        WHEN OTHERS => 
          state <= start;

      END CASE;      
    END IF;
  END PROCESS;
END behavior;