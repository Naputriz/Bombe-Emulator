library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Bombe_Emulator is
    Port ( 
        clk         : in  STD_LOGIC;
        reset_btn   : in  STD_LOGIC;
        finished    : out STD_LOGIC;
		char_in     : in integer;
		target_in   : in integer
    );
end Bombe_Emulator;

architecture Structural of Bombe_Emulator is

    signal wire_rom_addr : integer range 0 to 15 := 0; 
    signal wire_rom_data : std_logic_vector(3 downto 0):= (others => '0');
    signal wire_pos_r1   : integer := 0; 
    signal wire_char_out : integer := 0; 
    signal wire_found    : std_logic := '0';
    
    constant ZERO_POS    : integer := 0;

begin

    -- 1. ROM
    U_ROM: entity work.Instruction_ROM
        port map (
            clk  => clk,
            addr => wire_rom_addr,
            data => wire_rom_data
        );

    -- 2. CONTROLLER
    U_Controller: entity work.Controller
        port map (
            clk          => clk,
            reset        => reset_btn,
            rom_addr     => wire_rom_addr,
            rom_data     => wire_rom_data,
            pos_r1       => wire_pos_r1, 
            found_signal => wire_found, 
            finished     => finished
        );

    -- 3. SCRAMBLER
    U_Scrambler: entity work.Scrambler
        port map (
            char_in   => char_in,
            pos_r1    => wire_pos_r1,
            pos_r2    => ZERO_POS,    
            pos_r3    => ZERO_POS,    
            char_out  => wire_char_out
        );

    -- 4. COMPARATOR 
    U_Comparator: entity work.Comparator
        port map (
            char_in    => wire_char_out,
            target_val => target_in, 
            match_out  => wire_found
        );

end Structural;