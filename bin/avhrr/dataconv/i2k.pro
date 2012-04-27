;=== Convert AVHRR Thermal I*2 data to Kelvin ===
FUNCTION i2k, data;, shift


  ; This is the current way of doing things
  scale = 5.602; 10.0
  offset = -886.32 ;-1590.0
  shift = 0.0


return, (data - offset)/scale - shift
end
