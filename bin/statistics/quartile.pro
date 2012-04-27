FUNCTION Quartile, Data, Percent

;
; This function calculates the percentile value from Data
;
     DSorted=Data(sort(Data))

     N=N_Elements(Data)
     NP=N_Elements(Percent)
     if np gt 1 then begin
        k=intarr(np)
        q=fltarr(np)
        for i=0, np-1 do BEGIN
           k[i]=floor(percent[i]*(N+1))
           CASE (1) OF
             Percent[i] GT (n-1.)/n: Q[i]=max(data)
             Percent[i] LT 1./n: Q[i]=min(data)
             ELSE: BEGIN
                Q[i]=DSorted[k[i]-1] + ((N+1)*Percent[i] - K[i])*(DSorted[K[i]]-DSorted[K[i]-1])
             END
           ENDCASE
        end; for
     end else BEGIN
        K=floor(Percent*(N+1))
           CASE (1) OF
             Percent GT (n-1.)/n: Q=max(data)
             Percent LT 1./n: Q=min(data)
             ELSE: BEGIN
                Q=DSorted[k-1] + ((N+1)*Percent - K)*(DSorted[K]-DSorted[K-1])
             END
           ENDCASE
     END

Return, Q
END
