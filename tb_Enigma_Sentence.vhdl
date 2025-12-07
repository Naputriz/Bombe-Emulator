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
			char_out  => char_out_sig
        );

    process
    begin
        -- CEK POSISI 0
        -- Input 'A' (0) dengan Rotor I-II-III di Posisi 0
        report "Cek Posisi 0";
        pos_r1_sig <= 0;
        char_in_sig <= 0; 
        wait for 10 ns;
        
        -- CEK POSISI 1 
        -- Input 'A' (0) dengan Rotor I-II-III di Posisi 1
        report "Cek Posisi 1";
        pos_r1_sig <= 1;
        char_in_sig <= 0; 
        wait for 10 ns;
        
        wait;
    end process;

end Sim;