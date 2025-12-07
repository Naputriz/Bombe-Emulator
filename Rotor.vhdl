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
    function mod26(val : integer) return integer is
        variable res : integer;
    begin
        res := val mod 26;
        if res < 0 then res := res + 26; end if;
        return res;
    end function;

begin
	process(input_val, current_pos, rotor_type)
        variable pin_in     : integer;
        variable pin_out    : integer;
        variable wire_out   : integer;
	begin
		-- 1. INPUT OFFSET: Masuk dari Stator ke Rotor (Geser Maju)
        pin_in := mod26(input_val + current_pos);
		
		-- Pilih tabel berdasarkan tipe rotor
		case rotor_type is
            when 0 => pin_out := ROTOR_I(pin_in);
            when 1 => pin_out := ROTOR_II(pin_in);
            when 2 => pin_out := ROTOR_III(pin_in);
            when others => pin_out := ROTOR_I(pin_in);
		end case;
	
		wire_out := mod26(pin_out - current_pos);
		
		output_val <= wire_out;
	end process;
end Dataflow;