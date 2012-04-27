FUNCTION call_smoother, mInfo, mSmoothParam, x, y
;print, "IN CALL_SMOOTHER"
;print, "INFO.DT",mInfo.dt

;        ;define image array based on data type inputted
        if (mInfo.dt eq 2) then begin
;                smth_data = intarr(mInfo.ns,mInfo.nl,mInfo.nb)
                type = mInfo.dt
smoother='asciiout'
        endif else begin
;                smth_data = bytarr(mInfo.ns,mInfo.nl,mInfo.nb)
                type = mInfo.dt
smoother='asciioutbyte'
        endelse
;        openw,unit,'/tmp/Smoother/pixel',/get_lun
;        writeu,unit,mInfo.image(x-1,y-1,*)
;        free_lun,unit

        ;read smooth parameters
        widget_control,mInfo.pp,get_value=pp
        widget_control,mInfo.ps,get_value=pps
        widget_control,mInfo.swin,get_value=sw
        widget_control,mInfo.rwin,get_value=rw
        widget_control,mInfo.cwin,get_value=cw
        widget_control,mInfo.pwght,get_value=pwt
        widget_control,mInfo.swght,get_value=swt
        widget_control,mInfo.vwght,get_value=vwt
;       smth_str = '/sg1/sab1/swets/Smoother/bin/asciiout -i '+$
        smth_str = '/edcsnw54/home/suarezm/gi/Smoother/bin/'+smoother+' -i '+$
                '/tmp/Smoother/pixel -data '+strcompress(type)+$
                ' -bands '+strcompress(mInfo.nb)+' -rows 1 -cols 1 '+$
                ' -pp '+strcompress(pp)+' -peaks '+strcompress(pps)+$
                ' -wr '+strcompress(rw)+' -s '+strcompress(sw)+$
                ' -wc '+strcompress(cw)+' -wp '+strcompress(pwt)+$
                ' -ws '+strcompress(swt)+' -wv '+strcompress(vwt)


;print, smth_str

        spawn,smth_str,smth_data
CASE (mInfo.dt) OF
   1: BEGIN
         ismth_data = byte(smth_data)
;print, ismth_data
;help, ismth_data
   END
   2: BEGIN
         ismth_data = fix(smth_data)
;help, ismth_data
   END
   ELSE:
ENDCASE

;openw,lun,"tmp.byte",/get_lun
;for i = 0, 431 do printf, lun, mInfo.image(x-1,y-1,i), ismth_data(i)
;free_lun, lun

return, ismth_data
end
