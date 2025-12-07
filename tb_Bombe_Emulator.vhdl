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
	
	-- Sinyal Konfigurasi mesin
    -- Default kita set: I - II - III dengan reflector B
    signal tb_rot1 : integer := 0; 
    signal tb_rot2 : integer := 1;
    signal tb_rot3 : integer := 2;
	signal tb_ref  : integer := 1;
	
	signal result_r1 : integer;
    signal result_r2 : integer;
    signal result_r3 : integer;

    constant clk_period : time := 10 ns;

begin

    -- Pasang Unit Utama
    UUT: entity work.Bombe_Emulator
        port map (
            clk       => clk,
            reset_btn => reset,
            char_in   => tb_char_in, 
            target_in => tb_target,
			rotor1_select => tb_rot1,
            rotor2_select => tb_rot2,
            rotor3_select => tb_rot3,		
			reflector_select => tb_ref,
			found_r1      => result_r1,
            found_r2      => result_r2,
            found_r3      => result_r3,
            
            finished  => done
        );

    -- Clock Process
    process begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- Stimulus Process
    process begin
		-- CONFIG: Set Rotor Urutan I - II - III
        tb_rot1 <= 0; -- Rotor I
        tb_rot2 <= 1; -- Rotor II
        tb_rot3 <= 2; -- Rotor III
		tb_ref  <= 1; -- Pakai Reflector B
		
        -- Kasus 1: Posisi 0
        tb_char_in <= 0; 
        tb_target  <= 7; 
        
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Tunggu Case 1 selesai
        wait until done = '1';
        wait for 50 ns;
        
        -- Cari target 2 
        tb_target <= 3;
        
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Tunggu Case 2 selesai
        wait until done = '1'; 
        wait for 50 ns;

        wait; -- Selesai simulasi
    end process;

end Sim;