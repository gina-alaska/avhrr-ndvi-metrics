;=== Convert AVHRR Thermal Kelvin to byte data ===
FUNCTION k2b, data
return, byte(round((data*2)-405))
end

