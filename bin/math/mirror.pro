FUNCTION mirror, data, CENTERVAL=CENTERVAL, LEFT=LEFT, RIGHT=RIGHT
tmp=data
IF (N_Elements(CENTERVAL) EQ 0) THEN BEGIN
   IF KEYWORD_SET(LEFT) THEN tmp= [data, reverse(data)]
   IF KEYWORD_SET(RIGHT)THEN tmp= [reverse(data), data]
END ELSE BEGIN
   IF KEYWORD_SET(LEFT) THEN tmp= [data, CENTERVAL, reverse(data)]
   IF KEYWORD_SET(RIGHT)THEN tmp= [reverse(data), CENTERVAL, data]
END

return, tmp

END
