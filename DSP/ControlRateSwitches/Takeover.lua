-- Takeover, with memory

-- Inputs: A B
-- Output: current


local prev_A = 0
local prev_B = 0

local readState = false
local changed = false

function process(frames)
  	
  	if not readState then
    
    	fill(current, storage[1])
    	readState = true
  	end
	 		 	
  	if A[1] ~= prev_A then
    	
    	fill(current, A[1])
    	changed = true
    	
    elseif B[1] ~= prev_B then
    	
    	fill(current, B[1])
    	changed = true
  	end
  	
  	
  	if changed then
    
    	storage[1] = current[1]
    	changed = false
  	end
  	
  	
  	prev_A = A[1]
  	prev_B = B[1]
end

