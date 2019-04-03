library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity binary_to_gray is
  port (
    selector : in std_logic;
    inputs  : in std_logic_vector(9 downto 0);
    outputs : out std_logic_vector(9 downto 0)
  );
end entity binary_to_gray;

architecture a_binary_to_gray of binary_to_gray is
    signal s_outputs = std_logic_vector(9 downto 0)

begin
    outputs(9) <= inputs(9)
    for i in 8 downto 0 loop
        output(i) <= input(i+1) xor input(i);
    end generate;
  
  
end architecture a_binary_to_gray;