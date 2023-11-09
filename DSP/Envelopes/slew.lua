-- Basic slew
-- Jerry Smith :: 2023

-- Inputs: input slew_amount
-- Output: output


local prev_input = 0
local prev_slew = 0

function slew(input, slewAmount)
    -- This slew requires two nested passes
    local slew1 = (1 - slewAmount) * prev_input + slewAmount * input
    local slew2 = (1 - slewAmount) * slew1 + slewAmount * prev_slew
    
    prev_slew = slew2
    prev_input = input

    return slew2
end


function process()

	-- Remove this to use the slew_amount input
	slew_amount0 = 0.9
    local slewedSignal = slew(math.abs(input[1]), slew_amount0) -- replace slew_amount0
    fill(output, slewedSignal)
end

