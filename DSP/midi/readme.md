# DSP node midi utilities

Using Lua via the Audulus DSP node is ideal for processing midi data. DSP node has its own control rate signal using `fill()` for output, which uses block rate instead of sample rate processing -- lightweight on CPU, easy to operate.

Currently Audulus relies on the knob and slider modules to get midi data in. That's fine -- the idea here is to get the CC data into Audulus by any means necessary, then convert it to serve your purposes. For example, it doesn't matter if a midi button on your controller is assigned to an Audulus knob -- you just need the data.
