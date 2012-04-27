FUNCTION MonthNames, INDEX=Index, LONG=Long, UPPER=Upper


   Months=['January', 'February', 'March', $
           'April', 'May', 'June', $
           'July', 'August', 'September', $
           'October', 'November', 'December']

   IF (NOT KEYWORD_SET(LONG)) THEN $
      Months=strmid(Months, 0, 3) 

   IF (KEYWORD_SET(UPPER)) THEN $
      Months=strupcase(Months)

   IF (N_ELEMENTS(Index) gt 0) THEN BEGIN
      idx=index mod 12
      a=where(idx lt 0, na)
      if (na gt 0) then idx[a]=12+idx[a]
      Months=Months[Idx]
   END

Return, Months
END
