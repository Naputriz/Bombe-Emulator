library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    Port ( 
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        
        -- Koneksi ke ROM
        rom_addr      : out integer range 0 to 15;       -- Minta baris ke-sekian
        rom_data      : in  STD_LOGIC_VECTOR(3 downto 0);-- Baca Opcode
        
        -- Koneksi ke Scrambler
        pos_r1        : out integer; -- Mengontrol posisi Rotor 1
		pos_r2        : out integer; 
        pos_r3        : out integer; 
        
        -- Koneksi ke Comparator
        found_signal  : in  STD_LOGIC; -- Masukan dari Comparator (1 = Ketemu)
        
        -- Status Output
        finished      : out STD_LOGIC -- Lampu hijau kalau selesai
    );
end Controller;

architecture Behavioral of Controller is

    -- Sinyal Internal untuk Program Counter (Penunjuk Baris)
    signal pc : integer range 0 to 15 := 0;
	
    -- Register Posisi untuk 3 Rotor
	signal curr_r1 : integer := 0;
    signal curr_r2 : integer := 0;
    signal curr_r3 : integer := 0;
	
    -- Sinyal Internal untuk Posisi Rotor
    signal current_rotor_pos : integer := 0;
    
    -- Definisi Opcode (Harus sama persis dengan di ROM)
    constant OP_LOAD  : std_logic_vector(3 downto 0) := "0001"; 
    constant OP_STEP  : std_logic_vector(3 downto 0) := "0010"; 
    constant OP_CHECK : std_logic_vector(3 downto 0) := "0011"; 
    constant OP_LOOP  : std_logic_vector(3 downto 0) := "0100"; 
    constant OP_STOP  : std_logic_vector(3 downto 0) := "1111"; 

    -- State Machine
    type state_type is (FETCH, EXECUTE, HALT);
    signal state : state_type := FETCH;

begin

    -- Update Output Posisi ke Scrambler
	pos_r1 <= curr_r1;
    pos_r2 <= curr_r2;
    pos_r3 <= curr_r3;
    rom_addr <= pc;

    process(clk, reset)
    begin
        if reset = '1' then
            pc <= 0;
            curr_r1 <= 0;
            curr_r2 <= 0;
            curr_r3 <= 0;
            state <= FETCH;
            finished <= '0';
            
        elsif rising_edge(clk) then
            
            case state is
                -- PHASE 1: FETCH (Ambil Instruksi)
                when FETCH =>
                    -- Tunggu sebentar biar data ROM stabil, lalu eksekusi
                    state <= EXECUTE; 

                -- PHASE 2: EXECUTE (Jalankan Perintah)
                when EXECUTE =>
                    case rom_data is
                        
                        when OP_LOAD =>
                            -- Reset semuanya
                            curr_r1 <= 0;
                            curr_r2 <= 0;
                            curr_r3 <= 0;
                            pc <= pc + 1; -- Lanjut baris berikutnya
                            state <= FETCH;

                        when OP_STEP =>
                            -- Putar Rotor 1 dulu
                            if curr_r1 < 25 then
                                curr_r1 <= curr_r1 + 1;
                            else
                                -- R1 mentok, reset ke posisi 0 lalu putar R2
                                curr_r1 <= 0;
                                
                                if curr_r2 < 25 then
                                    curr_r2 <= curr_r2 + 1;
                                else
                                    -- R2 mentok, reset ke posisi 0, lalu putar R3
                                    curr_r2 <= 0;
                                    
                                    if curr_r3 < 25 then
                                        curr_r3 <= curr_r3 + 1;
                                    else
                                        -- Semua mentok, reset semua
                                        curr_r3 <= 0;
                                    end if;
                                end if;
                            end if;
                            pc <= pc + 1;
                            state <= FETCH;

                        when OP_CHECK =>
                            -- Cek apakah Comparator bilang "FOUND"?
                            if found_signal = '1' then
                                state <= HALT; -- KETEMU! Berhenti.
                            else
                                pc <= pc + 1; -- Belum ketemu, lanjut.
                                state <= FETCH;
                            end if;

                        when OP_LOOP =>
                            -- Loncat balik ke baris 1 (Start of Loop)
                            pc <= 1; 
                            state <= FETCH;

                        when OP_STOP =>
                            state <= HALT;
                            
                        when others =>
                            state <= HALT;
                    end case;

                -- PHASE 3: HALT (Berhenti / Selesai)
                when HALT =>
                    finished <= '1'; -- Nyalakan lampu hijau
                    -- Diam di sini selamanya sampai di-reset

            end case;
        end if;
    end process;

end Behavioral;