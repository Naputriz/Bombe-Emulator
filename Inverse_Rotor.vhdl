library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Inverse_Rotor is
    Port ( 
        input_val   : in  integer; -- Sinyal balik dari reflektor/rotor sebelah
        current_pos : in  integer; -- Posisi putaran (sama dengan rotor pasangannya)
		rotor_type  : in  integer range 0 to 2;
        output_val  : out integer
    );
end Inverse_Rotor;

architecture Behavioral of Inverse_Rotor is
    type integer_array is array (0 to 25) of integer;
    
    -- INVERSE ROTOR I (UWYGADFPVZBECKMTHXSLRINQOJ)
    constant INV_ROTOR_I : integer_array := (
        20, 22, 24, 6, 0, 3, 5, 15, 21, 25, 1, 4, 2, 10, 12, 19, 7, 23, 18, 11, 17, 8, 13, 16, 14, 9
    );

    -- INVERSE ROTOR II (AJPCZWRLFBDKOTYUQGENHXMIVS)
    constant INV_ROTOR_II : integer_array := (
        0, 9, 15, 2, 25, 22, 17, 11, 5, 1, 3, 10, 14, 19, 24, 20, 16, 6, 4, 13, 7, 23, 12, 8, 21, 18
    );

    -- INVERSE ROTOR III (TAGBPCSDQEUFVNZHYIXJWLRKOM)
    constant INV_ROTOR_III : integer_array := (
        19, 0, 6, 1, 15, 2, 18, 3, 16, 4, 20, 5, 21, 13, 25, 7, 24, 8, 23, 9, 22, 11, 17, 10, 14, 12
    );

    -- Mencari index dalam tabel spesifik
    function find_index_in_table(val : integer; table : integer_array) return integer is
    begin
        for i in 0 to 25 loop
            if table(i) = val then return i; 
			end if;
        end loop;
        return 0;
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
    process(input_val, current_pos, rotor_type)
        variable idx : integer;
		variable safe_val : integer := 0;
        variable safe_pos : integer := 0;
		variable current_table : integer_array;
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
		
        -- Pilih inverse table
        case rotor_type is
            when 0 => current_table := INV_ROTOR_I;
            when 1 => current_table := INV_ROTOR_II;
            when 2 => current_table := INV_ROTOR_III;
            when others => current_table := INV_ROTOR_I;
        end case;
		
		-- Cari index di tabel yang dipilih
		idx := find_index_in_table(safe_val, current_table);
        
        -- Geser balik index tersebut sesuai posisi rotor
        output_val <= calc_reverse_offset(idx, safe_pos);
    end process;
end Behavioral;