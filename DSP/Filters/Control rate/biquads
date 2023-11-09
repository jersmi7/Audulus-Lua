
-- Biquad Filters from the RBJ Cookbook :: Jerry Smith, 2023

-- Inputs: fc q gain mode
-- Outputs: a1 a2 a3 b1 b2


-- This code outputs the filter coefficients to use with the Audulus biquad node. 
-- All controls are at control rate. This is the most CPU efficient way thus far to implement biquad filters. 
-- The caveat is that sliders are updatng at block rate (not audio rate), which could mean some zippering, 
-- for ex., with fast modulation. In practice it works very well for most scenarios.


SR = sampleRate

local fMin,fMax = math.log(20), math.log(20000)

local A1,A2,A3,B1,B2 = 0,0,0,0,0
local x1,x2,y1,y2 = 0,0,0,0

-- Math functions, for readability
local pi = math.pi
local sin = math.sin
local cos = math.cos
local log = math.log
local exp = math.exp
local sqrt = math.sqrt

function sinh(x)
  return (math.exp(x) - math.exp(-x)) / 2
end

function tanh(x)
  return (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x))
end

-- Biquad filter coefficients for a lowpass filter
function LPF(f0, q)
  local f0 = exp(f0*(fMax-fMin)+fMin)
  local q = q*10+.05
  
  local w0 = 2 * pi * f0 / SR
  local alpha = sin(w0) / (2 * q)
  
  local b0 = (1 - cos(w0))/2
  local b1 = 1 - cos(w0)
  local b2 = (1 - cos(w0))/2
  local a0 = 1 + alpha
  local a1 = -2*cos(w0)
  local a2 = 1 - alpha

  A1,A2,A3,B1,B2 = b0/a0,b1/a0,b2/a0,a1/a0,a2/a0
end

-- Biquad filter coefficients for a highpass filter
function HPF(f0, q)
  local f0 = exp(f0*(fMax-fMin)+fMin)
  local q = q*10+.05
  
  local w0 = 2 * pi * f0 / SR
  local alpha = sin(w0) / (2 * q)
  
  local b0 = (1 + cos(w0))/2
  local b1 = -(1 + cos(w0))
  local b2 = (1 + cos(w0))/2
  local a0 = 1 + alpha
  local a1 = -2*cos(w0)
  local a2 = 1 - alpha

  A1,A2,A3,B1,B2 = b0/a0,b1/a0,b2/a0,a1/a0,a2/a0
end

-- Biquad filter coefficients for a bandpass filter
function BPF(f0, bw)
  local f0 = exp(f0*(fMax-fMin)+fMin)
  local bw = bw*10+.05
  local w0 = 2 * pi * f0 / SR
  local alpha = sin(w0) * sinh( log(2)/2 * bw * w0/sin(w0) )

  local b0 = alpha
  local b1 = 0
  local b2 = -alpha
  local a0 = 1 + alpha
  local a1 = -2 * cos(w0)
  local a2 = 1 - alpha

  A1,A2,A3,B1,B2 = b0/a0,b1/a0,b2/a0,a1/a0,a2/a0
end

-- Biquad filter coefficients for a notch filter
function NF(f0, bw)
  local f0 = exp(f0*(fMax-fMin)+fMin)
  local bw = bw*10+.05
  local w0 = 2 * pi * f0 / SR
  local alpha = sin(w0) * sinh( log(2)/2 * bw * w0/sin(w0) )

  local b0 = 1
  local b1 = -2 * cos(w0)
  local b2 = 1
  local a0 = 1 + alpha
  local a1 = -2 * cos(w0)
  local a2 = 1 - alpha

  A1,A2,A3,B1,B2 = b0/a0,b1/a0,b2/a0,a1/a0,a2/a0
end

-- Biquad filter coefficients for a peak filter
function PKF(f0, q, gain)
  local f0 = exp(f0*(fMax-fMin)+fMin)
  local q = q*10+.05
  local gain = gain*40-20
  local A = 10^(gain/40)
  
  local w0 = 2 * pi * f0 / SR
  local alpha = sin(w0) / (2 * q)
  
  local b0 = 1 + alpha*A
  local b1 = -2*cos(w0)
  local b2 = 1 - alpha*A
  local a0 = 1 + alpha/A
  local a1 = -2*cos(w0)
  local a2 = 1 - alpha/A

  A1,A2,A3,B1,B2 = b0/a0,b1/a0,b2/a0,a1/a0,a2/a0
