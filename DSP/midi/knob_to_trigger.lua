-- Convert knob to trigger

-- Input: k
-- Output: output

-- Options: "rising", "falling", "both"
local triggerMode = "both" 
local threshold = 0.5
local prev_k = 0
local triggerState = 0

function process(frames)
   
    triggerState = 0

    -- Check conditions based on the trigger mode
    if triggerMode == "rising" then
        if k[1] >= threshold and prev_k < threshold then
            triggerState = 1  -- Trigger on rising edge
        end
    elseif triggerMode == "falling" then
        if k[1] < threshold and prev_k >= threshold then
            triggerState = 1  -- Trigger on falling edge
        end
    elseif triggerMode == "both" then
        if (k[1] >= threshold and prev_k < threshold) or (k[1] < threshold and prev_k >= threshold) then
            triggerState = 1  -- Trigger on both edges
        end
    end

    fill(output, triggerState)

    prev_k = k[1]
end
