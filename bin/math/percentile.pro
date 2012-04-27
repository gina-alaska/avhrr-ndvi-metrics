FUNCTION percentile, data, percent

;
;  This function returns the value of DATA which marks the
;  PERCENT percentile.  Measured from bottom up, ie, a low
;  PERCENT returns a low end of DATA
;

sorted = data(sort(data))

Num = n_elements(data)

PCIndex = floor(percent*num/100.)

return, sorted(PCIndex)
end
