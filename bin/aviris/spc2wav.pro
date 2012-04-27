PRO spc2wav, FileNameRoot
;
; This Procedure reads an AVIRIS tape *.spc spectral calibration file
; and converts it to an ATREM readable *.wav wavelength file
;

   nb=224


mSPC={ WaveCenter: -1.0, $            ;nanometers
       FWHM: -1.0, $                  ;nanometers
       WCUncertainty: -1.0, $         ;nanometers
       FWHMUncertainty: -1.0, $       ;nanometers
       Channel: -1L $                 ; Integer
     }

mWAV={ Channel: -1.0, $               ;Float
       WaveCenter: -1.0, $            ;micrometers
       FWHM: -1.0 $                   ;micrometers
     }
;
; Read  .spc file
;
   OpenR, LUNR, FileNameRoot+'.spc', /Get_LUN
   OpenW, LUNW, FileNameRoot+'.wav', /Get_LUN
   Free_LUN, LUNW
      OpenU, LUNU, FileNameRoot+'.wav', /Get_LUN

   For i = 0, nb-1 DO BEGIN
   
      ReadF, LUNR, mSPC
      mWAV.Channel    = float(mSPC.Channel)
      mWAV.WaveCenter = mSPC.WaveCenter/1000.0
      mWAV.FWHM       = mSPC.FWHM/1000.0
   
      printf, LUNU, mWAV.Channel, mWAV.WaveCenter, mWav.FWHM
   END
      Free_LUN, LUNU
   Free_LUN, LUNR
END
