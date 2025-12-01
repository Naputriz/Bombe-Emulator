library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Rotor is
    Port ( 
        input_val  : in  integer; -- Input angka 0 sampai 25 (A=0, Z=25)
        output_val : out integer  -- Output angka 0 sampai 25
    );
end Rotor;

architecture Dataflow of Rotor is

    -- Mendefinisikan tipe array langsung di sini (Definisi Lokal)
    type integer_array is array (0 to 25) of integer;

    -- Tabel Pengkabelan Rotor I (Konstanta Hardcoded)
    -- Memetakan huruf masuk ke huruf keluar secara acak
    constant wiring_table : integer_array := (
        4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9
    --  A   B   C  D   E  F  G   H   I   J   K   L   M   N   O  P   Q   R   S   T  U  V  W   X  Y  Z
    );

    -- Memastikan angka input tidak melebihi 
    function safe_limit(val : integer) return integer is
    begin
        if val > 25 then
            return val mod 26;
        else
            return val;
        end if;
    end function;

begin

    output_val <= wiring_table( safe_limit(input_val) );

end Dataflow;