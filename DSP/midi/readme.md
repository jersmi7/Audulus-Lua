# DSP node midi utilities

Using Lua via the Audulus DSP node is ideal for processing midi data. DSP node has its own control rate signal using `fill()` -- super lightweight on CPU. Since midi CC's are typically 7-bit resolution (0 to 127), `fill()` operating at block rate is plenty good.

Currently Audulus relies solely on the knob and slider modules to get midi data in. That's fine -- the idea is to get the CC data into Audulus by any means necessary, then convert it to serve your purposes. For example, it doesn't matter if a midi button on your controller is assigned to an Audulus knob -- you just need the data.
