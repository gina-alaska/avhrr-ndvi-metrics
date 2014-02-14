FUNCTION GetBackwardMA, In, WL

      InSize=Size(In)
      NSize=N_Elements(InSize)
      NElem=InSize[NSize-3]

      Backward=Make_Array(Dimension=InSize[1:NSize-3], /Float)

      Check=NElem -wl -2

;
; Apply moving averages based on number of dimensions (1-3)
;
      Case InSize[0] OF

         1: BEGIN
            tmp=[shift(In, -(wl-1))]
            tmp=[tmp,tmp[0:wl-1]]
            for i=0,InSize[NSize-3]-1 DO BEGIN
               Backward[i]=Total(tmp[i:i+wl-1])
            end
            undefine,tmp
            Backward=shift(Backward,wl-1)/wl

         END; 1-D Case

         2: BEGIN
            FOR i=InSize[NSize-3]-1, 0, -1 DO BEGIN
              CASE (I LT Check) OF
                 0: Backward[*,i]=float(total(In[*,i:NElem-1],2))/(NElem-i)
                 1: Backward[*,i]=float(total(In[*,i:i+wl-1],2))/(wl)
                 ELSE:
              ENDCASE
            END
         END; 2-D Case

         3: BEGIN
            tmp=[shift(In, 0,0,-(wl-1))]
            tmp=[[[tmp]],[[tmp[*,*,0:wl-1]]]]
            for i=0,InSize[NSize-3]-1 DO BEGIN
               Backward[*,*,i]=Total(tmp[*,*,i:i+wl-1],3)
            end
            undefine,tmp
            Backward=shift(Backward,0,0,wl-1)/wl

         END; 3-D Case

         ELSE:
      ENDCASE

RETURN, Backward
END
