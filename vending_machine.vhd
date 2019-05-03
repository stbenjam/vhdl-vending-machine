
library ieee;
  use ieee.std_logic_1164.all;

entity VENDING_MACHINE is
  port (
    CLK               : in    std_ulogic;
    COIN_INSERTED     : in    std_ulogic;
    DISPENSE_BEVERAGE : out   std_ulogic;
    RETURN_COIN       : out   std_ulogic
  );
end entity VENDING_MACHINE;

architecture BEHAVIOR of VENDING_MACHINE is

  type states is (IDLE_1, DISPENSE_1, IDLE_2, DISPENSE_2, IDLE_FREE, DISPENSE_FREE);

  signal current_state : states := IDLE_1;

begin

  vend_process: process is
  variable next_state : states;
begin

  wait until CLK'event and CLK = '1';

  case current_state is

    when IDLE_1 =>

      if (COIN_INSERTED = '1') then
        next_state := DISPENSE_1;
      else
        next_state := IDLE_1;
      end if;

    when DISPENSE_1 =>
      next_state := IDLE_2;
    when IDLE_2 =>

      if (COIN_INSERTED = '1') then
        next_state := DISPENSE_2;
      else
        next_state := IDLE_2;
      end if;

    when DISPENSE_2 =>
      next_state := IDLE_FREE;
    when IDLE_FREE =>

      if (COIN_INSERTED = '1') then
        next_state := DISPENSE_FREE;
      else
        next_state := IDLE_FREE;
      end if;

    when DISPENSE_FREE =>
      next_state := IDLE_1;

  end case;

  current_state <= next_state;

end process vend_process;

with current_state select DISPENSE_BEVERAGE <=
                                               '1' when DISPENSE_1 | DISPENSE_2 | DISPENSE_FREE,
                                               '0' when others;

with current_state select RETURN_COIN <=
                                         '1' when DISPENSE_FREE,
                                         '0' when others;

end architecture BEHAVIOR;
