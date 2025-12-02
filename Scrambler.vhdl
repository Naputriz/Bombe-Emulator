library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Scrambler is
    Port ( 
        char_in   : in  integer; -- Huruf masuk dari keyboard/file
        
        -- Settingan Posisi Rotor (dikontrol oleh 'Otak' nanti)
        pos_r1    : in  integer; 
        pos_r2    : in  integer;
        pos_r3    : in  integer;
        
        char_out  : out integer  -- Hasil enkripsi
    );
end Scrambler;

architecture Structural of Scrambler is

    -- Kabel Internal untuk menghubungkan antar kotak
    signal wire_1 : integer := 0; -- Dari Rotor 1 ke Rotor 2
    signal wire_2 : integer := 0; -- Dari Rotor 2 ke Rotor 3
    signal wire_3 : integer := 0; -- Dari Rotor 3 ke Reflektor
	-- Untuk sementara buat simplifikasi, satu arah dulu (R1->R2->R3->Reflector->Output)
	-- Bisa tambah balik lagi kalau mau

begin

    -- Instansiasi Rotor 1 
    U_Rotor1: entity work.Rotor
        port map (
            input_val   => char_in,
            current_pos => pos_r1,
            output_val  => wire_1  -- Keluar ke kabel 1
        );

    -- Instansiasi Rotor 2 
    U_Rotor2: entity work.Rotor
        port map (
            input_val   => wire_1, -- Masuk dari kabel 1
            current_pos => pos_r2,
            output_val  => wire_2  -- Keluar ke kabel 2
        );

    -- Instansiasi Rotor 3 
    U_Rotor3: entity work.Rotor
        port map (
            input_val   => wire_2,
            current_pos => pos_r3,
            output_val  => wire_3
        );

    -- Instansiasi Reflektor 
    U_Reflector: entity work.Reflector
        port map (
            input_val  => wire_3,
            output_val => char_out -- Hasil akhir langsung keluar
        );

end Structural;