;
;   Convert AVHRR byte data to NDVI
;
FUNCTION   b2nd, data
return, (data-100.0)/100.00
END
