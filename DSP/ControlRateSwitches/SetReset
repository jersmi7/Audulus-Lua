-- Set/reset switch

-- Inputs: set reset
-- Outputs: state


local readState = false
local changed = false

function process(frames)
  	
  	if not readState then
    
    	fill(state, storage[1])
    	readState = true
  	end
  
  	if set[1] > .5 then
  	
    	fill(state, 1)
    	changed = true
  	
  	elseif reset[1] > .5 then
    	
    	fill(state, 0)
    	changed = true
  	end
  	
  	if changed then
    
    	storage[1] = state[1]
    	changed = false
  	end
end
