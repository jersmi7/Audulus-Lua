-- Sine wave oscillator with 1/oct tuning and amp and phase modulation
-- Inputs: oct am pm

twoPi = 2 * math.pi
phase = 0

function process(frames)
    for i = 1, frames do
        phaseIncrement = (2^oct[i] * 440) / sampleRate * twoPi
        phase = phase + phaseIncrement 
        
        -- pm would ordinarily be a bipolar oscillator signal (for ex., another sine wave)
        -- am here assumes a signal between 0 and 1, allows mod source amplitude to act as "mod depth"
        audioOut[i] = math.sin(phase + pm[i]) * (1-am[i])
    end
    if phase > twoPi then phase = phase - twoPi end
end
