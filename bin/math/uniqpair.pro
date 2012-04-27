FUNCTION  uniqpair, data1, data2

;
;  This function will extract indices for all unique data pairs from
;  (data1, data2)
;

;THIS METHOD DOESN'T WORK BECAUSE SORT SORTS COMPLEX BY MAGNITUDE
;pair = complex(data1, data2) 
;idx = uniq(pair, sort(pair))

; 12/3/97 - had to add double because result had been dependent
;           on order of data1 and data2

xmin=double(min(data1))
ymin=double(min(data2))

xmax=max(double(data1)-xmin)

new = (double(data1) - xmin) + xmax*(double(data2)-ymin)

idx = uniq(new, sort(new))

return, idx
end
