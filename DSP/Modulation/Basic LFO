-- Basic LFO (control rate version)
-- Jerry Smith :: 2023

-- Inputs: waveform hz amp phaseOfst reset offset invert 
-- Outputs: output


-- LFO using a 0 to 1 phasor ramp.
-- The code is in three parts, a modular approach to make modifications easier
-- Part 1: waveforms (one function per waveform, add the function to the "waveforms" table)
-- Part 2: timebase (modifications might include stepped time, 2x/4x)
-- Part 3: processing (this is where amplitude, offset, invert, etc. are added - add a unipolar/bipolar switch)


-- waveforms ------------------
local function sine(phase)
    return math.sin(phase * 2 * math.pi)
end

local function square(phase)
    return phase < 0.5 and 1 or -1
end

local function triangle(phase)
    return math.abs(2 * phase - 1) * 2 - 1
end

local function sawtooth(phase)
    return 2 * phase - 1
end

local rdmValue = 0
local prevPhase = 0
local function randomSH(phase)
    -- Check for phase wrapping from 1 to 0 or crossing 0.5
    if (phase < prevPhase) or (prevPhase < 0.5 and phase >= 0.5) then
        rdmValue = math.random() * 2 - 1
    end
    prevPhase = phase
    return rdmValue
end


------------------------------
-- Phasor ramp timebase, 0 to 1

function createTimeBase()
    local time = 0
    local prev_reset = 0

    return function(frames, rate, reset, phaseOffset)
        if reset > 0 and prev_reset <= 0 then
            time = 0
        end
        prev_reset = reset
		
		-- to convert to audio rate, change frames to 1
        time = (time + rate * (frames / sampleRate)) % 1

        return (time + phaseOffset) % 1
    end
end


-----------------------------

local waveforms = {
    sine,
    square,
    triangle,
    sawtooth,
    randomSH
}


local timeBase = createTimeBase()

function process(frames)
    local waveIndex = math.floor(waveform[1] * (#waveforms - 0.01)) + 1
    local rate = hz[1]^2 * 10 + .1
    local phasor = timeBase(frames, rate, reset[1], phaseOfst[1])
    local LFO = waveforms[waveIndex](phasor)
    if invert[1] == 1 then LFO = LFO * -1 end
    local LFO = (LFO * amp[1]) + (offset[1] * 2 - 1)
    fill(output, LFO)
end

