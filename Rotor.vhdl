library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Rotor is
    Port ( 
        input_val  : in  integer; -- Input angka 0 sampai 25 (A=0, Z=25)
		current_pos : in  integer; -- Posisi Putaran Rotor (0-25)
        output_val : out integer  -- Output angka 0 sampai 25
    );
end Rotor;

architecture Dataflow of Rotor is

    -- Mendefinisikan tipe array langsung di sini (Definisi Lokal)
    type integer_array is array (0 to 25) of integer;

    -- Tabel Pengkabelan Rotor I (Konstanta Hardcoded)
    -- Memetakan huruf masuk ke huruf keluar secara acak
    constant wiring_table : integer_array := (
        4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9
    --  A   B   C  D   E  F  G   H   I   J   K   L   M   N   O  P   Q   R   S   T  U  V  W   X  Y  Z
    );

	-- Fungsi pembantu untuk perhitungan modulus (supaya tidak minus/overflow)
    function calc_offset(val_in : integer; offset : integer) return integer is
        variable safe_in : integer := 0;
		variable safe_off : integer := 0; 
        variable result  : integer := 0;
    begin
		-- 1. Sanitasi Input: Pastikan input bersih dari angka negatif/sampah
        if (val_in >= 0) and (val_in <= 25) then
            safe_in := val_in;
        else
            safe_in := 0; -- Default ke 'A' jika error
        end if;

		if (offset >= 0) and (offset <= 25) then
            safe_off := offset;
        else
            safe_off := 0; 
        end if;
		
        -- 2. Hitung Penjumlahan
        result := safe_in + safe_off;
        
        -- 3. Logika Modulo 
        if result > 25 then 
            result := result - 26;
        elsif result < 0 then 
            result := result + 26;
        end if;
        
        -- 4. Return Final (Pasti tereksekusi karena di luar if-else)
        return result;
    end function;

begin
	-- Logika Enigma: (Input + Posisi) masuk ke Array
    output_val <= wiring_table( calc_offset(input_val, current_pos) );

end Dataflow;