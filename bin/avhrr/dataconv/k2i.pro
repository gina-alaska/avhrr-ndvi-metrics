;=== Convert AVHRR Thermal I*2 data to Kelvin ===
FUNCTION k2i, data


; This is the current way of doing things (10 bit)

  scale = 5.602   
  offset = -886.32
  shift = 0.0
  min = 10
  max = 1018

return, min > fix(round((data + shift)*scale + offset)) < max

end
