;
;  Convert AVHRR 10bit data to solar zenith angle
;
FUNCTION i2solz, data
return, (data-10.0)/10.0
end
