----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2019 18:40:16
-- Design Name: 
-- Module Name: motion_control - arc_motion_control
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity motion_control is
    generic(output_size: integer := 8);
    Port (move_in : in std_logic;
          clk : in std_logic;
          clockwise_in : in std_logic;
          input_vector: in std_logic_vector(0 to output_size-1);
          output_leds:  out std_logic_vector(0 to output_size-1)
    );
end motion_control;

architecture arc_motion_control of motion_control is
    signal clockwise_s_out : std_logic;
    signal output_buffer : std_logic_vector(0 to (2*output_size)-1);
    --signal output_leds_s : std_logic_vector(0 to output_size-1);
    
    component debounce is
        generic( n_inputs: integer := 1;
                 debounce_ms: integer := 100;
                 clock_value: integer := 100000000
        );
        port( clk: in std_logic;
              button_in: in std_logic_vector(0 to n_inputs-1);
              pulse_out: out std_logic_vector(0 to n_inputs-1)
        );
      end component debounce;
begin
    btn_debounce: component debounce
    port map(
        button_in(0)=>clockwise_in,
        pulse_out(0)=>clockwise_s_out,
        clk=>clk
    );
process(move_in)
    variable motion_counter: integer := 0;

    begin
    if(rising_edge(move_in)) then
        output_buffer <= input_vector & input_vector;
        for I in 0 to (output_size-1) loop
            if(clockwise_s_out = '1') then
                output_leds(I) <= output_buffer(motion_counter + I); 
            else
                output_leds(I) <= output_buffer((output_size - motion_counter) + I);  
            end if;
        end loop;
        motion_counter := (motion_counter + 1);
        if( motion_counter >= output_size) then 
            motion_counter := 0;
        end if;
    end if;
    end process ; -- identifier

end arc_motion_control;
