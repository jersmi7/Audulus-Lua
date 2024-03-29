-- Sample and hold with state saving

-- Inputs: value trigger
-- Output: output


local prev_trigger = 0
loadState = false
saveState = false

function process(frames)
	if not loadState then
		holdValue = storage[1]
	end
	 	
  	if trigger[1] > .5 and prev_trigger == 0 then
    	holdValue = value[1]
    	saveState = true
  	end
  	
  	if saveState then
  		storage[1] = holdValue
  		saveState = false
  	end
  	
  	fill(output, holdValue)
  	prev_trigger = trigger[1]	
end
