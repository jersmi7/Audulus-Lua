-- AHDSR envelope visualizer
-- Jerry Smith :: 2023

-- Inputs: a h d s r curve position time vel A_maxTime H_maxTime D_maxTime R_maxTime Aexp Dexp Rexp showVelocity 


local A = a
local H = h
local D = d
local S = s
local R = r

local maxDuration = 5
local curveOn = curve -- 0 for linear, 1 for non-linear
local fixedSustainDuration = 0.5 -- Fixed sustain duration for visualization

local stroke = 1
local line_color = color_paint(theme.azureHighlight)
--local fill_color = color_paint(theme.azureHighlightDark)
local fill_color = linear_gradient({0, 0}, {0, canvas_height}, theme.azureHighlightBackground, theme.azureHighlightDark)

local w, h = canvas_width, canvas_height

if showVelocity == 1 then h = h * vel end

local maxDuration = A_maxTime + H_maxTime + D_maxTime + fixedSustainDuration + R_maxTime
local scalingFactor = w / maxDuration

local attackEndX = A * scalingFactor
local holdEndX = attackEndX + H * scalingFactor
local decayEndX = holdEndX + D * scalingFactor
local sustainEndX = decayEndX + fixedSustainDuration * scalingFactor
local releaseStartX = sustainEndX
local releaseEndX = sustainEndX + R * scalingFactor


fill_rect({0,0}, {w, canvas_height}, 0, color_paint(theme.azureHighlightBackground))



local function drawEnvelope(curveOn, envFill, envStroke)
    
    
	local points = 10
	
	local function drawFill()
    	move_to{0, 0} -- Start at the bottom-left corner

    	-- Draw the attack stage
    	for i = 0, points do
        	local progress = i / points
        	local x = progress * attackEndX
        	local y
        	if curveOn == 1 then
            	y = h * (progress ^ (1 - progress ^ Aexp)) -- Curved attack
        	else
            	y = h * progress -- Linear attack
        	end
        	line_to{x, y}
    	end

    	-- Draw the hold stage
    	line_to{holdEndX, h}

    	-- Draw the decay stage
    	for i = 0, points do
        	local progress = i / points
        	local x = holdEndX + progress * (decayEndX - holdEndX)
        	local y
        	if curveOn == 1 then
            	y = h - (h - h * S) * (1 - (1 - progress) ^ Dexp) -- Curved decay
        	else
            	y = h - progress * (h - h * S) -- Linear decay
        	end
        	line_to{x, y}
    	end

    	-- Draw the sustain stage
    	line_to{sustainEndX, h * S}

    	-- Draw the release stage
    	for i = 0, points do
        	local progress = i / points
        	local x = sustainEndX + progress * (releaseEndX - sustainEndX)
        	local y
        	if curveOn == 1 then
            	y = (h * S) * (1 - progress) ^ Rexp -- Curved release
        	else
            	y = h * S * (1 - progress) -- Linear release
        	end
        	line_to{x, y}
    	end

    	-- Close the shape
    	line_to{0, 0}
	end
	

    local function drawStroke()
    	-- fill_circle adds rounded caps
    	fill_circle({0, 0}, stroke/2.1, line_color)

    	local previousX, previousY = 0, 0 -- Initialize previous point

    	-- Draw the attack stage
    	for i = 0, points do
        	local progress = i / points
        	local x = progress * attackEndX
        	local y
        	if curveOn == 1 then
            	y = h * (progress ^ (1 - progress ^ Aexp)) -- Curved attack
        	else
            	y = h * progress -- Linear attack
        	end
        	stroke_segment({previousX + 0.01, previousY}, {x, y}, stroke, line_color)
        	fill_circle({x, y}, stroke/2.1, line_color)
        	previousX, previousY = x, y -- Update previous point
    	end

    	-- Draw the hold stage
    	stroke_segment({previousX + 0.01, previousY}, {holdEndX, h}, stroke, line_color)
    	previousX, previousY = holdEndX, h -- Update previous point

    	-- Draw the decay stage
    	for i = 0, points do
        	local progress = i / points
        	local x = holdEndX + progress * (decayEndX - holdEndX)
        	local y
        	if curveOn == 1 then
            	y = h - (h - h * S) * (1 - (1 - progress) ^ Dexp) -- Curved decay
        	else
            	y = h - progress * (h - h * S) -- Linear decay
        	end
        	stroke_segment({previousX + 0.01, previousY}, {x, y}, stroke, line_color)
        	fill_circle({x, y}, stroke/2.1, line_color)
        	previousX, previousY = x, y -- Update previous point
    	end

    	-- Draw the sustain stage
    	stroke_segment({previousX + 0.01, previousY}, {sustainEndX, h * S}, stroke, line_color)
    	previousX, previousY = sustainEndX, h * S -- Update previous point

    	-- Draw the release stage
    	for i = 0, points do
        	local progress = i / points
        	local x = sustainEndX + progress * (releaseEndX - sustainEndX)
        	local y
        	if curveOn == 1 then
            	y = (h * S) * (1 - progress) ^ Rexp -- Curved release
        	else
            	y = (h * S) * (1 - progress) -- Linear release
        	end
        	stroke_segment({previousX + 0.01, previousY}, {x, y}, stroke, line_color)
        	fill_circle({x, y}, stroke/2.1, line_color)
        	previousX, previousY = x, y -- Update previous point
    	end
	end
	
	if envFill == 1 then
    	drawFill()
    	fill(fill_color)
    end

    if envStroke == 1 then
    	drawStroke()
    end 
end


drawEnvelope(curve, 1, 1)


-- Draw current position and time ---------------
reachedSustain = math.floor((A + H + D) * 100) / 100

if time >= reachedSustain then 
	time = time + fixedSustainDuration
end

if time >= maxDuration then
	time = maxDuration
end


fill_circle({scalingFactor * time, h * position}, 3, color_paint(theme.text))
--stroke_segment({scalingFactor * time, 0}, {scalingFactor * time, canvas_height}, .5, color_paint{.5,.5,.5,1})
