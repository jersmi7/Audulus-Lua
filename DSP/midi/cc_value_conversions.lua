-- Midi CC conversions: basic processing, nonlinear curves, etc.

-- inputs: input
-- outputs: output
-- The DSP node control rate signal fill() function is ideal for manipulating midi CC messages.


-- Helper functions
function clamp(x, a, b)
	return math.max(a, math.min(b, x))
end

function mix(x, a, b) -- linear interpolation
    x = math.max(0, math.min(1, x))
    return a + (b - a) * x
end

function smoothstep(a, b, x)
    local t = math.max(0, math.min(1, (x - a) / (b - a)))
    return t * t * (3 - 2 * t)
end


function process(frames)
	
	local cc_value = input[1]
	
	-- Types of conversions that come up, choose one
	local indexes = math.floor(cc_value * 7.99) -- send to mux
	local mix_input = mix(cc_value, -1, 1) -- scale values
	local clamp_input = clamp(cc_value, 0.3, 0.8)
	
	-- nonlinear curves
	local exp_curve = cc_value ^ 2 -- exponential curve
	local log_curve = cc_value ^ 0.5 -- logarithmic curve
	local ease_curve = smoothstep(0,1, cc_value)
	
	
	fill(output, mix_input)
    
end
