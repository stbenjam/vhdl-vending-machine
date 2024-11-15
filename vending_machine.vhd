library ieee;
use ieee.std_logic_1164.all;

entity vending_machine is
  port (
    clk               : in  std_ulogic;
    reset             : in  std_ulogic;
    coin_inserted     : in  std_ulogic;
    dispense_beverage : out std_ulogic;
    return_coin       : out std_ulogic
  );
end entity vending_machine;

architecture behavior of vending_machine is
  type states is (
    WAIT_FIRST_COIN, DISPENSE_PAID_1, WAIT_SECOND_COIN,
    DISPENSE_PAID_2, WAIT_FREE_COIN, DISPENSE_FREE);

  signal current_state : states := WAIT_FIRST_COIN;
begin
  process is
      variable next_state : states := current_state;
  begin
   wait until falling_edge(clk);
    if reset = '1' then
      next_state := WAIT_FIRST_COIN;
    else
      case current_state is
        when WAIT_FIRST_COIN =>
            if coin_inserted = '1' then
              next_state := DISPENSE_PAID_1;
            else
              next_state := WAIT_FIRST_COIN;
            end if;

        when DISPENSE_PAID_1 =>
            next_state := WAIT_SECOND_COIN;

        when WAIT_SECOND_COIN =>
            if coin_inserted = '1' then
              next_state := DISPENSE_PAID_2;
            else
              next_state := WAIT_SECOND_COIN;
            end if;

        when DISPENSE_PAID_2 =>
            next_state := WAIT_FREE_COIN;

        when WAIT_FREE_COIN =>
            if coin_inserted = '1' then
              next_state := DISPENSE_FREE;
            else
              next_state := WAIT_FREE_COIN;
            end if;

        when DISPENSE_FREE =>
            next_state := WAIT_FIRST_COIN;

        when others =>
            next_state := WAIT_FIRST_COIN;
      end case;

      current_state <= next_state;
    end if;
  end process;

  -- Notice all control signals are outside the process and determined only by the state:
  -- combiational logic only!
  with current_state select
      dispense_beverage <= '1' when DISPENSE_PAID_1 | DISPENSE_PAID_2 | DISPENSE_FREE,
      '0' when others;

  with current_state select
      return_coin <= '1' when DISPENSE_FREE,
      '0' when others;
end architecture behavior;