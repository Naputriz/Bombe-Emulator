library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Comparator is
    Port ( 
        char_in    : in  integer; -- Output dari Scrambler
        target_val : in  integer; -- Target dicari 
        match_out  : out STD_LOGIC
    );
end Comparator;

architecture Behavioral of Comparator is
begin
    process(char_in, target_val)
    begin
        -- Bandingkan Input dengan Target yang diminta
        if char_in = target_val then
            match_out <= '1';
        else
            match_out <= '0';
        end if;
    end process;
end Behavioral;