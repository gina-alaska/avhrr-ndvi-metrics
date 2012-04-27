;=== Convert AVHRR Reflectance I*2 data to Reflectance ===
FUNCTION ref2i, data;, shift


  scale =  1000.0   ; converts from 0.XX rather than XX%
  offset = 10.0
  shift = 0.0
  min = 10
  max = 1010 

return, min > fix(round((data + shift)*scale + offset)) < max
end
