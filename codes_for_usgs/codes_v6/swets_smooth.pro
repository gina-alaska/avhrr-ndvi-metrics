;This program realize weighted-least-squre smooth algorithm original developed by Daniel L. Swets,2001
;inputs: vector, number of points before current point, number of points after current point,
;output smoothed vector
;jzhu, 2/8/2011

;jzhu, 8/19/2013, relize swets method, in includes weight determination, calculate regression lines of number, remove the outliners, average the
; multiple regression lines to get the "true" estimated value og the point.

pro swets_smooth, v, numrw,numcw, y

;v--input raw vector,
;y--output smoothed vector,
;numrw--number of regression window, points to be used to do regression,
;numcw--number of combined window. numcw must be in the range: numrw <=numcw<=numrw*2-1



;determine if the time series id valid
 
if min(v) EQ max(v) then begin   ; do not do smooth

y=v

return

endif


;---produce a temperary vector which adds  numrw-1 points at before and after the time series

num = n_elements(v)

numtmp=num +2*(numrw-1)

tmpv =fltarr(numtmp)

x =findgen(numtmp)


tmpv(0:numrw-2)= v(num-numrw+1:num-1)

tmpv(numrw-1:numrw-1+num-1)=v

tmpv(numrw+num-1:numtmp-1)=v(0:numrw-2)



;--- calculate weight, localpeal=1.5, localsloping=0.5, local valley=0.005

;-- the weights of the first and last points are assigned to 0.5

y =fltarr(num) ; store estimated y values

;------ calculate multiple regression lines for point j


if not (numcw GE numrw and numcw LE numrw*2-1 ) then begin  ; not valid choice for combination window length
    
    numcw=numrw*2-1
  
endif  
   
totk=numcw-numrw+1
    
bfpt=numcw/2
       
afpt=numrw-bfpt-1


for j= 0, num-1 do begin
     
  yval=fltarr(totk)
       
  for k=0, totk-1 do begin
     
     xtmp=     x(j+numrw-1-bfpt+k:j+numrw-1+afpt+k)
    
     ytmp = tmpv(j+numrw-1-bfpt+k:j+numrw-1+afpt+k)
     
    weight,ytmp,w

    wls_regression, xtmp ,ytmp , w, a, b, yout_tmp
    
     ;--- if has an outlier, get rid of the outlier, re-calculate a, b

    check_outlier, ytmp, yout_tmp, w, outlieridx
     
    if outlieridx GE 0 then begin    ; has outlier

    ;get rid of the outlier, calcualte regressline agin, and get the regress line inpterolate the point
    
    num1=n_elements(xtmp)
    
    if outlieridx EQ 0 then begin ;outlieridx=0
    
      xtmp1=xtmp[1:num1-1]
      ytmp1=ytmp[1:num1-1]
    endif else begin
      if outlieridx GT 0 and outlieridx LT num1-1 then begin ; 0<outlieridx<num1-1   
      
         xtmp1  =[xtmp(0:outlieridx-1), xtmp(outlieridx+1:num1-1)]
    
         ytmp1  =[ytmp(0:outlieridx-1), ytmp(outlieridx+1:num1-1)]
        
      endif else begin ; outlieridx = num1-1
         xtmp1 =xtmp[0:num1-2]
         ytmp1= ytmp[0:num1-2]
      endelse
    
    endelse    
  
      
    
    weight,ytmp1,w1
    
    wls_regression, xtmp1 ,ytmp1 , w1, a, b, yout_tmp1
          
    endif
    
    tmpk = a+b*xtmp(numrw-1-afpt-k)

    if tmpk LT 100.0 then begin

      tmpk = 100.0

    endif  
    
    yval(k)=tmpk
    
  endfor
      
  y (j) = mean(yval)    
      
endfor

return

end


pro weight, inputv, weightv

;---calculate weight, localpeal=1.5, localsloping=0.5, local valley=0.005

;-- the weights of the first and last points are assigned to 0.5

num=n_elements(inputv)

weightv =fltarr(num) ; store weight

weightv(*) =0.5  ; default value=0.5

for j=1, num-2 do begin

;--- comapre j-1,j, and j+1 to assign weight

if inputv(j) GT inputv(j-1) and inputv(j) GT inputv(j+1) then begin

  weightv(j)=1.5

endif else begin

   if inputv(j) LT inputv(j-1) and inputv(j) LT inputv(j+1) then begin

    weightv(j)=0.005

   endif


endelse

endfor

return

end


pro wls_regression, x, y, w, a, b, yout

;tmpv--input vectoir, w-weight, y--output regression line


sw=total(w)

sy=total(w*y)

sx=total(w*x)

sxy=total(w*x*y )

sxsqr=total(w*x*x)

b =(sw*sxy-sx*sy)/(sw*sxsqr-sx*sx)

a=(sy-b*sx)/sw

yout=a+b*x

return

end

; check outliers


pro check_outlier, y, yout, w, outlieridx

; compare y and yout, uses chi-square to check if yout is good-fit to y, if not, find out one outlier, and return the index of the outlier

e=yout-y

swse=total(w*e*e)

num=n_elements(y)

df=num-2

chi_sqr_tbl  =[   [0.95,  0.90,  0.80,  0.70,  0.50,  0.30,  0.20,  0.10,  0.05,  0.01,  0.001], $
                  [0.004, 0.02,  0.06,  0.15,  0.46,  1.07,  1.64,  2.71,  3.84,  6.64,  10.83], $
                  [0.10,  0.21,  0.45,  0.71,  1.39,  2.41,  3.22,  4.60,  5.99,  9.21,  13.82], $ 
                  [0.35,  0.58,  1.01,  1.42,  2.37,  3.66,  4.64,  6.25,  7.82,  11.34, 16.27], $
                  [0.71,  1.06,  1.65,  2.20,  3.36,  4.88,  5.99,  7.78,  9.49,  13.28, 18.47], $
                  [1.14,  1.61,  2.34,  3.00,  4.35,  6.06,  7.29,  9.24,  11.07, 15.09, 20.52], $
                  [1.63,  2.20,  3.07,  3.83,  5.35,  7.23,  8.56,  10.64, 12.59, 16.81, 22.46]  ]
                  
;find the index of the elements which is closest to value                 

array=chi_sqr_tbl(*,df)
value=swse
                  
if (n_elements(array) le 0) or (n_elements(value) le 0) then index=-1 $
        else if (n_elements(array) eq 1) then index=0 $
        else begin
                abdiff = abs(array-value)        ;form absolute difference
                mindiff = min(abdiff,index)      ;find smallest difference
        endelse
                  
;--- get the p-value

p=chi_sqr_tbl(index,0)

if p GT 0.05 then begin
  
  outlieridx=-1

endif else begin 

 ; find the outlier which id the max e
 
 outlieridx =( where( abs(e) EQ max( abs(e) )  )  )(0)
  
endelse

return

end


