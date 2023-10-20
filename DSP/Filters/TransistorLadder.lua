
-- Transistor Ladder Filter for Audulus :: 2023, Jerry Smith
-- Copyright 2012 Teemu Voipio

-- Inputs: input fc res
-- Output: output

SR = sampleRate

-- Input delay and state for member variables
local zi = 0
local s = {0, 0, 0, 0}

-- tanh(x)/x approximation, flatline at very high inputs
-- so might not be safe for very large feedback gains
-- [limit is 1/15 so very large means ~15 or +23dB]
local function tanhXdX(x)
    local a = x * x
    -- Probably Pade-approx for tanh(sqrt(x))/sqrt(x) 
    return ((a + 105) * a + 945) / ((15 * a + 420) * a + 945)
end

-- Cutoff as normalized frequency (e.g., 0.5 = Nyquist)
-- Resonance from 0 to 1, self-oscillates at settings over 0.9
local function transistorLadder(input, cutoffHz, resonance)
    -- Tuning and feedback
    local cutoff = math.exp(cutoffHz * (math.log(16000) - math.log(50)) + math.log(50))
    local f = math.tan(math.pi * cutoff / SR)
    local r = (40.0 / 9.0) * resonance

    -- Input with half delay, for non-linearities
    local ih = 0.5 * (input + zi)
    zi = input

    -- Evaluate the non-linear gains
    local t0 = tanhXdX(ih - r * s[4])
    local t1 = tanhXdX(s[1])
    local t2 = tanhXdX(s[2])
    local t3 = tanhXdX(s[3])
    local t4 = tanhXdX(s[4])

    -- g# the denominators for solutions of individual stages
    local g0 = 1 / (1 + f * t1)
    local g1 = 1 / (1 + f * t2)
    local g2 = 1 / (1 + f * t3)
    local g3 = 1 / (1 + f * t4)

    -- f# are factored out of the feedback solution
    local f3 = f * t3 * g3
    local f2 = f * t2 * g2 * f3
    local f1 = f * t1 * g1 * f2
    local f0 = f * t0 * g0 * f1

    -- Solve feedback
    local y3 = (g3*s[4]+f3*g2*s[3]+f2*g1*s[2]+f1*g0*s[1]+f0*input)/(1+r*f0)

    -- Then solve the remaining outputs (with the non-linear gains here)
    local xx = t0 * (input - r * y3)
    local y0 = t1 * g0 * (s[1] + f * xx)
    local y1 = t2 * g1 * (s[2] + f * y0)
    local y2 = t3 * g2 * (s[3] + f * y1)

    -- Update state
    s[1] = s[1] + 2 * f * (xx - y0)
    s[2] = s[2] + 2 * f * (y0 - y1)
    s[3] = s[3] + 2 * f * (y1 - y2)
    s[4] = s[4] + 2 * f * (y2 - t4 * y3)

    return y3
end

function process(frames)
     local cutoffHz = fc[1]
    local resonance = res[1]
    for i = 1, frames do
        output[i] = transistorLadder(input[i], cutoffHz, resonance)
    end
   
end
