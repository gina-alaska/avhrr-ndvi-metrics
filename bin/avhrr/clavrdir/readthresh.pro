FUNCTION  ReadThresh, File

cthresh = {cthresh, $
   red : fltarr(14), $
   ndv : fltarr(14), $
   fmr : fltarr(14), $
   tgc : fltarr(14) $
   }

OpenR, 1, File

ReadF, 1, cthresh

Close, 1

RETURN, CThresh
END
