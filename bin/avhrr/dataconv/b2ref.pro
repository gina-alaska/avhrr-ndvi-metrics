;
;   Convert AVHRR byte data to reflectance
;
FUNCTION   b2ref, data
return, data/400.
END
