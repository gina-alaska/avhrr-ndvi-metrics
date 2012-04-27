;=== Convert AVHRR Radiance I*2 data to Radiance ===
FUNCTION i2rad, data;, shift


  scale =  1.874
  offset = 10.0
  shift = 0.0


return, (data - offset)/scale - shift
end
