library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package seven_segment_types is
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
end package seven_segment_types;

use work.seven_segment_types.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity two_multiplier is
    generic(
        NSwitch : integer := 10;
        NLeds   : integer := 10;
        NButton : integer := 3;
        N7Seg : integer := 4
    );
    port (
    switch_inputs   : in std_logic_vector(NSwitch-1 downto 0);
    button_inputs   : in std_logic_vector(NButton-1 downto 0);
    led_outputs     : out unsigned(NLeds-1 downto 0);
    display_outputs : out seven_segment_output(3 downto 0)
    );
end entity two_multiplier;

architecture a_two_multiplier of two_multiplier is
    type int_array is array(integer range <>) of integer;
    signal switch_adder : int_array(0 to NSwitch-1);
    signal button_adder : int_array(0 to NButton-1);
    signal result       : integer;

begin 
    --Conta número de switches ligados
    switch_adder(0) <= 1 when switch_inputs(0) = '1' else 0;
    for_gen: for i in 1 to NSwitch-1 generate
    switch_adder(i) <= switch_adder(i-1) + 1 when switch_inputs(i) = '1' else switch_adder(i-1);
    end generate;

    --Conta número de botões ligados
    button_adder(0) <= 1 when button_inputs(0) = '1' else 0;
    button_add: for i in 1 to NButton-1 generate
    button_adder(i) <= button_adder(i-1) + 1 when button_inputs(i) = '1' else button_adder(i-1);
    end generate;
  
    --Resultado: Chaves * 2^Botões
    result <= switch_adder(NSwitch-1) * (2 ** button_adder(NButton-1));

    --Mostra resultado em binário nos LEDs
    led_outputs <= to_unsigned(result, 10);

    --Mostra resultado em hexadecimal nos displays 7 segmentos
    display_outputs(0) <= seven_seg_numbers(result mod 16);
    seg_gen: for i in 1 to N7Seg generate
        display_outputs(i) <= seven_seg_numbers(result / (16 * i) mod 16);
    end generate;

end architecture a_two_multiplier;