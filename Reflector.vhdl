library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reflector is
    Port ( 
        input_val  : in  integer;
		type_ref   : in  integer range 0 to 2;
        output_val : out integer
    );
end Reflector;

architecture Dataflow of Reflector is
	type integer_array is array (0 to 25) of integer;
	
	-- REFLECTOR A (EJMZALYXVBWFCRQUONTSPIKHGD)
    constant REF_A : integer_array := (
        4, 9, 12, 25, 0, 11, 24, 23, 21, 1, 22, 5, 2, 17, 16, 20, 14, 13, 19, 18, 15, 8, 10, 7, 6, 3
    );

    -- REFLECTOR B (YRUHQSLDPXNGOKMIEBFZCWVJAT)
    constant REF_B : integer_array := (
        24, 17, 20, 7, 16, 18, 11, 3, 15, 23, 13, 6, 14, 10, 12, 8, 4, 1, 5, 25, 2, 22, 21, 9, 0, 19
    );

    -- REFLECTOR C (FVPJIAOYEDRZXWGCTKUQSBNMHL)
    constant REF_C : integer_array := (
        5, 21, 15, 9, 8, 0, 14, 24, 4, 3, 17, 25, 23, 22, 6, 2, 19, 10, 20, 16, 18, 1, 13, 12, 7, 11
    );
	
begin
    process(input_val, type_ref)
        variable safe_val : integer := 0;
	begin
        -- Sanitasi Input
        if (input_val >= 0) and (input_val <= 25) then
            safe_val := input_val;
        else
            safe_val := 0;
        end if;

        -- Pilih Reflektor berdasarkan input type_ref
        case type_ref is
            when 0 => output_val <= REF_A(safe_val); -- UKW-A
            when 1 => output_val <= REF_B(safe_val); -- UKW-B
            when 2 => output_val <= REF_C(safe_val); -- UKW-C
            when others => output_val <= REF_B(safe_val); -- Default ke B
        end case;
    end process;
end Dataflow;