;=== Convert AVHRR Radiance I*2 data to Radiance ===
FUNCTION rad2i, data;, shift


  scale =  1.874
  offset = 10.0
  shift = 0.0
  min = 10
  max = 1022

return, min > fix(round((data + shift)*scale + offset)) < max
end
