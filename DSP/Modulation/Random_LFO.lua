-- Random LFO's (control rate version)
-- Jerry Smith :: 2023

-- Inputs: mode hz amp reset 
-- Outputs: output



-- Four types of interpolation:
-- Random sample and hold
-- Linear interpolation
-- Sine interpolation
-- Exponential interpolation


local rdmValue = 0
local nextRdmValue = 0
local tInterp = 0
local prevPhase = 0



local function updateInterp(phase)
    if phase < prevPhase then
        rdmValue = nextRdmValue
        nextRdmValue = math.random() * 2 - 1
        tInterp = 0
    else
        tInterp = tInterp + math.abs(phase - prevPhase)
        if tInterp > 1 then tInterp = 1 end
    end
    prevPhase = phase
end



-- Sample and Hold
local function randomSH(phase)
    updateInterp(phase)
    return rdmValue
end

-- Linear Interpolation
local function randomLerp(phase)
    updateInterp(phase)
    return rdmValue + (nextRdmValue - rdmValue) * tInterp
end

-- Sine Interpolation
local function randomSineInterp(phase)
    updateInterp(phase)
    local tSine = (1 - math.cos(tInterp * math.pi)) / 2
    return rdmValue + (nextRdmValue - rdmValue) * tSine
end

-- Exponential Interpolation
local function randomExpInterp(phase)
    updateRandomAndInterpolation(phase)
    local tExp = tInterp ^ 2
    return rdmValue + (nextRdmValue - rdmValue) * tExp
end

-- Phasor ramp timebase, 0 to 1
function createTimeBase()
    local time, prev_reset = 0, 0
    return function(frames, rate, reset)
        if reset > 0 and prev_reset <= 0 then time = 0 end
        prev_reset = reset
        time = (time + rate * (frames / sampleRate)) % 1
        return time
    end
end



local interpTypes = {
    randomSH,
    randomLerp,
    randomSineInterp,
    randomExpInterp
}



local timeBase = createTimeBase()

function process(frames)
    local interpIndex = math.floor(interp[1] * (#interpTypes - 0.01)) + 1
    local rate = hz[1]^2 * 10 + .1
    local phasor = timeBase(frames, rate, reset[1])
    local LFO = interpTypes[interpIndex](phasor)
    LFO = (LFO * amp[1])
    fill(output, LFO)
end
