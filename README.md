# Vending machine FSM

On a recent edition of [NPR's planet
money](https://www.fastmail.com/mail/Inbox/?u=bed84147), I heard the
story of how the price for Coke didn't change for over 70 years.  As
late as 1959, you could buy a 6.5 ounce Coca Cola for a nickel. This
price wasn't sustainable and at one point, the company discussed raising
the price, but their vending machines had a problem: they could only
handle accepting a single coin.

Executives at Coca Cola thought that increasing the price to 10¢ was far
too much, and even asked the U.S. Treasury to begin minting a special
7 1/2 cent coin.  This didn't happen, so someone came up with the crazy
idea that they would load every 9th bottle in the vending machine with
an empty bottle, forcing the vending machine user to put in another coin
to get their drink.  This would have the effect of raising the price to
just shy of 6 cents per bottle.

Of course, the 9th person would be pretty angry. What if we increase the
price to 10 cents, but every 3rd person gets a free coke - making the
average price around 6 cents?

Luckily, our single coin vending machine has an FPGA built-in and we can
write a solution that does this in VHDL.  This repo contains a sample
of a finite state machine in VHDL, a testbench, and a Makefile that uses
GHDL to simulate it.
