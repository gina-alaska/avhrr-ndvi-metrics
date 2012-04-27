FUNCTION RmZeros, Array, START=Start, TRAIL=Trail, ALL=All

;
; This function removes the leading and/or trailing zeroes from
; a 1-d array
;
n = N_Elements(array)

ZeroIdx = where(array EQ 0)
NotZeroIdx = where(array NE 0)

MinNotZeroIdx = min(NotZeroIdx) 
MaxNotZeroIdx = max(NotZeroIdx) 

;MiddleZeroIdx = where(ZeroIdx GT MinNotZeroIdx and ZeroIdx LT MaxZeroIdx)



IF KEYWORD_SET(START) THEN NewArray=Array[MinNotZeroIdx:n-1]

IF KEYWORD_SET(TRAIL) THEN NewArray=Array[0:MaxNotZeroIdx]

IF KEYWORD_SET(ALL) THEN NewArray=Array[NotZeroIdx]



RETURN, NewArray
END
