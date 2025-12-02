library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reflector is
    Port ( 
        input_val  : in  integer;
        output_val : out integer
    );
end Reflector;

architecture Dataflow of Reflector is
begin
    -- Reflektor Sederhana: Membalik urutan abjad (A jadi Z, B jadi Y)
    output_val <= 25 - input_val;
end Dataflow;