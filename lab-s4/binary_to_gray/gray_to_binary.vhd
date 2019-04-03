library library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity binary_to_gray is
  port (
    inputs  : in std_logic_vector(9 downto 0);
    outputs : out std_logic_vector(9 downto 0);
  )
end entity binary_to_gray;

architecture a_binary_to_gray of binary_to_gray is
  signal s_outputs = std_logic_vector(9 downto 0)
begin
    s_outputs(9) <= inputs(9) xor inputs(8)
      binary_converter : for i in 8 downto 0 generate
        s_outputs(i) <= s_outputs(i+1) xor inputs(i);
    end generate;

    outputs <= s_outputs
  
  
end architecture a_binary_to_gray;