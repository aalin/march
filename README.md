# Music thing

This thing implements some music theory.

Install by typing `rake install`.

# Demos

## Setup (OS X)

* Open `Audio MIDI Setup`, click the `IAC Driver` and make sure the device is on and that it has a port.
* Get [Propellerheads Reason 5](http://www.propellerheads.se/products/reason/). The demo version should work.
* In Reason, go to `Preferences -> Advanced -> External Control` and choose `IAC Driver Bus 1` for `Bus A`.

## Running

Enter `demos/` and open `mfiuegw.rns` with Reason, and start the demo by typing:

    ruby mfiuegw.rb

If you have everything set up correctly, you'll hear sounds.

# TODO

* Fix note lenghts from midi.
* Refactor the midi thing.
* Beat trees should be able to be longer than one measure.
* Delegate chord selection to the midi sequence player.
* In F major, the IV should be called Bb instead of A# so that we don't get two As.
