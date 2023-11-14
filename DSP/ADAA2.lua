-- Second order Antiderivative Antialiasing
-- Jerry Smith :: 2023
-- from https://ccrma.stanford.edu/~jatin/Notebooks/adaa.html


local TOL = 1e-5
local x1 = 0.0
local x2 = 0.0

-- Sign function
local function signum(x)
    return x > 0 and 1 or (x < 0 and -1 or 0)
end

-- Hard clipper
function hardClip(x)
    if math.abs(x) < 1 then
        return x
    else
        return x > 0 and 1 or -1
    end
end

-- First order antiderivative
function hardClipAD1(x)
    if math.abs(x) < 1 then
        return (x * x) / 2.0
    else
        return x * (x > 0 and 1 or -1) - 0.5
    end
end

-- Second order antiderivative
local function hardClipAD2(x)
    if math.abs(x) < 1 then
        return (x * x * x) / 6.0
    else
        return (((x * x) / 2.0) + (1.0 / 6.0)) * signum(x) - (x / 2)
    end
end

-- Difference quotient D
local function calcD(x0, x1)
    if math.abs(x0 - x1) < TOL then
        return hardClipAD1((x0 + x1) / 2.0)
    end
    return (hardClipAD2(x0) - hardClipAD2(x1)) / (x0 - x1)
end

-- Fallback
local function fallback(x0, x2)
    local x_bar = (x0 + x2) / 2.0
    local delta = x_bar - x0

    if delta < TOL then
        return hardClip((x_bar + x0) / 2.0)
    end
    return (2.0 / delta) * (hardClipAD1(x_bar) + (hardClipAD2(x0) - hardClipAD2(x_bar)) / delta)
end



function process(frames)
    for i = 1, frames do
        local xn = input[i]
        local y
        if math.abs(xn - x1) < TOL then
            y = fallback(xn, x2)
        else
            y = (2.0 / (xn - x2)) * (calcD(xn, x1) - calcD(x1, x2))
        end

        -- Check for NaN or Inf and set output to 0 if true
        if y ~= y or math.abs(y) == math.huge then
            output[i] = 0
        else
            output[i] = y
        end

        x2 = x1
        x1 = xn
    end
end
