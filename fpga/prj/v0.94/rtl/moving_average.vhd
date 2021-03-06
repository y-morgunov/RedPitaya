----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2021 17:18:22
-- Design Name: 
-- Module Name: moving_average - Behavioral
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
use IEEE.NUMERIC_STD.all;

entity moving_average is
    Port ( data_i   : in std_logic_vector (13 downto 0);    -- 
           clk_i    : in std_logic;                         -- bus clock 
           rstn_i   : in std_logic;                        -- bus reset - active low
           tag_i    : in unsigned (1 downto 0);     -- 
           data_o   : out std_logic_vector (13 downto 0));  -- 
end moving_average;

architecture Behavioral of moving_average is
 signal reg_1: signed(13 downto 0);
 signal reg_2: signed(13 downto 0);
 signal reg_3: signed(13 downto 0);
begin

data_o <= std_logic_vector(resize(shift_right((reg_1 + reg_2 + reg_3) * 85, 8), 14));

process (clk_i)
begin
    if(rising_edge(clk_i)) then
        if (rstn_i = '0') then
            reg_1 <= "00000000000000";
            reg_2 <= "00000000000000";
            reg_3 <= "00000000000000";
        else
            case tag_i is
                when "00" => reg_1 <= signed(data_i);
                when "01" => reg_2 <= signed(data_i);
                when "10" => reg_3 <= signed(data_i);
                when others => reg_1 <= signed(data_i);
            end case;
        end if;
    end if;
end process;

end Behavioral;
