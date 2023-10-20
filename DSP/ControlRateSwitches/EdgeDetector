-- Create a rising and falling trigger from a gate

-- Inputs: gate
-- Outputs: rising falling


local prev_gate = 0
sent = false

function process(frames)
	 	
  	if gate[1] > .5 and prev_gate == 0 then
    	fill(rising, 1)
    	sent = true
  	elseif sent then
    	fill(rising, 0)
    	sent = false
  	end
  	
  	if gate[1] < .5 and prev_gate == 1 then
    	fill(falling, 1)
    	sent = true
  	elseif sent then
    	fill(falling, 0)
    	sent = false
  	end
  	
  	prev_gate = gate[1]	
end
