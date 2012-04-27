;PRO SM_GetSmParam, mParent
FUNCTION SM_GetSmParam, mParent


Widget_Control, mParent, Get_UValue=mLocal


        Widget_Control,mLocal.pp,get_value=pp
        Widget_Control,mLocal.ps,get_value=ps
        Widget_Control,mLocal.nmin,get_value=nmin
        Widget_Control,mLocal.swin,get_value=swin
        Widget_Control,mLocal.rwin,get_value=rwin
        Widget_Control,mLocal.cwin,get_value=cwin
        Widget_Control,mLocal.pwght,get_value=pwght
        Widget_Control,mLocal.swght,get_value=swght
        Widget_Control,mLocal.vwght,get_value=vwght

mSmoothParam={msmoothparam}
          mSmoothParam.pp=pp 
          mSmoothParam.ps=ps 
          mSmoothParam.nmin=nmin 
          mSmoothParam.swin=swin 
          mSmoothParam.rwin=rwin 
          mSmoothParam.cwin=cwin 
          mSmoothParam.pwght=pwght 
          mSmoothParam.swght=swght 
          mSmoothParam.vwght=vwght 
          
;        Widget_Control,mParent.pp,get_value=pp
;        Widget_Control,mParent.ps,get_value=ps
;        Widget_Control,mParent.swin,get_value=sw
;        Widget_Control,mParent.nmin,get_value=nmin
;        Widget_Control,mParent.rwin,get_value=rw
;        Widget_Control,mParent.cwin,get_value=cw
;        Widget_Control,mParent.pwght,get_value=pwt
;        Widget_Control,mParent.swght,get_value=swt
;        Widget_Control,mParent.vwght,get_value=vwt

;        mParent.mSmoothParam.pp=pp
;        mParent.mSmoothParam.ps=ps
;        mParent.mSmoothParam.swin=sw
;        mParent.mSmoothParam.nmin=nmin
;        mParent.mSmoothParam.rwin=rw
;        mParent.mSmoothParam.cwin=cw
;        mParent.mSmoothParam.pwght=pwt
;        mParent.mSmoothParam.swght=swt
;        mParent.mSmoothParam.vwght=vwt
;        mParent.mSmoothParam.MaxVal=mParent.MaxVal
;        mParent.mSmoothParam.MinVal=mParent.MinVal



Return, mSmoothParam
END
