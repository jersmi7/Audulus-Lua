-- Knob takeover

-- Inputs: A B
-- Output: output

-- Use two knobs, A and B. A is a knob on your module. Assign midi CC to B.

-- Types:
-- Immediate: moving either A or B will jump to current signal.
-- Pickup: knob takes over when it passes the current output value.
-- Value scaling: current value ramps towards the knob value as the knob turns until the values match.


local type = "value_scaling" -- "immediate", "pickup" or "value_scaling"


local prev_A = 0
local prev_B = 0
local scale_factor = 0.1
local currentValue = 0
local controlA = true
local readState = true
local saveState = false

function process(frames)
    if readState then
        currentValue = storage[1] or A[1]
        readState = false
    end

	if type == "immediate" then
		if A[1] ~= prev_A then
    		controlA = true   	
    		saveState = true
    	elseif B[1] ~= prev_B then
    		controlA = false
    		saveState = true
  		end
  	
  		currentValue = controlA and A[1] or B[1]
	
	elseif type == "pickup" then
		if (prev_A < currentValue and A[1] >= currentValue) 
    	or (prev_A > currentValue and A[1] <= currentValue) then
        	controlA = true
        	saveState = true
    	elseif (prev_B < currentValue and B[1] >= currentValue) 
    	or (prev_B > currentValue and B[1] <= currentValue) then
        	controlA = false
        	saveState = true
    	end

    	currentValue = controlA and A[1] or B[1]
			
	elseif type == "value_scaling" then	
    	local targetValue = controlA and A[1] or B[1]
    	local knobMoved = false

	   	if A[1] ~= prev_A then
    	    controlA = true
        	knobMoved = true
    	elseif B[1] ~= prev_B then
        	controlA = false
        	knobMoved = true
    	end

    	-- Apply scaling while the knob is moving
    	if knobMoved then
        	local delta = (targetValue - currentValue) * scale_factor
        	currentValue = currentValue + delta
        	saveState = true
    	end   
   	end


    fill(output, currentValue)

	if saveState then
		storage[1] = currentValue
		saveState = false
	end

    prev_A = A[1]
    prev_B = B[1]
end
