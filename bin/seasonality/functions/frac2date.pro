FUNCTION  Frac2Date, FractionalYear, CALENDAR=CALENDAR

;
; This function takes a fractional year (eg, 1996.364) and
; converts it to  month, day and year
;
; The keyword CALENDAR will return the string MMM DD YYYY
;
Year = long(FractionalYear)

CASE Year MOD 4 OF
   0: DaysPerYear=366
   ELSE: DaysPerYear=365
ENDCASE

if Year EQ 0 then $
  DayOfYear= FractionalYear*DaysPerYear $
ELSE $
   DayOfYear= (FractionalYear MOD Year)*DaysPerYear

yr=year
if(year eq 0) then yr=yr+1600
CalDat,Julday(1,1,yr) + DayOfYear, mm,dd,yy
if(year eq 0) then yy=yy-1600


MMM=['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
IF dd lt 10 then day='0'+strcompress(dd, /Remove_All) ELSE day=strcompress(dd, /Remove_All)

IF KEYWORD_SET(CALENDAR) THEN $

Return, [MMM[mm-1]+' '+day+' '+strcompress(yy, /Remove_All)] $
ELSE Return, [mm, dd, yy]

END
