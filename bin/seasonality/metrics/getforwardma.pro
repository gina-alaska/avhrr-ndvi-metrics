FUNCTION GetForwardMA, In, WL

      InSize=Size(In)
      NSize=N_Elements(InSize)
nb=InSize[InSize[0]]

      Forward=Make_Array(Dimension=InSize[1:NSize-3], /Float)

      Case InSize[0] OF

         1: BEGIN
;            FOR i=0,InSize[NSize-3]-1 DO BEGIN
;              CASE (I lt WL-1) OF
;                 0: Forward[i]=float(total(In[i-(wl-1):i], 1))/wl
;                 1: Forward[i]=float(total(In[0:i],1))/(i+1)
;                 ELSE:
;              ENDCASE
;            END
;Forward=ts_smooth(shift(In,wl-1),wl,/forward)
tmp=[shift(In, wl-1)]
tmp=[tmp,tmp[0:wl-1]]
for i=0,InSize[NSize-3]-1 DO BEGIN
Forward[i]=Total(tmp[i:i+wl-1])
end
undefine,tmp
Forward=Forward/wl

         END
         2: BEGIN
            FOR i=0,InSize[NSize-3]-1 DO BEGIN
              CASE (I lt WL-1) OF
                 0: Forward[*,i]=float(total(In[*,i-(wl-1):i],2))/wl
                 1: Forward[*,i]=float(total(In[*,0:i],2))/(i+1)
                 ELSE:
              ENDCASE
            END
         END
         3: BEGIN
;            FOR i=0,InSize[NSize-3]-1 DO BEGIN
;              CASE (I lt WL-1) OF
;                 0: Forward[*,*,i]=float(total(In[*,*,i-(wl-1):i],3))/wl
;                 1: BEGIN
;                       CASE(i EQ 0) OF
;                         0:Forward[*,*,i]=float(total(In[*,*,0:i],3))/(i+1)
;                         1:Forward[*,*,i]=In[*,*,0]
;                         ELSE:
;                       ENDCASE
;Forward=ts_smooth(shift(In, 0,0,wl-1),/forward)
;tmp=[[[shift(In, 0,0,wl-1)]],[[In[*,*,nb-wl:nb-1]]]]
tmp=[shift(In, 0,0,wl-1)]
tmp=[[[tmp]],[[tmp[*,*,0:wl-1]]]]
for i=0,InSize[NSize-3]-1 DO BEGIN
Forward[*,*,i]=Total(tmp[*,*,i:i+wl-1],3)
end
undefine,tmp
Forward=Forward/wl
;                 END
;                 ELSE:
;              ENDCASE
;            END
         END

         ELSE:
      ENDCASE

RETURN, Forward
END
