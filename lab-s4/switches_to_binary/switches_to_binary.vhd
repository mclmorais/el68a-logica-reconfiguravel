library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity switches_to_binary is
  port (
    inputs  : in std_logic_vector(9 downto 0);
    outputs : out std_logic_vector(9 downto 0)
  );
end entity switches_to_binary; 

architecture a_switches_to_binary of switches_to_binary is
  signal s_output std_logic_vector(9 downto 0);
begin

    for_gen: for i in 8 downto 0 generate
        output <= output + '1' when input(i) = '1' else output
    end generate;
  
  s_output <= to_integer(inputs)
  
end architecture a_switches_to_binary;