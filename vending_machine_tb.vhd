
library ieee;
  use ieee.std_logic_1164.all;

entity VENDING_MACHINE_TB is
end entity VENDING_MACHINE_TB;

architecture BEHAV of VENDING_MACHINE_TB is

  component VENDING_MACHINE is
    port (
      CLK               : in    std_ulogic;
      COIN_INSERTED     : in    std_ulogic;
      DISPENSE_BEVERAGE : out   std_ulogic;
      RETURN_COIN       : out   std_ulogic
    );
  end component;

  signal done              : std_ulogic := '0';
  signal clk               : std_ulogic := '0';
  signal coin_inserted     : std_ulogic;
  signal dispense_beverage : std_ulogic;
  signal return_coin       : std_ulogic;

begin

  --  Component instantiation.

  VEND0 : VENDING_MACHINE
    port map (
      CLK               => clk,
      COIN_INSERTED     => coin_inserted,
      DISPENSE_BEVERAGE => dispense_beverage,
      RETURN_COIN       => return_coin
    );

  clk <= not clk after 1 ns when done /= '1' else
         '0';

  VEND_TB : process
  begin

    -- First beverage we charge for
    coin_inserted <= '1';
    wait for 2 ns;
    assert dispense_beverage = '1';
    assert return_coin = '0';
    coin_inserted <= '0';
    wait for 2 ns;
    assert dispense_beverage = '0';
    assert return_coin = '0';

    -- Second beverage we charge for
    coin_inserted <= '1';
    wait for 2 ns;
    assert dispense_beverage = '1';
    assert return_coin = '0';
    coin_inserted <= '0';
    wait for 2 ns;
    assert dispense_beverage = '0';
    assert return_coin = '0';

    -- Third one is free!
    coin_inserted <= '1';
    wait for 2 ns;
    assert dispense_beverage = '1';
    assert return_coin = '1'; -- FREE!
    coin_inserted <= '0';
    wait for 2 ns;
    assert dispense_beverage = '0';
    assert return_coin = '0';

    report "Vending machine testbench finished.";
    done <= '1';
    wait;

  end process VEND_TB;

end architecture BEHAV;
