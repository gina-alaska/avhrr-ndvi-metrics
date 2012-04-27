; $Id: hist_3d.pro,v 1.3 1997/01/15 03:11:50 ali Exp $
;
; Copyright (c) 1992-1997, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;+ 
;       Modified to do 3d by M. Suarez 11/1997
;
; NAME:
;	HIST_3D
;
; PURPOSE:
;	Return the density function (histogram) of three variables.
;
; CATEGORY:
;	Image processing, statistics, probability.
;
; CALLING SEQUENCE:
;	Result = hist_3d(V1, V2, V3)
; INPUTS:
;	V1, V2 and V3 = arrays containing the variables.  May be any non-complex
;		numeric type.
;
; Keyword Inputs:
;       MIN1:   MIN1 is the minimum V1 value to consider. If this
;               keyword is not specified, then it is set to 0.
;
;       MIN2:   MIN2 is the minimum V2 value to consider. If this
;               keyword is not specified, then it is set to 0.
;
;       MIN3:   MIN3 is the minimum V3 value to consider. If this
;               keyword is not specified, then it is set to 0.
;
;       MAX1:   MAX1 is the maximum V1 value to consider. If this
;               keyword is not specified, then V1 is searched for
;               its largest value.
;
;       MAX2    MAX2 is the maximum V2 value to consider. If this
;               keyword is not specified, then V2 is searched for
;               its largest value.
;
;       MAX3    MAX3 is the maximum V3 value to consider. If this
;               keyword is not specified, then V3 is searched for
;               its largest value.
;
;       BIN1    The size of each bin in the V1 direction (column
;               width).  If this keyword is not specified, the
;               size is set to 1.
;
;       BIN2    The size of each bin in the V2 direction (row
;               height).  If this keyword is not specified, the
;               size is set to 1.
;
;       BIN3    The size of each bin in the V3 direction (z
;               depth).  If this keyword is not specified, the
;               size is set to 1.
;
; OUTPUTS:
;	The three dimensional density function of the three variables,
;	a longword array of dimensions (m1, m2, m3), where:
;		m1 = Floor((max1-min1)/bin1) + 1
;	   and  m2 = Floor((max2-min2)/bin2) + 1
;	and Result(i,j) is equal to the number of sumultaneous occurences
;	of an element of V1 falling in the ith bin, with the same element
;	of V2 falling in the jth bin, where:
;		i = (v1 < max1 - min1 > 0) / b1
;	   and  j = (v2 < max2 - min2 > 0) / b2
;
;	Note: elements larger than the max or smaller than the min are
;	truncated to the max and min, respectively.
;	
; COMMON BLOCKS:
;	None.
; SIDE EFFECTS:
;	None.
; RESTRICTIONS:
;	Not usable with complex or string data.
; PROCEDURE:
;	Creates a combines array from the three variables, equal to the
;	linear subscript in the resulting 2D histogram, then applies
;	the standard histogram function.
;
; EXAMPLE:
;	Return the 2D histogram of three byte images:
;		R = HIST_2D(image1, image2)
;
;	Return the 2D histogram made from three floating point images
;	with range of -1 to +1, and with 101 (= 2/.02 + 1) bins:
;		R = HIST_2D(f1, f2, MIN1=-1, MIN2=-1, MAX1=1, MAX2=1, $
;			BIN1=.02, BIN2=.02)
;
; MODIFICATION HISTORY:
; 	Written by:
;	DMS, Sept, 1992		Written
;	DMS, Oct, 1995		Added MIN, MAX, BIN keywords following
;				suggestion of Kevin Trupie, GSC, NASA/GSFC.
;-
; Form the 3 dimensional histogram of three arrays.
; Result(i,j,k) = density of value i in im1, and value j in im2.
; Input images must be, of course, the same size....
;
function hist_3d, im1, im2, im3, $
        Min1 = mn1, Min2 = mn2, Min3 = mn3, $
        Max1 = mx1, Max2 = mx2, Max3 = mx3, $
	Bin1 = b1, Bin2 = b2, Bin3 = b3

m1 = max(im1, min=mm1)	;Find extents of arrays.
m2 = max(im2, min=mm2)
m3 = max(im3, min=mm3)

if N_elements(mn1) eq 0 then mn1 = 0	;Supply default values for keywords.
if N_elements(mx1) eq 0 then mx1 = m1
if N_elements(mn2) eq 0 then mn2 = 0
if N_elements(mx2) eq 0 then mx2 = m2
if N_elements(mn3) eq 0 then mn3 = 0
if N_elements(mx3) eq 0 then mx3 = m3
if N_elements(b1) le 0 then b1 = 1L
if N_elements(b2) le 0 then b2 = 1L
if N_elements(b3) le 0 then b3 = 1L

m1 = floor((mx1-mn1) / b1) + 1L		;Get # of bins for each
m2 = floor((mx2-mn2) / b2) + 1L
m3 = floor((mx3-mn3) / b3) + 1L

if m1 le 0 or m2 le 0 or m3 le 0 then message,'Illegal bin size'

	; Combine with im1 in low part & im2 in high
if      mn1 eq 0 and mn2 eq 0 and mn3 eq 0 and $  ; Fast case without scaling?
	b1 eq 1L and b2 eq 1L and b3 eq 1L and $
	mx1 le m1 and mx2 le m2 and mx3 le m3 and $
	mm1 ge 0 and mm2 ge 0 and mm3 ge 0  then $

   h = m2 * m1 * long(im3) + $
            m1 * long(im2) + $
                 long(im1) $                      ; *******

else if b1 eq 1L and b2 eq 1L and b3 eq 1L then $	;Avoid dividing?

   h = m2 * m1 * long((im3 < mx3) - mn3 > 0L) + $ 
            m1 * long((im2 < mx2) - mn2 > 0L) + $
                 long((im1 < mx1) - mn1 > 0L) $

else $					;Slowest case

   h = m2 * m1 * long(((im3 < mx3) - mn3 > 0L) / b3) + $ 
            m1 * long(((im2 < mx2) - mn2 > 0L) / b2) + $
	         long(((im1 < mx1) - mn1 > 0L) / b1)

h = histogram(h, min = 0, max= m1 * m2 * m3 -1)  ;Get the 1D histogram

return, reform(h, m1, m2, m3, /overwrite) ;and make it 3D

end
