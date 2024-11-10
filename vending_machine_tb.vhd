library ieee;
use ieee.std_logic_1164.all;

entity vending_machine_tb is
end entity vending_machine_tb;

architecture behavior of vending_machine_tb is

  component vending_machine is
    port (
      clk               : in  std_ulogic;
      coin_inserted     : in  std_ulogic;
      dispense_beverage : out std_ulogic;
      return_coin       : out std_ulogic
    );
  end component;

  signal done              : std_ulogic := '0';
  signal clk               : std_ulogic := '0';
  signal coin_inserted     : std_ulogic := '0';
  signal dispense_beverage : std_ulogic;
  signal return_coin       : std_ulogic;
  signal reset             : std_ulogic := '0';

begin

  -- clock signal generation
  clk <= not clk after 1 ns when done /= '1' else '0';

  -- instantiate the vending_machine component
  vend0 : vending_machine
    port map (
      clk               => clk,
      coin_inserted     => coin_inserted,
      dispense_beverage => dispense_beverage,
      return_coin       => return_coin
    );

  vend_tb : process
    variable cycles : integer := 0;
  begin
    -- initialize the system with a reset
    reset <= '1';
    wait for 2 ns;
    reset <= '0';

    -- loop to test multiple cycles of vending
    for i in 1 to 9 loop
      cycles := cycles + 1;
      coin_inserted <= '1';
      wait for 2 ns;

      if dispense_beverage = '1' then
        if return_coin = '1' then
          report "cycle " & integer'image(cycles) & ": dispensed a FREE beverage!";
        else
          report "cycle " & integer'image(cycles) & ": dispensed a beverage (paid).";
        end if;
      else
        report "cycle " & integer'image(cycles) & ": no beverage dispensed - error!" severity error;
      end if;

      -- reset coin insertion and check outputs
      coin_inserted <= '0';
      wait for 2 ns;
      assert dispense_beverage = '0' report "beverage output should be low after dispense." severity failure;
      assert return_coin = '0' report "return coin should be low after dispense." severity failure;
    end loop;

    report "vending machine testbench finished successfully.";
    done <= '1';
    wait;

  end process vend_tb;

end architecture behavior;
