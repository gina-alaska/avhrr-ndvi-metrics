;
;  Convert AVHRR 10bit data to relative azimuth angle
;
FUNCTION i2relaz, data
return, (data-190.0)/10.0   ; 10 is used instead of 1 for sunsat
end
