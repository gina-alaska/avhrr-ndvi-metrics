FUNCTION  Flt2Str, Number, SignificantDigits, PLUS=PLUS

Rounded = Round_To(Number, 1./10^SignificantDigits )

String1 = strcompress(rounded, /Remove_All)
String1Arr = str_sep(String1, '.')
nString1Arr = n_Elements(String1Arr)
Last = strmid(String1Arr[nString1Arr-1], 0, SignificantDigits)

CASE (KEYWORD_SET(PLUS)) OF
   1: if (strmid(String1Arr[0], 0, 1) NE '-') THEN plus = '+' ELSE plus=''
   ELSE:plus=''
ENDCASE 
NewString=plus+String1Arr[0]+'.'+Last
if LAST EQ '' then NewString=plus+String1Arr[0]
Return, NewString
END
