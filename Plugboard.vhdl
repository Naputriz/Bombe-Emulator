library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Plugboard is
    Port ( 
        input_val  : in  integer; -- Input Huruf (0-25)
        output_val : out integer  -- Output Huruf (0-25)
    );
end Plugboard;

architecture Dataflow of Plugboard is
    
    type integer_array is array (0 to 25) of integer;
    
    -- KONFIGURASI PLUGBOARD (Hardcoded)
    -- A(0)<->Z(25), B(1)<->Y(24). Sisanya Lurus.
	-- Bisa diganti-ganti
    constant PLUG_CFG : integer_array := (
        25, 24, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 1, 0
     --  A   B  C  D  E  F  G  H  I   J   K   L   M   N   O   P   Q   R   S   T   U   V   W  X  Y  Z
    );

begin
    process(input_val)
    begin
        -- Proteksi input biar ga crash
        if (input_val >= 0) and (input_val <= 25) then
            output_val <= PLUG_CFG(input_val);
        else
            output_val <= 0; -- Default aman
        end if;
    end process;
end Dataflow;