end

-- Biquad filter coefficients for a low shelf filter
function LSF(f0, slope, gain)
  local f0 = exp(f0*(fMax-fMin)+fMin)
  local S = slope*.998+.001
  local gain = gain*40-30
  local A = 10^(gain/40)
  
  local w0 = 2 * pi * f0 / SR
  local alpha = sin(w0) / 2 * sqrt( (A + 1/A)*(1/S - 1) + 2 )
  
  local b0 = A*( (A+1) - (A-1)*cos(w0) + 2*sqrt(A)*alpha )
  local b1 = 2*A*( (A-1) - (A+1)*cos(w0) )
  local b2 = A*( (A+1) - (A-1)*cos(w0) - 2*sqrt(A)*alpha )
  local a0 = (A+1) + (A-1)*cos(w0) + 2*sqrt(A)*alpha
  local a1 = -2*( (A-1) + (A+1)*cos(w0) )
  local a2 = (A+1) + (A-1)*cos(w0) - 2*sqrt(A)*alpha

  A1,A2,A3,B1,B2 = b0/a0,b1/a0,b2/a0,a1/a0,a2/a0
end

-- Biquad filter coefficients for a high shelf filter
function HSF(f0, slope, gain)
  local f0 = exp(f0*(fMax-fMin)+fMin)
  local S = slope*.998+.001
  local gain = gain*40-30
  local A = 10^(gain/40)
  
  local w0 = 2 * pi * f0 / SR
  local alpha = sin(w0) / 2 * sqrt( (A + 1/A)*(1/S - 1) + 2 )
  
  local b0 = A*( (A+1) + (A-1)*cos(w0) + 2*sqrt(A)*alpha )
  local b1 = -2*A*( (A-1) + (A+1)*cos(w0) )
  local b2 = A*( (A+1) + (A-1)*cos(w0) - 2*sqrt(A)*alpha )
  local a0 = (A+1) - (A-1)*cos(w0) + 2*sqrt(A)*alpha
  local a1 = 2*( (A-1) - (A+1)*cos(w0) )
  local a2 = (A+1) - (A-1)*cos(w0) - 2*sqrt(A)*alpha

  A1,A2,A3,B1,B2 = b0/a0,b1/a0,b2/a0,a1/a0,a2/a0
end

-- Biquad filter coefficients for an allpass filter
function APF(f0, bw)
  local f0 = exp(f0*(fMax-fMin)+fMin)
  local bw = bw*10+.05
  local w0 = 2 * pi * f0 / SR
  local alpha = sin(w0) * sinh( log(2)/2 * bw * w0/sin(w0) )

  local b0 = 1 - alpha
  local b1 = -2 * cos(w0)
  local b2 = 1 + alpha
  local a0 = 1 + alpha
  local a1 = -2 * cos(w0)
  local a2 = 1 - alpha

  A1,A2,A3,B1,B2 = b0/a0,b1/a0,b2/a0,a1/a0,a2/a0
end


--[[ Not using this -- just outputting coefficients
function clip(input, clipMode)
-- Clipping options for the feedback signal.

  if     clipMode == 0 then return input -- no clipping
  elseif clipMode == 1 then return math.max(math.min(input, 1), -1)
  elseif clipMode == 2 then return tanh(input/10)*9.99
  elseif clipMode == 3 then return math.sin(input)
  end
end

-- Initialize state variables
local x1, x2, y1, y2 = 0, 0, 0, 0
y1Clipped = 0

clipMode = 0
-- Biquad filter formula
function Filter(samples)
-- Biquad filter formula (with feedback clipping)
--local outSamples = A1 * samples + A2 * x1 + A3 * x2 - B1 * y1Clipped - B2 * y2
  local outSamples = A1 * samples + A2 * x1 + A3 * x2 - B1 * y1 - B2 * y2

-- Update state variables
x2, x1, y2, y1 = x1, samples, y1, outSamples

--y1Clipped = clip(y1, clipMode)

return outSamples
end
--]]


local filters = {
  LPF,
  HPF,
  BPF,
  NF,
  PKF,
  LSF,
  HSF,
  APF
}

function process(frames)
  local fmode = math.floor((1-mode[1])*7.99) + 1
  local Filter = filters[fmode]
  
  if Filter then
    Filter(fc[1], q[1], gain[1])
    fill(a1, A1)
    fill(a2, A2)
    fill(a3, A3)
    fill(b1, B1)
    fill(b2, B2)
  end
end
