library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_ROM is
    Port ( 
        clk  : in  STD_LOGIC;
        addr : in  integer range 0 to 15;        -- Alamat Baris Instruksi
        data : out STD_LOGIC_VECTOR(3 downto 0)  -- Isi Instruksi (Opcode)
    );
end Instruction_ROM;

architecture Behavioral of Instruction_ROM is
    
    -- Definisi Tipe Instruksi
    constant OP_LOAD  : std_logic_vector(3 downto 0) := "0001"; -- Reset posisi
    constant OP_STEP  : std_logic_vector(3 downto 0) := "0010"; -- Putar Rotor
    constant OP_CHECK : std_logic_vector(3 downto 0) := "0011"; -- Cek Hasil
	constant OP_LOOP  : std_logic_vector(3 downto 0) := "0100"; -- Loop ke baris tertentu
    constant OP_STOP  : std_logic_vector(3 downto 0) := "1111"; -- Selesai

    type rom_type is array (0 to 15) of std_logic_vector(3 downto 0);

    -- Isi Program 
    constant ROM : rom_type := (
        0 => OP_LOAD,   -- Langkah 0: Reset posisi rotor ke awal
        1 => OP_CHECK,  -- Langkah 1: Cek apakah settingan sekarang cocok atau ga
        2 => OP_STEP,   -- Langkah 2: Kalau belum, putar rotor 1 klik
        3 => OP_LOOP,	-- Langkah 3: Controller loncat balik ke alamat 1
        others => OP_STOP -- Sisanya STOP
    );

begin

    process(clk)
    begin
        if rising_edge(clk) then
            data <= ROM(addr); -- Ambil instruksi sesuai alamat yang diminta
        end if;
    end process;

end Behavioral;