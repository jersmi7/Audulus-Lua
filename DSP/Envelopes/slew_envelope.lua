-- Basic slew with envelope controls
-- Jerry Smith :: 2023

-- Inputs: input attack release
-- Output: output


local prev_input = 0

function envelope(input, frames, sampleRate, attackTime, releaseTime)
    
    -- Calculate attack and release times
	local function envRate(time, frames, sampleRate)
    	return 1 - math.exp(-1 / (time * sampleRate / frames))
	end

    local attackRate = envRate(attackTime, frames, sampleRate)
    local releaseRate = envRate(releaseTime, frames, sampleRate)
    local rate = input > prev_input and attackRate or releaseRate
    
    local envOut = (1 - rate) * prev_input + rate * input
    
    prev_input = envOut

    return envOut
end


function process(frames)
    
    local attackTime = 0.02   -- Attack time in seconds
    local releaseTime = 0.1  -- Release time in seconds

    local envSignal = envelope(input[1], frames, sampleRate, attackTime, releaseTime)

    fill(output, envSignal)
end
