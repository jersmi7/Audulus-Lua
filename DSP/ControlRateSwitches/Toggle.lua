-- Toggle with state saving

-- Input: toggle
-- Output: state


local prev_toggle = 0
local readState = false
local changed = false

function process(frames)
	if not readState then
		fill(state, storage[1])
    	readState = true
  	end
  	
  	if toggle[1] > .5 and prev_toggle == 0 then
    	fill(state, 1 - state[1])
    	changed = true
  	end
  	
  	prev_toggle = toggle[1]
  
  	if changed then
    	storage[1] = state[1]
    	changed = false
  	end
end
