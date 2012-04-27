;=== Convert AVHRR NDVI I*2 data to NDVI ===
FUNCTION i2nd, data;, shift


  scale =  100.0
  offset = 110.0
  shift = 0.0


return, (data - offset)/scale - shift
end
