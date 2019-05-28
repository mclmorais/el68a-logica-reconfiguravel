----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07.05.2019 21:14:46
-- Design Name:
-- Module Name: rpn_calc - arch_rpn_calc
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

entity rpn_calc is
    generic(STACK_N     : integer := 7
    );

  port( btn         : in    std_logic_vector(2 downto 0);
        rst         : in    std_logic;
        enter       : in    std_logic;
        sw_aux      : in    std_logic;
        clk         : in    std_logic;
        v_output    : out   integer
  );
end rpn_calc;

-- sw_aux  btn(2)   btn(1)   btn(0)
--   0      INC       +       *
--   1      DEC       -       /

architecture arch_rpn_calc of rpn_calc is
    type int_array is array(STACK_N-1 downto 0) of integer;
    signal rpn_stack : int_array; --STACK
    signal stack_status : std_logic_vector(STACK_N-1 downto 0); --STACK STATUS
    signal out_show : integer; -- Result to show
    signal btn_inc : std_logic;
    signal btn_dec : std_logic;
    signal rst_counter : std_logic;
    signal value_output_s : std_logic_vector(31 downto 0) := x"00000000";

    component button_inc_dec is
        port (
            button_inc : in  std_logic;
            button_dec : in  std_logic;
            clk        : in  std_logic;
            rst        : in  std_logic;
            value_output : out std_logic_vector(31 downto 0)
        );
    end component button_inc_dec;

    begin
        btn_inc <= sw_aux and btn(2);
        btn_dec <= (not sw_aux) and btn(2);
        inc_dec_device: component button_inc_dec
        port map(
            button_inc      => btn_inc,
            button_dec      => btn_dec,
            clk             => clk,
            rst             => rst_counter,
            value_output    => value_output_s
        );
        process(clk, rst, sw_aux, btn)

        variable estado : integer := 0;
        variable stack_pointer : integer; -- stack pointer to indicate the stack position
        variable prev_stack_pointer : integer; -- stack pointer to indicate the stack position
        variable btn_aux : std_logic_vector(2 downto 0);
        variable calc_output : integer;

        begin
            btn_aux := sw_aux & btn(1) & btn(0);
            if(rst = '0') then
                if(rising_edge(clk)) then
                case estado is
                    when 0 =>
                        stack_pointer := 0;
                        prev_stack_pointer := ( STACK_N - 1);
                        rst_counter <= '1';
                        for I in 0 to STACK_N-1 loop
                            rpn_stack(I) <= 0;
                            stack_status(I) <= '0';
                        end loop;
                        stack_pointer := 0;
                        estado := 1;
                        out_show <= rpn_stack(stack_pointer);

                    when 1 =>
                        rst_counter <= '0';
                        if(btn = "100") then
                            estado := 2;
                        elsif(btn = "001" or btn = "010") then
                            estado := 3;
                        end if;
                        out_show <= rpn_stack(stack_pointer);

                    when 2 =>
                        out_show <= to_integer(unsigned(value_output_s));
                        if(enter = '1') then
                            stack_pointer := stack_pointer + 1;
                            prev_stack_pointer := prev_stack_pointer + 1;
                            if (stack_pointer = STACK_N) then
                                stack_pointer := 0;
                            end if;
                            if (prev_stack_pointer = STACK_N) then
                                prev_stack_pointer := 0;
                            end if;
                            rpn_stack(stack_pointer) <= to_integer(unsigned(value_output_s));
                            stack_status(stack_pointer) <= '1';
                            rst_counter <= '1';
                            estado := 1;
                        end if;

                    when 3 =>
                        if(stack_status(stack_pointer) = '1' and stack_status(prev_stack_pointer)  = '1') then
                            case btn_aux is
                                when "001" =>
                                    calc_output := rpn_stack(stack_pointer) * rpn_stack(prev_stack_pointer);
                                when "010" =>
                                    calc_output := rpn_stack(stack_pointer) + rpn_stack(prev_stack_pointer);
                                when "101" =>
                                    calc_output := rpn_stack(stack_pointer) / rpn_stack(prev_stack_pointer);
                                when "110" =>
                                    calc_output := rpn_stack(stack_pointer) - rpn_stack(prev_stack_pointer);
                                when others =>
                                    calc_output := 0;
                            end case;
                            stack_status(stack_pointer) <= '0';
                            rpn_stack(prev_stack_pointer) <= calc_output;
                            stack_pointer := prev_stack_pointer;
                            if (prev_stack_pointer = 0) then
                                prev_stack_pointer := (STACK_N - 1);
                            else
                                prev_stack_pointer := prev_stack_pointer - 1;
                            end if;
                        end if;
                    when others =>
                        estado := 1;
                    end case;
                    v_output <= out_show;
                end if;
            else
                estado := 0;
            end if;
        end process;
end arch_rpn_calc;
