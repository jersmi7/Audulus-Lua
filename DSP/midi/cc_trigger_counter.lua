-- Trigger and counter

-- Use a midi button to cycle through indexes
-- Good for using one midi button to select from a menu of items

-- Input: k
-- Output: output index

-- Options: "rising", "falling", "both"
local triggerMode = "rising"
local threshold = 0.5
local prev_k = 0
local triggerState = 0
local counter = 0
local counterMax = 4

function process(frames)
    triggerState = 0

    -- Check conditions based on the trigger mode
    if triggerMode == "rising" then
        if k[1] >= threshold and prev_k < threshold then
            triggerState = 1  -- Trigger on rising edge
            -- Increment and loop counter
            -- counter = (counter % counterMax) + 1 -- Lua indexing, 1 to n		
            counter = (counter + 1) % counterMax -- Audulus indexing, 0 to n-1
        end
    elseif triggerMode == "falling" then
        if k[1] < threshold and prev_k >= threshold then
            triggerState = 1  -- Trigger on falling edge
            counter = (counter % counterMax)  -- Increment and loop counter
        end
    elseif triggerMode == "both" then
        if (k[1] >= threshold and prev_k < threshold) or (k[1] < threshold and prev_k >= threshold) then
            triggerState = 1  -- Trigger on both edges
            counter = (counter % counterMax)  -- Increment and loop counter
        end
    end

    -- Update the output with the trigger state
    fill(output, triggerState)

    
    fill(index, counter)

    prev_k = k[1]
end
