
-- Basic Lua concepts: tables, interators and functions


-- Inputs: in0 in1 in2 in3

-- Let's make a function for a vertical slider graphic. 
-- 'k' is our slider level, 'x' and 'y' are the position of the slider, 'label' is the number in the middle of the circle.
-- At the end we will repeat (iterate) our slider function four times, once for each of our inputs.

function verticalSliderGraphic(k, x, y, label)
	
	-- Slider position controls four things -- line segment end point, center of filled circle, center of outlined circle and text. Let's assign a variable for it, scaled to the height of the canvas. 
	slider_position = k * canvas_height
	
	
	save()
		-- Translate sets the position of the center of the circle and the top point of the line
		-- x and y are set when the funvtion is called
		translate{x, y}
		-- draw the vertical line
		-- stacking order -- what comes first is drawn in back
		stroke_segment({0,0}, {0, slider_position}, 2, color_paint(theme.text))
		
		-- draw the circle with the Audulus theme color for red background
		fill_circle({0, slider_position}, 20, color_paint(theme.redHighlightBackground))
		
		-- draw the white outline of the circle
		stroke_circle({0, slider_position}, 20,2, color_paint(theme.text))

		save()
			-- these next few lines are how we center text
			-- no matter what we have for label text, it will always be centered		
			translate{0, slider_position}
			-- the text bounding box
			min, max = text_bounds(label)
			-- find the center of the text bounding box
			translate{-(min[1]+max[1])/2, -(min[2]+max[2])/2}
			-- draw the text with the Audulus theme color for text
			text(label, theme.text)
		restore()
	
	restore()
end

-- make a table of all the inputs
-- in our case we have a different LFO connected to each canvas input
inputs = {in0, in1, in2, in3}


-- here we will use the iterator to make one copy for each input
for i = 1, #inputs do
	
	-- call the function that draws one slider, and iterate the inputs
	
	-- each input is scaled between 0.1 and 0.9 (and scaled to canvas height in the drawing function)
	k = inputs[i] * 0.8 + 0.1
	
	-- space the sliders horizontally
	x = i / #inputs*canvas_width * 0.8 + canvas_width * 0.1
	
	-- this just shifts the bottom of the slider up 10 px
	y = 10
	
	-- uses the iterator index for the number label
	label = i
	
	-- call our function - draw the result!
	verticalSliderGraphic(k, x, y, label)

end


