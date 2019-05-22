library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity button_inc_dec is
  port (
    button_inc : in  std_logic;
    button_dec : in  std_logic;
    clk        : in  std_logic
  );
end entity button_inc_dec;

architecture a_button_inc_dec of button_inc_dec is
  signal count : integer;

  signal debounced_inc : std_logic;
  signal debounced_dec : std_logic;

  component debounce is
      generic( n_inputs: integer := 2;
                debounce_ms: integer := 100;
                clock_value: integer := 100000000
      );
      port( clk: in std_logic;
            button_in: in std_logic_vector(0 to n_inputs-1);
            pulse_out: out std_logic_vector(0 to n_inputs-1)
      );
    end component debounce;

begin

  middleware_debounce : component debounce
  port map (
	 clk => clk,
    button_in(0) => button_inc,
    pulse_out(0) => debounced_inc,
    button_in(1) => button_dec,
    pulse_out(1) => debounced_dec
  );  

  process(clk)
    variable already_pressed : std_logic;
  begin
    if rising_edge(clk) then
      if already_pressed = '0' then
        if debounced_inc = '0' then
          count <= count + 1;
          already_pressed := '1';
        elsif debounced_dec = '0' then
          count <= count - 1;
          already_pressed := '1';
        else
          already_pressed := '0';
        end if; 
      end if;
    end if;
  end process;
  
  
end architecture a_button_inc_dec;