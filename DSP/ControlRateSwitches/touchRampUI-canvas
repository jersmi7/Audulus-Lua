-- TouchRampUI

-- This is the Lua for the canvas node graphics to accompany the DSP node



-- Number selector with up and down arrows

-- Inputs: y touch count


colorScheme = "azure"
title = ""
number_size = 1.5

-- rectangle background
corner_radius = 5
stroke = .5
gap = 0

-- up/down arrows
yoffset = 13
triangle_width = 5
triangle_height = 4


-- colors -----------------------
if colorScheme == "azure" then
activeText_color = theme.azureHighlightBackground
text_color = theme.azureHighlight
activeBkgd_color = theme.azureHighlight
bkgd_color = theme.azureHighlightBackground
stroke_color = theme.azureHighlightDark
highlightOn = theme.azureHighlight
highlightOff = {0, .831, 1, .25}
gradientTop = {0, .831, 1, .15}
gradientBottom = {0,0,0,0} --theme.azureHighlightBackground

elseif colorScheme == "green" then
activeText_color = theme.greenHighlightBackground
text_color = theme.greenHighlight
activeBkgd_color = theme.greenHighlight
bkgd_color = theme.greenHighlightBackground
stroke_color = theme.greenHighlightDark
highlightOn = theme.greenHighlight
highlightOff = {.231, .769, .333, .25}
gradientTop = {.231, .769, .333, .25}
gradientBottom = theme.greenHighlightBackground


elseif colorScheme == "red" then
activeText_color = theme.redHighlightBackground
text_color = theme.redHighlight
activeBkgd_color = theme.redHighlight
bkgd_color = theme.redHighlightBackground
stroke_color = theme.redHighlightDark
highlightOn = theme.redHighlight
highlightOff = {1, 0, .38, .25}
gradientTop = {1, 0, .38, .25}
gradientBottom = theme.redHighlightBackground

end
-----------------------------


function background(ax, ay, bx, by)

	-- corner_radius = 7
	-- stroke = 1
	-- gap = 0
	
	save()
	fill_rect({ax + gap, ay + gap}, {bx - gap, by - gap}, corner_radius, color_paint(bkgd_color))
	stroke_rect({ax + gap, ay + gap}, {bx - gap, by - gap}, corner_radius, stroke, color_paint(stroke_color))
	
	 
	cx = (ax + bx)/2
	cy = (ay + by)/2
	radius = 15
	circleGradient = linear_gradient( {ax, cy-radius}, {ax, cy+radius}, gradientBottom, gradientTop)
	--fill_circle({cx, cy}, radius, circleGradient)
	
	restore()
end

function arrow(x,y, color, direction)
	-- set direction to 1 for up, 0 for down
	
	--yoffset = 21
	--triangle_width = 7
	--triangle_height = 7
	
    if direction > 0 then 
    move_to{x, 					y + yoffset}
    line_to{x + triangle_width, y + yoffset - triangle_height}
    line_to{x - triangle_width, y + yoffset - triangle_height}
    line_to{x, 					y + yoffset}
    else
    move_to{x, 					y - yoffset}
    line_to{x + triangle_width, y - yoffset + triangle_height}
    line_to{x - triangle_width, y - yoffset + triangle_height}
    line_to{x, 					y - yoffset}
    end
    
    fill(color_paint(color))
end


width = canvas_width
height = canvas_height

-- highlight color for up and down arrows
if touch > 0 then
	if y > .5 then
		upHighlight = highlightOn	
	else
		downHighlight = highlightOn
	end
else
	upHighlight = highlightOff
	downHighlight = highlightOff
end

background(0, 0, width, height)	
arrow( width/2, height/2, upHighlight, 1) -- up
arrow( width/2, height/2, downHighlight, 0) -- down



-- text ---------
save()		
	translate{canvas_width/2, canvas_height/2}
	scale{number_size, number_size}
	min, max = text_bounds(count)
	translate{-(min[1]+max[1])/2-.3, -(min[2]+max[2])/2+.2}
	text(count, text_color)
restore()
				
save()
translate{width/2, height}
--scale{2, 2}
min, max = text_bounds(title)
translate{-(min[1]+max[1])/2, 5}
text(title, theme.text)
restore()
