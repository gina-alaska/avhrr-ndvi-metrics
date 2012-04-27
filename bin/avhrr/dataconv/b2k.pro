;=== Convert AVHRR Thermal byte data to Kelvin ===
FUNCTION b2k, data
return, (data+405.0)/2.0
end
