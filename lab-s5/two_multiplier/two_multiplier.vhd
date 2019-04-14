library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package seven_segment_types is
  constant N7Seg : integer := 4;
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
  type seven_segment_output is array(0 to N7Seg) of std_logic_vector(6 downto 0);
end package seven_segment_types;

use work.seven_segment_types.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity two_multiplier is
	port (
    inputs  : in std_logic_vector(9 downto 0);
    led_outputs : out unsigned(9 downto 0);
    display_outputs : out seven_segment_output
  );
end entity two_multiplier;

architecture a_two_multiplier of two_multiplier is
  type int_array is array(0 to 9) of integer;
  signal adder : int_array;
  signal s_outputs : unsigned(9 downto 0);
  signal result : integer;


begin 
    adder(0) <= 1 when inputs(0) = '1' else 0;
    for_gen: for i in 1 to 9 generate
      adder(i) <= adder(i-1) + 1 when inputs(i) = '1' else adder(i-1);
    end generate;

  result <= adder(9);
  led_outputs <= to_unsigned(result, 10);

  display_outputs(0) <=      seven_seg_numbers(result mod 16);
  seg_gen: for i in 1 to N7Seg generate
    display_outputs(i) <= seven_seg_numbers(result / (16 * i) mod 16);
  end generate;

end architecture a_two_multiplier;