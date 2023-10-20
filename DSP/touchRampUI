-- Ramping value UI for touch pad node with state saving :: jersmi 2023
-- This version clamps the range

-- Inputs: y touch   (from touch pad node with size set to 30x30)
-- Output: value



-- default parameters
local rangeStart = 1
local rangeEnd = 100
local rampRate = 4 -- 1 is fastest
local pauseBeforeRamping = 25


-- states
local counter = 1
local touchDuration = 0
local rampCounter = 0
local touched = true
local direction = 1


loadState = false
saveState = false

function process(frames)
	
	-- Load the last state from storage (memory)
	-- Equivalent to "save data" in sample and hold 
	if not loadState then
		counter = storage[1]
		loadState = true
	end

	if touch[1] > 0 then
		direction = y[1] >= 0.5 and 1 or -1
		if touched then
			touched = false
			touchDuration = 0
			rampCounter = 0
			counter = counter + direction
		else
			touchDuration = touchDuration + 1
                
			-- Start ramping after touchDuration reaches 40
			if touchDuration > pauseBeforeRamping then
				rampCounter = rampCounter + 1
				-- ramp rate
				if rampCounter == rampRate then
					counter = counter + direction
					rampCounter = 0
				end
			end
		end    
    
    	-- Clamped
		counter = math.max(rangeStart, math.min(rangeEnd, counter))
	
		saveState = true
	
	else
		touchDuration = 0
		touched = true
		rampCounter = 0
	end
		
	-- Save state to storage
	if saveState then
		storage[1] = math.floor(counter + 0.5)
		saveState = false
	end
	
	-- "Control rate" output using fill()
	fill(value, math.floor(counter + 0.5))

end
