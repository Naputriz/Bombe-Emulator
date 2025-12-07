library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Scrambler is
    Port ( 
        char_in   : in  integer; -- Huruf masuk dari keyboard/file
        
        -- Settingan Posisi Rotor (dikontrol oleh 'Otak' nanti)
        pos_r1    : in  integer; 
        pos_r2    : in  integer;
        pos_r3    : in  integer;
		
		type_r1 : in integer range 0 to 2; -- Tipe Rotor 1
        type_r2 : in integer range 0 to 2; -- Tipe Rotor 2
        type_r3 : in integer range 0 to 2;  -- Tipe Rotor 3
        
        char_out  : out integer  -- Hasil enkripsi
    );
end Scrambler;

architecture Structural of Scrambler is

    -- Kabel Internal untuk menghubungkan antar kotak
    -- Jalur maju 
    signal wire_f1 : integer := 0; -- R1 -> R2
    signal wire_f2 : integer := 0; -- R2 -> R3
    signal wire_f3 : integer := 0; -- R3 -> Reflector
	
	-- Jalur mundur 
    signal wire_r1 : integer := 0; -- Reflector -> Inv_R3
    signal wire_r2 : integer := 0; -- Inv_R3 -> Inv_R2
    signal wire_r3 : integer := 0; -- Inv_R2 -> Inv_R1 (Output)

begin

    -- Instansiasi Rotor 1 
    U_Rotor1: entity work.Rotor
        port map (
            input_val   => char_in,
            current_pos => pos_r1,
			rotor_type => type_r1,
            output_val  => wire_f1  -- Keluar ke kabel 1
        );

    -- Instansiasi Rotor 2 
    U_Rotor2: entity work.Rotor
        port map (
            input_val   => wire_f1, -- Masuk dari kabel 1
            current_pos => pos_r2,
			rotor_type => type_r2,
            output_val  => wire_f2  -- Keluar ke kabel 2
        );

    -- Instansiasi Rotor 3 
    U_Rotor3: entity work.Rotor
        port map (
            input_val   => wire_f2,
            current_pos => pos_r3,
			rotor_type => type_r3,
            output_val  => wire_f3
        );

    -- Instansiasi Reflektor 
    U_Reflector: entity work.Reflector
        port map (
            input_val  => wire_f3,
            output_val => wire_r1 -- Outputnya masuk ke jalur mundur
        );
		
	U_Inv_Rotor3: entity work.Inverse_Rotor port map (
        input_val => wire_r1, 
        current_pos => pos_r3, -- Posisi sama dengan Rotor 3 asli
		rotor_type => type_r3,
        output_val => wire_r2
    );

    U_Inv_Rotor2: entity work.Inverse_Rotor port map (
        input_val => wire_r2, 
        current_pos => pos_r2, -- Posisi sama dengan Rotor 2 asli
		rotor_type => type_r2,
        output_val => wire_r3
    );

    U_Inv_Rotor1: entity work.Inverse_Rotor port map (
        input_val => wire_r3, 
        current_pos => pos_r1, -- Posisi sama dengan Rotor 1 asli
		rotor_type => type_r1,
        output_val => char_out -- Keluar ke Output Utama
    );

end Structural;