library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Inverse_Rotor is
    Port ( 
        input_val   : in  integer; -- Sinyal balik dari reflektor/rotor sebelah
        current_pos : in  integer; -- Posisi putaran (sama dengan rotor pasangannya)
        output_val  : out integer
    );
end Inverse_Rotor;

architecture Behavioral of Inverse_Rotor is
    type integer_array is array (0 to 25) of integer;
    
    -- Table SAMA PERSIS dengan Rotor.vhdl
    constant wiring_table : integer_array := (
        4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9
	--  A   B   C  D   E  F  G   H   I   J   K   L   M   N   O  P   Q   R   S   T  U  V  W   X  Y  Z
    );

    -- Fungsi Reverse Lookup: Mencari index berdasarkan nilai
    function find_index_by_value(val : integer) return integer is
    begin
        for i in 0 to 25 loop
            if wiring_table(i) = val then
                return i; -- Kalo ketemu, return index
            end if;
        end loop;
        return 0; -- Default
    end function;

    -- Fungsi Reverse Offset: Kebalikan dari calc_offset di Rotor.vhdl
    function calc_reverse_offset(base_idx : integer; offset : integer) return integer is
        variable result : integer;
    begin
        result := base_idx - offset;
        
        -- Wrap around logika
        if result < 0 then
            result := result + 26;
        end if;
        return result;
    end function;

begin
    process(input_val, current_pos)
        variable idx : integer;
		variable safe_val : integer := 0;
        variable safe_pos : integer := 0;
    begin
	
		-- Sanitasi input (kalo gw ga setting ke 0 gini malah angka negatif gede jir di vivado gw)
		if (input_val >= 0) and (input_val <= 25) then
            safe_val := input_val;
        else
            safe_val := 0;
        end if;

        if (current_pos >= 0) and (current_pos <= 25) then
            safe_pos := current_pos;
        else
            safe_pos := 0;
        end if;
		
        -- Cari input ini asalnya dari pin (index) nomor berapa?
        idx := find_index_by_value(safe_val);
        
        -- Geser balik index tersebut sesuai posisi rotor
        output_val <= calc_reverse_offset(idx, safe_pos);
    end process;
end Behavioral;