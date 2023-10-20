-- Set/reset and send values, set the value to send with set or reset
-- This like an A/B mux with set and reset

-- Inputs: set reset setValue resetValue
-- Output: value



local readState = false
local changed = false

function process(frames)
  
  	if not readState then
    
    	fill(value, storage[1])
    	readState = true
  	end
  
  	if set[1] >= 1 then
    
    	fill(value, setValue[1])
    	changed = true
  	
  	elseif reset[1] >= 1 then
    	
    	fill(value, resetValue[1])
    	changed = true
  	end
  	
  	if changed then
    	
    	storage[1] = value[1]
    	changed = false
  	end
end
