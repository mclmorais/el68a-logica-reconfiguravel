library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


library work;
use work.seven_seg_pkg.all;

entity button_inc_dec is
    generic(
        N7seg : integer := 4
    );
    port (
        button_inc : in  std_logic;
        button_dec : in  std_logic;
        clk        : in  std_logic;
        display_out : out seven_segment_output(N7seg-1 downto 0)
    );
end entity button_inc_dec;

architecture a_button_inc_dec of button_inc_dec is
    signal count : count_number;

    signal debounced_inc : std_logic;
    signal debounced_dec : std_logic;

  component debounce is
      generic( n_inputs: integer := 2;
                debounce_ms: integer := 100;
                clock_value: integer := 50000000
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
        variable startup : boolean := true;
        variable already_pressed : std_logic;
        variable increase, decrease : boolean := false;
        variable counter : count_number;
    begin
    if rising_edge(clk) then
        if startup then
            for i in 0 to N7seg - 1 loop
                counter(i) := 0;
            end loop;

            startup := false;
        end if;

        -- Sets increase/decrease flag depending on button press
        if already_pressed = '0' then
            if debounced_inc = '0' then
                increase := true;
                already_pressed := '1';
            elsif debounced_dec = '0' then
                decrease := true;
                already_pressed := '1';
            else
                already_pressed := '0';
            end if; 
        else
            if debounced_inc = '1' and debounced_dec = '1' then
                already_pressed := '0';
            end if;
        end if;
    

        if increase then 
            increase := false;
            ChangeValue(true, counter);
        elsif decrease then
            decrease := false;
            ChangeValue(false, counter);
        end if;


    count <= counter;
    end if;

    end process;

    seg_gen : for i in 0 to N7Seg - 1 generate
        display_out(i) <= seven_seg_numbers(count(i));
    end generate seg_gen;
    
end architecture a_button_inc_dec;
