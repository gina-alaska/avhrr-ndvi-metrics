;
;  Convert AVHRR 10bit data to satellite zenith angle
;
FUNCTION i2satz, data
;return, (data-100.0)/10.0
return, (data)/10.0
end
