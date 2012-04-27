pro	readhrly, c

;
; reads hourly data from ainsworth data file ne23.94h
;
; input array is c(10,7488) where 10 dimensions the parameters and
; 7488 dimensions the hourly intervals between 1/1/94 and 11/8/94, from
; midnight to midnight
;
; variables are:
;	c(0,*)	month
;	c(1,*)	day
;	c(2,*)	hour*100
;	c(3,*)	air temp in degrees C
;	c(4,*)	relative humidity in %
;	c(5,*)	soil temp in degrees C
;	c(6,*)	wind speed in miles/hour
;	c(7,*)	wind direction in degrees
;	c(8,*)	solar (total hemispherical) irradiance in W/m^2
;	c(9,*)	precip in inches
;

c=fltarr(10,7488)
openr,1,'/sg1/sabres/meyer/grass/data/ne23.94h'
readf,1,c
close,1

return
end
