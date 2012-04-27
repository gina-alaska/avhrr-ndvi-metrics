;
;   Convert AVHRR byte data to satellite zenith angle
;
FUNCTION   b2satz, data
return, (data-90.0)
END
