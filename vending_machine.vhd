library ieee;
use ieee.std_logic_1164.all;

entity vending_machine is
  port (
    clk               : in  std_ulogic;
    coin_inserted     : in  std_ulogic;
    dispense_beverage : out std_ulogic;
    return_coin       : out std_ulogic
  );
end entity vending_machine;

architecture behavior of vending_machine is

  -- state definitions
  type states is (WAIT_FIRST_COIN, DISPENSE_PAID_1, WAIT_SECOND_COIN, DISPENSE_PAID_2, WAIT_FREE_COIN, DISPENSE_FREE);
  signal current_state, next_state : states := WAIT_FIRST_COIN;

begin

  -- state transition process
  vend_process: process (clk)
  begin
    if rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process vend_process;

  -- next state logic
  next_state_logic: process (current_state, coin_inserted)
  begin
    case current_state is

      when WAIT_FIRST_COIN =>
        if coin_inserted = '1' then
          next_state <= DISPENSE_PAID_1;
        else
          next_state <= WAIT_FIRST_COIN;
        end if;

      when DISPENSE_PAID_1 =>
        next_state <= WAIT_SECOND_COIN;

      when WAIT_SECOND_COIN =>
        if coin_inserted = '1' then
          next_state <= DISPENSE_PAID_2;
        else
          next_state <= WAIT_SECOND_COIN;
        end if;

      when DISPENSE_PAID_2 =>
        next_state <= WAIT_FREE_COIN;

      when WAIT_FREE_COIN =>
        if coin_inserted = '1' then
          next_state <= DISPENSE_FREE;
        else
          next_state <= WAIT_FREE_COIN;
        end if;

      when DISPENSE_FREE =>
        next_state <= WAIT_FIRST_COIN;

      when others =>
        next_state <= WAIT_FIRST_COIN;

    end case;
  end process next_state_logic;

  -- output logic for dispensing beverage and returning coin
  with current_state select
    dispense_beverage <= '1' when DISPENSE_PAID_1 | DISPENSE_PAID_2 | DISPENSE_FREE,
                         '0' when others;

  with current_state select
    return_coin <= '1' when DISPENSE_FREE,
                   '0' when others;

end architecture behavior;
