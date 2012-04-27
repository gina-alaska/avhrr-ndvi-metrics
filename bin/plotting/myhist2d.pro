FUNCTION myhist2d, data1, data2, x, y, $
         bin1 = bin1, min1=min1, max1=max1, $
         bin2 = bin2, min2=min2, max2=max2, $
         log=log

;
;  This is my version of HIST_2D which also returns the X and
;  Y arrays through the argument list
;


if (keyword_set(min1)) then $
  min1 = min1  $
else $
  min1 = floor(min(data1))

if (keyword_set(max1)) then $
  max1 = max1  $
else $
  max1 = ceil(max(data1))


if (keyword_set(min2)) then $
  min2 = min2  $
else $
  min2 = floor(min(data2))

if (keyword_set(max2)) then $
  max2 = max2  $
else $
  max2 = ceil(max(data2))


nx = (max1-min1)/bin1 
ny = (max2-min2)/bin2 

x = findgen(nx+1)*bin1 + min1
y = findgen(ny+1)*bin2 + min2

histo = hist_2d(data1, data2, $
                min1=min1, max1=max1, bin1=bin1, $
                min2=min2, max2=max2, bin2=bin2)


RETURN, histo
end
