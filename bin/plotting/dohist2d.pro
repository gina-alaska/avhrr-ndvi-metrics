PRO dohist2d, data1, data2, $
          bin1 = bin1, bin2=bin2,  $
          min1=min1, max1=max1,  $
          min2=min2, max2=max2, $
          log=log, winnum=winnum

;
;  SET XMIN1
; 
if (keyword_set(min1)) then $
  min1 = min1  $
else $
  min1 = floor(min(data1))

;
;  SET XMAX1
; 
if (keyword_set(max1)) then $
  max1 = max1  $
else $
  max1 = ceil(max(data1))

;
;  SET XMIN2
; 
if (keyword_set(min2)) then $
  min2 = min2  $
else $
  min2 = floor(min(data2))


;
;  SET XMAX2
; 
if (keyword_set(max2)) then $
  max2 = max2  $
else $
  max2 = ceil(max(data2))

;
;  SET BIN1
; 
if (keyword_set(bin1)) then $
  bin1 = bin1  $
else $
  bin1 = 1

;
;  SET BIN2
; 
if (keyword_set(bin2)) then $
  bin2 = bin2  $
else $
  bin2 = 1


;;nx = (xmax-xmin)/binsize 

;x = findgen(nx)*binsize + xmin

his = hist_2d(data1, data2, min1=min1, max1=max1, min2=min2, max2=max2,$
               bin1=bin1, bin2=bin2)

HisSize = size(his)
xs = HisSize(1)
ys = HisSize(2)

if(keyword_set(winnum)) then $
   window, winnum, xs = xs*4, ys= ys*4 $
else $
   window, 0, xs = xs*4, ys= ys*4 
  
if(keyword_set(log)) then $
   tvscl, rebin(alog(his+1), xs*4, ys*4), order=0 $
else $
   tvscl, rebin((his+1), xs*4, ys*4), order=0

end
