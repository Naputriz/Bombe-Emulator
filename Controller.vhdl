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
        
        -- Koneksi ke Comparator
        found_signal  : in  STD_LOGIC; -- Masukan dari Comparator (1 = Ketemu)
        
        -- Status Output
        finished      : out STD_LOGIC -- Lampu hijau kalau selesai
    );
end Controller;

architecture Behavioral of Controller is

    -- Sinyal Internal untuk Program Counter (Penunjuk Baris)
    signal pc : integer range 0 to 15 := 0;
    
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
    pos_r1   <= current_rotor_pos;
    rom_addr <= pc;

    process(clk, reset)
    begin
        if reset = '1' then
            pc <= 0;
            current_rotor_pos <= 0;
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
                            current_rotor_pos <= 0;
                            pc <= pc + 1; -- Lanjut baris berikutnya
                            state <= FETCH;

                        when OP_STEP =>
                            -- Putar Rotor (+1)
                            if current_rotor_pos < 25 then
                                current_rotor_pos <= current_rotor_pos + 1;
                            else
                                current_rotor_pos <= 0; -- Wrap around Z ke A
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