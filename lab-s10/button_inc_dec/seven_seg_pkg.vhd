library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package seven_seg_pkg is
    type seven_seg_number is array (0 to 15) of std_logic_vector(6 downto 0);
    constant seven_seg_numbers : seven_seg_number := (
        "1000000", -- 0
        "1111001", -- 1
        "0100100", -- 2
        "0110000", -- 3
        "0011001", -- 4
        "0010010", -- 5
        "0000010", -- 6
        "1111000", -- 7
        "0000000", -- 8
        "0010000", -- 9
        "0001000", -- A
        "0000011", -- B
        "1000110", -- C
        "0100001", -- D
        "0000110", -- E
        "0001110"  -- F
    );
    type seven_segment_output is array(integer range <>) of std_logic_vector(6 downto 0);
    type count_number is array(integer range <>) of integer range 0 to 10;


    procedure ChangeValue(increase : in boolean; counter: inout count_number);
end package seven_seg_pkg;

package body seven_seg_pkg is
    procedure ChangeValue(increase : in boolean; counter: inout count_number) is
        begin
        -- Increases counter numbers if flag was set
        if increase then
            counter(0) := counter(0) + 1;

            for i in 0 to counter'length - 2 loop
                if counter(i) > 9 then
                    counter(i + 1) := counter(i + 1) + 1;
                    counter(i) := 0;
                end if;
            end loop;

            if counter(counter'length - 1) > 9 then
                for i in 0 to counter'length - 1 loop
                    counter(i) := 0;
                end loop;
            end if;
        end if;

        if not increase then
            counter(0) := counter(0) - 1;

            for i in 0 to counter'length - 2 loop
                if counter(i) > 9 then
                    counter(i + 1) := counter(i + 1) - 1;
                    counter(i) := 9;
                end if;
            end loop;

            if counter(counter'length - 1) > 9 then
                for i in 0 to counter'length - 1 loop
                    counter(i) := 9;
                end loop;
            end if;
        end if;
    end procedure;
    
end package body seven_seg_pkg;