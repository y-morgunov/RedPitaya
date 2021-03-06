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
           rstn_i   : in std_logic;                         -- bus reset - active low
           tag_i    : in unsigned (1 downto 0);             -- 
           data_o   : out std_logic_vector (13 downto 0));  -- 
end moving_average;

architecture Behavioral of moving_average is
    type mem_t is array (0 to 2) of signed (13 downto 0);
    
    signal mean: mem_t; -- buffer for moving average algorithm
    signal counter: unsigned(1 downto 0);
-- signal mean:   std_logic_vector(13 downto 0) := "00000000000000";  -- store the mean value of adc_arr
begin

--data_o <= std_logic_vector(resize(shift_right((adc_arr) * 85, 8), 14));

--TODO - make with dynamic size, add to register for configuration
process (clk_i)
begin
    if(rising_edge(clk_i)) then
        if (rstn_i = '0') then
            -- TODO - clean adc_arr
        else
            counter <= counter + 1;
            case tag_i is
                -- (mean)
                when "01" => data_o <= std_logic_vector(mean(to_integer(to_unsigned(0, 8))));
                
                -- (mean) / 2
                when "10" => data_o <= std_logic_vector(shift_right(mean(to_integer(to_unsigned(1, 8))), 1));
                
                -- (mean * 85) / 256
                when "11" => data_o <= std_logic_vector(resize(shift_right(mean(to_integer(to_unsigned(2, 8))) * 85, 8), 14));
                
                -- (mean * 85) / 256
                when others => data_o <= std_logic_vector(resize(shift_right(mean(to_integer(to_unsigned(2, 8))) * 85, 8), 14));
            end case;
            
            mean(to_integer(to_unsigned(0, 8))) <= signed(data_i);
            mean(to_integer(to_unsigned(1, 8))) <= mean(to_integer(to_unsigned(0, 8))) + signed(data_i);
            mean(to_integer(to_unsigned(2, 8))) <= mean(to_integer(to_unsigned(1, 8))) + signed(data_i);
        end if;
    end if;
end process;

end Behavioral;
