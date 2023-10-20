-- Trigger from gate

-- Input: gate
-- Output: trigger


local prev_gate = 0
sent = false

function process(frames)
	 	
  	if gate[1] > .5 and prev_gate == 0 then
    	fill(trigger, 1)
    	sent = true
  	elseif sent then
    	fill(trigger, 0)
    	sent = false
  	end
  	
  	prev_gate = gate[1]	
end
