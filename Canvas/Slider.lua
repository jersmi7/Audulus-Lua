-- Slider takeover
-- Jerry Smith  :: 2023
-- Update for Audulus 4.3 gradient background 
-- Uses the same graphic style as the slider module, adds bipolar and drawbar styles and gradient color fill

-- Inputs: k m
-- Connect slider directly to k. To m port connect clamped slider * modulation.
-- For drawbar type, inverted slider (1-k) before input to Canvas


-- types: 1 = unipolar (standard), 2 = bipolar, 3 = drawbar
type = 1



-- Color is set up for linear gradient
color1 = theme.azureHighlight -- Dark
color2 = theme.azureHighlight




-- Draw graphics
save()
translate{10,4}
-- slider circle
	if type == 1 or type == 2 then
		fill_circle( {0, k*110},  9, color_paint{.12, .12, .13, 1})
	end
		
	if type == 3 then -- drawbar
		fill_circle( {0, (1-k)*110},  9, color_paint{.12, .12, .13, 1})
	end

-- background and slider groove
fill_rect( {-1.5, -0.5}, {1.5, 110.5}, 0, color_paint{.12, .12, .13, 1})
fill_rect( {-1, 0}, {1, 110}, 0, color_paint(theme.grooves))
		
if type == 1 then -- unipolar
	slider_color = linear_gradient({0,0}, {0,110}, color1, color2)
	stroke_segment( {0, 0}, {0, (m)*110}, 2, slider_color)
end
		
if type == 2 then -- bipolar
	if k >= .5 then
		slider_color = linear_gradient({0,55}, {0,110}, color1, color2)
		stroke_segment( {0, 55}, {0, (m)*110}, 2, slider_color)
	elseif k < .5 then
		slider_color = linear_gradient({0,0}, {0,55}, color2, color1)
		stroke_segment( {0, 55}, {0, (m)*110}, 2, slider_color)
	end
end
		
	if type == 3 then -- drawbar
	slider_color = linear_gradient({0,0}, {0,110}, color2, color1)
		stroke_segment( {0, 110}, {0, (1-(m))*110}, 2, slider_color)
	end
				
	-- slider circle
	if type == 1 or type == 2 then
		fill_circle( {0, (m) * 110},  9, color_paint {.84, .84, .84, .18})
	end
		
	if type == 3 then -- drawbar
		fill_circle( {0, (1-(m))*110},  9, color_paint {.84, .84, .84, .18})
	end
restore()


