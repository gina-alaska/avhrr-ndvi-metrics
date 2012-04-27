FUNCTION call_smoother, info, x, y
;print, "IN CALL_SMOOTHER"
;print, "INFO.DT",info.dt
;smoother_path='/edcsnw47/project/stretch/Smoother/bin/'
smoother_path='/edcsnw54/home/suarezm/gi/Smoother/bin/'
;smoother_path='/edcsnw54/home/suarezm/tmp/Smoother/'
pixel_path='/tmp/pixel'

        ; define image array based on data type inputted

        if (info.dt eq 2) then begin
                type = info.dt
                smoother='asciiout'
        endif else begin
                type = info.dt
                smoother='asciioutbyte'
        endelse

        ;read smooth parameters
         pp=info.mSmoothParam.pp
         ps=info.mSmoothParam.ps
         swin=info.mSmoothParam.swin
         rwin=info.mSmoothParam.rwin
         cwin=info.mSmoothParam.cwin
         pwght=info.mSmoothParam.pwght
         swght=info.mSmoothParam.swght
         vwght=info.mSmoothParam.vwght


        smth_str = smoother_path+smoother+' -i '+$
                pixel_path+' -data '+strcompress(type)+$
                ' -bands '+strcompress(info.nb)+' -rows 1 -cols 1 '+$
                ' -pp '+strcompress(pp)+' -peaks '+strcompress(ps)+$
                ' -wr '+strcompress(rwin)+' -s '+strcompress(swin)+$
                ' -wc '+strcompress(cwin)+' -wp '+strcompress(pwght)+$
                ' -ws '+strcompress(swght)+' -wv '+strcompress(vwght)


print, smth_str

        spawn,smth_str,smth_data



CASE (info.dt) OF
   1: BEGIN
         ismth_data = byte(smth_data)
;print, ismth_data
;help, ismth_data
   END
   2: BEGIN
         ismth_data = fix(smth_data)
;print, ismth_data
;help, ismth_data
   END
   ELSE:
ENDCASE

;openw,lun,"tmp.byte",/get_lun
;for i = 0, 431 do printf, lun, info.image(x-1,y-1,i), ismth_data(i)
;free_lun, lun

return, ismth_data
end
