;=== Convert AVHRR NDVI to NDVI I*2 data ===
FUNCTION nd2i, data;, shift


  scale =  100.0
  offset = 110.0
  shift = 0.0
  min=10
  max = 210

return, min > fix(round((data+shift)*scale +offset )) < max
end
