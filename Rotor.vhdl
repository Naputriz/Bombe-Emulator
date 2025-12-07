library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Rotor is
    Port ( 
        input_val   : in  integer; -- Input angka 0 sampai 25 (A=0, Z=25)
		current_pos : in  integer; -- Posisi Putaran Rotor (0-25)
		rotor_type  : in  integer range 0 to 2; -- Pilih Rotor mana yang ingin disimulasi
        output_val  : out integer  -- Output angka 0 sampai 25
    );
end Rotor;

architecture Dataflow of Rotor is

    -- Mendefinisikan tipe array langsung di sini (Definisi Lokal)
    type integer_array is array (0 to 25) of integer;

    -- Tabel Pengkabelan Rotor 
    -- ROTOR I: EKMFLGDQVZNTOWYHXUSPAIBRCJ
    constant ROTOR_I : integer_array := (
        4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9
    );

    -- ROTOR II: AJDKSIRUXBLHWTMCQGZNPYFVOE
    constant ROTOR_II : integer_array := (
        0, 9, 3, 10, 18, 8, 17, 20, 23, 1, 11, 7, 22, 19, 12, 2, 16, 6, 25, 13, 15, 24, 5, 21, 14, 4
    );

    -- ROTOR III: BDFHJLCPRTXVZNYEIWGAKMUSQO
    constant ROTOR_III : integer_array := (
        1, 3, 5, 7, 9, 11, 2, 15, 17, 19, 23, 21, 25, 13, 24, 4, 8, 22, 6, 0, 10, 12, 20, 18, 16, 14
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
            safe_in := 0; -- Default ke 0 jika error
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
	process(input_val, current_pos, rotor_type)
        variable selected_wire : integer;
        variable calculated_idx : integer;
	begin
		-- Kalkulasi index berdasarkan rotasi
		calculated_idx := calc_offset(input_val, current_pos);
		
		-- Pilih tabel berdasarkan tipe rotor
		case rotor_type is
				when 0 => selected_wire := ROTOR_I(calculated_idx);
				when 1 => selected_wire := ROTOR_II(calculated_idx);
				when 2 => selected_wire := ROTOR_III(calculated_idx);
				when others => selected_wire := ROTOR_I(calculated_idx);
		end case;
	
		output_val <= selected_wire;
	end process;
end Dataflow;