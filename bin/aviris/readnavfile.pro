FUNCTION ReadNavFile, PathFile, NL, VERBOSE=VERBOSE

FileName=Str_Sep(PathFile, '/')
nFileName=n_Elements(FileName)
FileName=FileName[nFileName-1]
nFields=29

inString=strarr(NL)
Data=strarr(nFields, NL)

OpenR, LUN, PathFile, /Get_LUN
ReadF, LUN, inString
Free_LUN, LUN

For i = 0, nl-1 DO BEGIN


   ParsedString=Str_sep(inString[i], ' ')
   
   a = where(ParsedString NE '',na)

   Data[*,i]=ParsedString[a]
END

; Altitude
;   Altitude=Avg(Data[18,*])/1000.
   Altitude=Data[18,0]/1000.

; Date
   YY=StrMid(FileName, 1,2)
   MM=StrMid(FileName, 3, 2)
   DD=StrMid(FileName, 5, 2)
   if YY GE 80 THEN YYYY='19'+YY ELSE YYYY='20'+YY   ; Y2K compliant :)

; Time
   Time=str_sep(data[1,0], ':')
   Hour=Time[1]
   Minute=Time[2]
   Second=Time[3]

; Latitude
   Latitude=fix(deg2dms(float(data[2,0])))
   IF (Latitude[0] LT 0) THEN LatHem='S' ELSE LatHem='N'      
   Latitude=abs(Latitude)

; Longitude
   Longitude=fix(deg2dms(float(data[3,0])))
   IF (Longitude[0] LT 0) THEN LonHem='W' ELSE LonHem='E'      
   Longitude=abs(Longitude)

NavData={Altitude: Altitude, $
         YYYY:YYYY, MM:MM, DD:DD, $
         Hour:Hour, Minute:Minute, Second:Second, $
         Latitude:Latitude, LatHem:LatHem, $
         Longitude:Longitude, LonHem:LonHem $
        }

IF KEYWORD_SET(VERBOSE) THEN BEGIN
   print, 'AVIRIS'
   print, strcompress(Altitude, /Remove_All)
   print, mm+' '+dd+' '+yyyy+' '+hour+' '+minute+' '+second
   print, strcompress(latitude, /Remove_All)
   print, lathem
   print, strcompress(longitude, /Remove_All)
   print, lonhem
END

Return, NavData
END 
