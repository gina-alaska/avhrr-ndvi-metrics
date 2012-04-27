FUNCTION Idx2XYZ, Index, NS, NL
ni=n_elements(Index)

;xyz={x:lonarr(ni), $
;     y:lonarr(ni), $
;     z:lonarr(ni) $
;    }
xyz=lonarr(3, ni)

;    xyz.x= Index mod ns
;    xyz.y= (Index mod (long(ns)*long(nl)))/ns
;    xyz.z= Index /(long(ns)*long(nl))

    xyz[0,*]= Index mod ns
    xyz[1,*]= (Index mod (long(ns)*long(nl)))/ns
    xyz[2,*]= Index /(long(ns)*long(nl))

RETURN, XYZ
END
