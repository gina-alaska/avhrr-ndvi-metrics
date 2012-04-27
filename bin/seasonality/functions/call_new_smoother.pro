FUNCTION CALL_NEW_SMOOTHER, info 

; This is a file that needs to exist in the path on the
; running machine.  It contains the variables PIXEL_PATH
; and SMOOTHER_PATH
@seasonality_defaults


        ; define image array based on data type inputted
        if (info.minfo.dt eq 2) then begin
                type = info.minfo.dt
                smoother='smooth'
                smth_data=intarr(info.minfo.nb)
        endif else begin
                type = info.minfo.dt
                smoother='smooth'
                smth_data=bytarr(info.minfo.nb)
        endelse
        ;read smooth parameters
         pp=info.mSmoothParam.pp
         ps=info.mSmoothParam.ps
         nmin=info.mSmoothParam.nmin
         nmax=info.mSmoothParam.nmax
         swin=info.mSmoothParam.swin
         rwin=info.mSmoothParam.rwin
         cwin=info.mSmoothParam.cwin
         pwght=info.mSmoothParam.pwght
         swght=info.mSmoothParam.swght
         vwght=info.mSmoothParam.vwght
         minval=info.mSmoothParam.minval
         maxval=info.mSmoothParam.maxval

         smth_str = smoother_path+smoother+' '+argFile

         argtxt= $
                ' -i '+pixel_path+$
                ' -data '+strcompress(type)+$
                ' -bands '+strcompress(info.minfo.nb)+$
                ' -rows 1 -cols 1 '+$
                ' -min'+strcompress(minval)+$
                ' -max'+strcompress(maxval)+$
                ' -pp '+strcompress(pp)+$
                ' -peaks '+strcompress(ps)+$
                ' -gmin '+strcompress(nmin)+$
                ' -gmax '+strcompress(nmax)+$
                ' -wr '+strcompress(rwin)+$
                ' -s '+strcompress(swin)+$
                ' -wc '+strcompress(cwin)+$
                ' -wp '+strcompress(pwght)+$
                ' -ws '+strcompress(swght)+$
                ' -wv '+strcompress(vwght)+$
                ' -o '+spixel_path

openw,LUN,argFile, /Get_LUN
printf, LUN, argtxt
Free_LUN, LUN

        spawn,smth_str
        load, spixel_path, smth_data
CASE (info.minfo.dt) OF
   1: BEGIN
         ismth_data = byte((smth_data))
   END
   2: BEGIN
         ismth_data = fix(smth_data)
   END
   ELSE:
ENDCASE
;openw,lun,"tmp.byte",/get_lun
;for i = 0, 431 do printf, lun, info.image(x-1,y-1,i), ismth_data(i)
;free_lun, lun
return, ismth_data
end