library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Enigma_Sentence is
end tb_Enigma_Sentence;

architecture Sim of tb_Enigma_Sentence is

    signal char_in_sig  : integer := 0;
    signal pos_r1_sig   : integer := 0; 
    signal char_out_sig : integer;
    
    constant ZERO_POS : integer := 0;

begin

    -- Panggil Mesin Scrambler (Unit Fisik)
    UUT: entity work.Scrambler
        port map (
            char_in   => char_in_sig,
            pos_r1    => pos_r1_sig,
            pos_r2    => ZERO_POS,
            pos_r3    => ZERO_POS,
            char_out  => char_out_sig
        );

    process
    begin
        --TES 1: ENKRIPSI MAJU (Posisi 0)
        report "Tes 1: Input A (0) pada Posisi 0";
        pos_r1_sig <= 0;
        char_in_sig <= 0; -- Masuk 'A'
        wait for 10 ns;
        -- Output harusnya 6 ('G')
        
        -- TES 2: DEKRIPSI BALIK (Posisi 0)
        report "Tes 2: Input G (6) pada Posisi 0 (Pembuktian Reciprocal)";
        pos_r1_sig <= 0;
        char_in_sig <= 6; -- Masuk 'G'
        wait for 10 ns;
        -- EKSPEKTASI:
        -- Karena ini mesin Enigma Reciprocal, G HARUS KEMBALI JADI A (0).
        
        -- TES 3: ENKRIPSI POSISI 1 (Mencari Kunci Baru)
        report "Tes 3: Input A (0) pada Posisi 1";
        pos_r1_sig <= 1;
        char_in_sig <= 0; -- Masuk 'A'
        wait for 10 ns;
        
        wait;
    end process;

end Sim;