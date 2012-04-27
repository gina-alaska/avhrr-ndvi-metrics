FUNCTION file2jul, FileName, YEAR = year

IF (KEYWORD_SET(YEAR)) THEN year = year

;base = str_sep(FileName, ".")
base=FileName
len = strlen(base)
str=''

FOR i = 0, len-1 DO BEGIN

   c = strmid(base, i, 1)
   
   CASE (c GE '0' AND c LE '9') OF 
      1:  str = str+c
      ELSE:
   ENDCASE
ENDFOR

len = strlen(str)

CASE (len) OF
   10: BEGIN
         IF(NOT KEYWORD_SET(YEAR)) THEN year  = strmid(str, 0, 2)
         start = 2
       END
   8: BEGIN
         IF (NOT KEYWORD_SET(YEAR)) THEN BEGIN 
            print, "FILE2JUL: WARNING: YOU HAVE NOT GIVEN A YEAR"
            print, "FILE2JUL: WARNING: USING GENERIC NON-LEAP YEAR"
            year = 1
         ENDIF 
         start = 0 
      END
   else: MESSAGE, "MUST USE 8 or 10 CHARACTER DATE IN FILENAME"
ENDCASE


month = strmid(str, start  , 2)
day   = strmid(str, start+2, 2)
hour  = strmid(str, start+4, 2)
min   = strmid(str, start+6, 2)

jdref = julday(1,1,year)

jday = julday(month, day, year) - jdref

frac = hour/24. + min/1440.
jday = jday + frac


RETURN, jday
END

