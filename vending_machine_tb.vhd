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
  signal coin_inserted     : std_ulogic := '0';
  signal dispense_beverage : std_ulogic;
  signal return_coin       : std_ulogic;
  signal reset             : std_ulogic := '0';

begin

  -- Clock signal generation
  clk <= not clk after 1 ns when done /= '1' else '0';

  -- Instantiate the VENDING_MACHINE component
  VEND0 : VENDING_MACHINE
    port map (
      CLK               => clk,
      COIN_INSERTED     => coin_inserted,
      DISPENSE_BEVERAGE => dispense_beverage,
      RETURN_COIN       => return_coin
    );

  VEND_TB : process
    variable cycles : integer := 0;
  begin
    -- Initialize the system with a reset
    reset <= '1';
    wait for 2 ns;
    reset <= '0';

    -- Loop to test multiple cycles of vending
    for i in 1 to 9 loop
      cycles := cycles + 1;
      coin_inserted <= '1';
      wait for 2 ns;

      if (dispense_beverage = '1') then
        if (return_coin = '1') then
          report "Cycle " & integer'image(cycles) & ": Dispensed a FREE beverage!";
        else
          report "Cycle " & integer'image(cycles) & ": Dispensed a beverage (paid).";
        end if;
      else
        report "Cycle " & integer'image(cycles) & ": No beverage dispensed - ERROR!" severity error;
      end if;

      -- Reset coin insertion and check outputs
      coin_inserted <= '0';
      wait for 2 ns;
      assert dispense_beverage = '0' report "Beverage output should be low after dispense." severity failure;
      assert return_coin = '0' report "Return coin should be low after dispense." severity failure;
    end loop;

    report "Vending machine testbench finished successfully.";
    done <= '1';
    wait;

  end process VEND_TB;

end architecture BEHAV;
