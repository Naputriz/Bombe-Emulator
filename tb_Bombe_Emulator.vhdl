library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Bombe_Emulator is
end tb_Bombe_Emulator;

architecture Sim of tb_Bombe_Emulator is

    -- Sinyal Testbench
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal done  : std_logic;
    
    -- Sinyal Input Data
    signal tb_char_in : integer := 0;
    signal tb_target  : integer := 0;

    constant clk_period : time := 10 ns;

begin

    -- Pasang Unit Utama
    UUT: entity work.Bombe_Emulator
        port map (
            clk       => clk,
            reset_btn => reset,
            char_in   => tb_char_in, 
            target_in => tb_target,  
            
            finished  => done
        );

    -- Clock Process
    process begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- Stimulus Process
    process begin
        -- Kasus 1: Posisi 0
        -- Kita cari tahu Rotor harus di posisi berapa supaya A (0) jadi G (6)?
        tb_char_in <= 0; 
        tb_target  <= 6; 
        
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Tunggu Case 1 selesai
        wait until done = '1';
        wait for 50 ns;
        
        -- Cari target 2 (Seharusnnya di posisi 1, berdasarkan output tb_enigma_sentence)
        tb_target <= 2;
        
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Tunggu Case 2 selesai
        wait until done = '1'; 
        wait for 50 ns;

        wait; -- Selesai simulasi
    end process;

end Sim;