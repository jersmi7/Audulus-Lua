The DSP node `fill()` function is ideal for processing midi data for Audulus.

Currently Audulus relies solely on the knob and slider modules to get midi data in. Here are some simple Lua utilities to comvert midi to control signal.

The idea is to get the CC data into Audulus, then convert it to serve your purposes. It doesn't matter if a midi button on your controller is assigned to an Audulus knob -- you just need the data.
