--------------------------------------------------------------------------------
-- Company: FE
-- Engineer: 
--
-- Design Name: red_pitaya_proc
-- Project Name: DIVS2016, obdelava analognih signalov
-- Target Device: Red Pitaya
-- Tool versions: Vivado 2017
-- Description: skaliranje signala in vmesnik za Red Pitayo  
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity red_pitaya_proc is
  port (
    clk_i   : in  std_logic;                      -- bus clock 
    rstn_i  : in  std_logic;                      -- bus reset - active low
    addr_i  : in  std_logic_vector(31 downto 0);  -- bus address
    wdata_i : in  std_logic_vector(31 downto 0);  -- bus write data          
    wen_i   : in  std_logic;                      -- bus write enable
    ren_i   : in  std_logic;                      -- bus read enable
    rdata_o : out std_logic_vector(31 downto 0);  -- bus read data
    err_o   : out std_logic;                      -- bus error indicator
    ack_o   : out std_logic;                      -- bus acknowledge signal

    adc_i : in  std_logic_vector(13 downto 0);
    adc_o : out std_logic_vector(13 downto 0)
    );
end red_pitaya_proc;

architecture Behavioral of red_pitaya_proc is
 signal reg: std_logic_vector(7 downto 0);
begin
-- add your code here

-- bus signals and read logic for register: reg
err_o <= '0';

pbusr: process(addr_i, wen_i, ren_i, reg)
begin
  if (wen_i or ren_i)='1' then
    ack_o <= '1';
  end if;   
  
  if addr_i(19 downto 0)=X"00000" then 
      rdata_o <= X"000001" & reg;         
  else
      rdata_o <= (others=>'0');   
  end if;
end process;

end Behavioral;
