--------------------------------------------------------------------------------
-- Company: FE
-- Engineer: A. Trost
--
-- Design Name: testProc
-- Project Name: DIVS2016, 7. vaja, testna struktura
-- Target Device: Red Pitaya
-- Tool versions: Vivado 2015
-- Description: Testna struktura za vmesnik in skaliranje na Red Pitayi
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity TestProc is
end TestProc;

architecture Behavioral of TestProc is

  component red_pitaya_proc
    port (
      clk_i   : in  std_logic;
      rstn_i  : in  std_logic;
      addr_i  : in  std_logic_vector(31 downto 0);
      wdata_i : in  std_logic_vector(31 downto 0);
      wen_i   : in  std_logic;
      ren_i   : in  std_logic;
      rdata_o : out std_logic_vector(31 downto 0);
      err_o   : out std_logic;
      ack_o   : out std_logic;
      adc_i   : in  std_logic_vector(13 downto 0);
      adc_o   : out std_logic_vector(13 downto 0));
  end component;

  signal clk_i   : std_logic := '0';
  signal rstn_i  : std_logic;
  signal addr_i  : std_logic_vector(31 downto 0);
  signal wdata_i : std_logic_vector(31 downto 0);
  signal wen_i   : std_logic;
  signal ren_i   : std_logic;
  signal rdata_o : std_logic_vector(31 downto 0);
  signal err_o   : std_logic;
  signal ack_o   : std_logic;
  signal adc_i   : std_logic_vector(13 downto 0);
  signal adc_o   : std_logic_vector(13 downto 0);

  signal i : integer range 0 to 30 := 0;
  type memory_type is array (0 to 29) of integer range -128 to 127;
  signal sine : memory_type := (0, 16, 31, 45, 58, 67, 74, 77, 77, 74, 67, 58, 45, 31, 16, 0,
                                -16, -31, -45, -58, -67, -74, -77, -77, -74, -67, -58, -45, -31, -16);

  -- Kontrola simulacije
  signal sim : std_logic := '0';

  constant T  : time := 50 ns;
begin
  uut : red_pitaya_proc port map (
    clk_i   => clk_i,
    rstn_i  => rstn_i,
    addr_i  => addr_i,
    wdata_i => wdata_i,
    wen_i   => wen_i,
    ren_i   => ren_i,
    rdata_o => rdata_o,
    err_o   => err_o,
    ack_o   => ack_o,
    adc_i   => adc_i,
    adc_o   => adc_o);

-- Definiraj uro
  clk_process : process
  begin
    if sim = '0' then
      clk_i <= '0';
      wait for T/2;
      clk_i <= '1';
      wait for T/2;
    else
      wait;
    end if;
  end process;

-- Generiraj sinusni signal iz tabele
  singen : process(clk_i)
  begin
    if(rising_edge(clk_i)) then
      adc_i <= std_logic_vector(to_signed(20*sine(i), 14));
      i     <= i+ 1;
      if(i = 29) then
        i <= 0;
      end if;
    end if;
  end process;

-- Nastavi signale poenostavljenega vodila AXI
  stim_proc : process
  begin
    rstn_i  <= '0';                     -- aktiven reset
    addr_i  <= "00000000000000000000000000000000";
    wdata_i <= "00000000000000000000000000000000";
    wen_i   <= '0'; ren_i <= '0';

    wait for T;
    rstn_i  <= '1';  -- deaktiviraj reset, pisanje v register
    wdata_i <= x"00000005";
    wen_i   <= '1';

    wait for T;
    wen_i <= '0';

    wait for 100*T;                      -- vpis nove vrednosti v register
    wdata_i <= x"00000009";
    wen_i   <= '1';

    wait for T;
    wen_i <= '0';

    wait for 100*T;
    sim <= '1';                         -- ustavi simulacijo
    wait;
  end process;

end;
