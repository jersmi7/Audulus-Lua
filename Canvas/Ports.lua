
-- Port light LED's for audio, gate, modulation, sync and 1/oct
-- Jerry Smith :: 2023



-- types: 
-- 1 = audio "A"
-- 2 = gate "G"
-- 3 = modulation "M"
-- 4 = sync "S"
-- 5 = 1/oct "O"
type = 4


-- create two inputs for stereo audio, ch1 and ch2
-- set canvas node height to 10 for 1 ch, 40 for 2 ch
channels = 1


show_text = 1 -- show the text in the light


-- helper functions
local function smoothstep(edge0, edge1, x)
	if x <= edge0 then return 0 end
	if x > edge1 then return 1 end
   	x = (x - edge0) / (edge1 - edge0)
	return x * x * (3 - 2 * x)
end

-- HSV to RGB
function hsv(h,s,v)
	local kr = (5+(1-h)*6)%6
	local kg = (3+h*6)%6
	local kb = (1+h*6)%6
	local r = v-v*s*math.max(0,math.min(math.min(kr,4-kr),1))
	local g = v-v*s*math.max(0,math.min(math.min(kg,4-kg),1))
	local b = v-v*s*math.max(0,math.min(math.min(kb,4-kb),1))
    return r,g,b
end


local function portLight(input, x, y)
	label = {"A", "G", "M", "S", "O"}
	
	if type == 1 then -- audio light
		signal = math.abs(input)
	
		if signal >= 0 and signal <= 1 then
			r = smoothstep(.4, 1, signal)
			g = math.sin(signal * math.pi)
			b = math.sin(signal * 4 * math.pi/2)
			a = 1
		elseif signal > 1 then
			r,g,b = 1,0,0
			a = signal
		end
		text_color = theme.text
	
	elseif type == 2 then -- gate light
		-- behavior of Audulus light meter
		if input > 0 then
			r,g,b,a = 0.0, 0.831, 1, 1
			text_color = {0.5, 0.5, 0.5, 1}
		else
			r,g,b,a = 0,0,0,1
			text_color = theme.text
		end
	
	elseif type == 3 then -- modulation light
		if input > 0 and input <= 1 then
			r = input
			g = input*.3
			b = 0
			a = 1
		elseif input > 1 then -- saturate alpha if > 1
			r,g,b,a = 1, 0.1, 0, math.abs(input)
		
		elseif input <= 0 and input >= -1 then
			r = math.abs(input*.2)
			g = math.abs(input*.3)
			b = math.abs(input)
			a = 1
		elseif input < -1 then -- saturate alpha if < -1
			r,g,b,a = .2, .3, 1, math.abs(input)
		end
		text_color = theme.text
			
	elseif type == 4 then -- sync light
		if input > 0 then
			r,g,b,a = 1,0,.384,1
			text_color = {.5,.5,.5,1}
		else
			r,g,b,a = 0,0,0,1
			text_color = theme.text
		end
				
	elseif type == 5 then -- 1/oct light	
		h = (1-((input+5)/10))*.7 -- color shift per octave
		s = 1 -- saturation always 1
		v = ((input+5)-math.floor(input+5))*.9+.1 -- dark to light per octave	
		r,g,b = hsv(h,s,v)
		a = 1
		text_color = theme.text
	end
	
	save()
	translate{x,y}
	fill_circle({0,0}, 5, color_paint{r,g,b,a})
	fill_circle({0,0}, 9, color_paint{r,g,b,a*.25})

	if show_text == 1 then
		min, max = text_bounds(label[type])
		translate{ -(min[1]+max[1])/2, -(min[2]+max[2])/2 }
		text(label[type], text_color)
	end
	restore()
end

if channels == 1 then
portLight(ch1, 5, 5)
else
portLight(ch1, 5, 35)
portLight(ch2, 5, 5)
end
