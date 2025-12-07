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
    function mod26(val : integer) return integer is
        variable res : integer;
    begin
        res := val mod 26;
        if res < 0 then res := res + 26; end if;
        return res;
    end function;

begin
    process(input_val, current_pos, rotor_type)
        variable pin_in_left  : integer;
        variable pin_out_right : integer;
        variable wire_out     : integer;
    begin
		-- 1. INPUT OFFSET: Masuk dari Stator Kiri ke Rotor (Geser Maju)
		pin_in_left := mod26(input_val + current_pos);
		
		-- 2. WIRING: Lookup langsung ke Tabel Inverse (Kiri -> Kanan)
        case rotor_type is
            when 0 => pin_out_right := INV_ROTOR_I(pin_in_left);
            when 1 => pin_out_right := INV_ROTOR_II(pin_in_left);
            when 2 => pin_out_right := INV_ROTOR_III(pin_in_left);
            when others => pin_out_right := INV_ROTOR_I(pin_in_left);
        end case;
		
		-- 3. EXIT OFFSET: Keluar dari Rotor Kanan ke Stator (Geser Mundur)
        wire_out := mod26(pin_out_right - current_pos);
        
        output_val <= wire_out;
    end process;
end Behavioral;