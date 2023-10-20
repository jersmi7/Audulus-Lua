
![Audulus-logo-128](https://github.com/jersmi7/Audulus-Lua/assets/90596774/1eb20250-2449-4ffe-a910-54dc79fc5c4e)


 
# Lua Scripts for Audulus

A small collection of Lua scripts for Audulus.

Audulus has two Lua-based nodes, the DSP node and the Canvas node. 
DSP node processes audio and control rate signals.
Canvas node draws vector graphics using the Audulus graphics library, vger.

## DSP node

For processing audio, synthesis, filters, anything requiring sample rate processing,
we process each audio frame (where a frame is the length of one sample) using the frames loop:
```lua
function process(frames)
  for i = 1, frames do
      -- assuming you made a function called processAudio()
    output[i] = processAudio()
  end
end
```

`process(frames)` processes each block, `for i = 1, frames do end` processes each frame.

A block is like an audio buffer, the difference being that, depending on how you are using Audulus, as a standalone app or as an AUv3 plugin, block size can dynamically change depending on your audio host. (Not a big deal for almost everything, just happens in the background.)

For control rate signal - and a significant CPU savings compared to processing at audio frame rate - we can process at block rate using `fill()` instead of the frames loop. This approach fills each block with a constant:
```lua
function process(frames)
  -- assuming you made a function called controlSignal()
    fill(output, controlSignal())
end
```


## Canvas node

The canvas node list of functions and global constants:
```lua
paint = color_paint(r, g, b, a)
paint = linear_gradient({start_x, start_y}, {end_x, end_y}, r, g, b, a, r, g, b, a)
fill_circle({x, y}, radius, paint)
stroke_circle({x, y} radius, width, paint)
stroke_arc({x, y}, radius, width, rotation, aperture, paint)
stroke_segment({ax, ay}, {bx, by}, width, paint)
fill_rect({min_x, min_y}, {max_x, max_y}, corner_radius, paint)
stroke_rect({min_x, min_y}, {max_x, max_y}, corner_radius, paint)
stroke_bezier({ax, ay}, {bx, by}, {cx, cy}, width, paint)
text("hello world!", r,g,b,a)
min, max = text_bounds("hello world!")
text_box("lorem ipsum...", break_row_width, r,g,b,a)
min, max = text_box_bounds("lorem ipsum...", break_row_width)
move_to{x, y}
line_to{x, y}
quad_to{bx, by, cx, cy}
fill(paint)
translate{tx, ty}
scale{sx, sy}
rotate(theta)
save()
restore()
canvas_width
canvas_height
```

Audulus has a design color scheme represented by r,g,b,a "theme" colors. For example:

```lua
azure = theme.azureHighlight
green = theme.greenHighlight
red = theme.redHighlight
white = theme.text
black = theme.grooves
```
