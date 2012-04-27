;
;   Convert AVHRR byte data to relative azimuth angle
;
FUNCTION   b2relaz, data
return, (data*1.0)
END
