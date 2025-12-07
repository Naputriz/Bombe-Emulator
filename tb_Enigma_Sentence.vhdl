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
			type_r1   => 0,
            type_r2   => 1,
            type_r3   => 2,
			type_ref  => 1,
			char_out  => char_out_sig
        );

    process
    begin
       -- KASUS 1: Cek Output di Posisi Awal (0-0-0)
        report "TES 1: Input 0 pada Posisi 0-0-0";
        pos_r1_sig <= 0;
        char_in_sig <= 0; -- Input 'A' (akan ditukar jadi Z oleh Plugboard)
        wait for 10 ns;
        report "Output Posisi 0: " & integer'image(char_out_sig);
		
		-- PEMBUKTIAN RESIPROKAL
        -- Kalau A jadi B, maka B harus jadi A
        char_in_sig <= char_out_sig; 
        wait for 10 ns;
        
        if char_out_sig = 0 then
            report "STATUS: Valid Resiprokal (Kembali ke 0)";
        else
            report "STATUS: ERROR! Tidak Resiprokal";
        end if;
		
		-- 2: Cek Output di Posisi 1 (1-0-0)
        report "TES 2: Input A (0) pada Posisi 1-0-0";
        pos_r1_sig <= 1;
        char_in_sig <= 0; -- Input 'A'
        wait for 10 ns;
        
        report "Output Posisi 1: " & integer'image(char_out_sig);
        
        -- Catat angka yang muncul di waveform untuk tb_Bombe_Emulator
		
        wait;
    end process;

end Sim;