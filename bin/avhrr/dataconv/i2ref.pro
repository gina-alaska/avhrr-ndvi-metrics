;=== Convert AVHRR Radiance I*2 data to Reflectance ===
FUNCTION i2ref, data


  scale =  1000.0  ;  puts into  0.XX  rather than XX%
  offset = 10.0
  shift = 0.0


return, (data - offset)/scale - shift
end
