-- First order ADAA
-- Jerry Smith :: 2023
-- from https://ccrma.stanford.edu/~jatin/Notebooks/adaa.html

local TOL = 1e-5
local x1 = 0.0

-- Hard clipper
function hardClip(x)
    if math.abs(x) < 1 then
        return x
    else
        return x > 0 and 1 or -1
    end
end

-- Antiderivative of the hard clipper
function hardClipAD1(x)
    if math.abs(x) < 1 then
        return (x * x) / 2.0
    else
        return x * (x > 0 and 1 or -1) - 0.5
    end
end


function process(frames)
    for i = 1, frames do
        local xn = input[i]
        if math.abs(xn - x1) < TOL then
            -- Fallback for small differences
            output[i] = hardClip((xn + x1) / 2)
        else
            -- ADAA
            output[i] = (hardClipAD1(xn) - hardClipAD1(x1)) / (xn - x1)
        end
        x1 = xn
    end
end


