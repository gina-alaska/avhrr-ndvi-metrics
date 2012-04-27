;==========================================================================;
; This file contains default values for the seasonal metrics               ;
; smoother interface.                                                      ;
;==========================================================================;

;===== SMOOTHER OPTIONS ===================================================;
;
;  These are the Fields available under the "Smoother" tab 
;  in the interface
;
;  Note: swin_def, Season Window, is given by bands per year
;        in the original input information
;==========================================================================;
sm_def={$
          pp_def    : 0.3	$; Peak Percentage
        , ps_def    : 1		$; Peaks Per Season
        , nmin_def  : -0.1      $; Minimum NDVI
        , nmax_def  : 0.8       $; Maximum NDVI
        , swin_def  : -1 	$; Season Window(filled in by OpenFile)
        , rwin_def  : 5 	$; Regression Window
        , cwin_def  : 6 	$; Combination Window
        , pwght_def : 1.5 	$; Peak Weights
        , swght_def : 0.5 	$; Slope Weights
        , vwght_def : 0.05 	$; Valley Weights
       }


;===== METRICS OPTIONS ====================================================
;
;  These are the Fields Available under the "Metrics" tab in the 
;  interface
;
;  Note: startyear_def - only used for presentation, can be input
;                       through interface
;        currentband_def - calculated from Bands Per Year and Number
;                       of Bands
;==========================================================================
met_def={$
           swindowlength_def:15	$; Start of Season Window Length
         , ewindowlength_def:18	$; End of Season Window Length
         , startyear_def    : 0 $; Starting Calendar Year
         , currentband_def  : 0 $; Final band off most recent year
        }

;===== PLOT OPTIONS ====================================================
;
;  These are the Fields Available under the "Plotter" tab in the 
;  interface
;
;  Note: 
;==========================================================================
plot_def={$
           XMin_def: 0L	$; Minimum Band number
         , XMax_def:-1L	$; Maximum Band numer (determined on input)
         , YMin_def:-1L $; Minimum Data value (determined on input)
         , YMax_def:-1L $; Maximum Data Value (determined on input)
        }



;
; Plotter Options
;
ShowText_def = ["Smoothed", "Raw Data", "Text", $
                "SOS", "EOS", "Now", $
                "F Avg", "B Avg"]
ShowBut_def = [1,1,0,1,1,0,0,0]



