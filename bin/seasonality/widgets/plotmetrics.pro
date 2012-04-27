PRO PlotMetrics_event, ev

END; PlotMetrics_event

;======================
;  WIDGET DEFINITION
;======================

PRO PlotMetrics, NDVI, Smooth, mMetrics

wBase=Widget_Base(Title='PLOT METRICS', App_MBar=AppMBar,/Column)

menu_desc = '1\File', $
               '0\Open File...', $
               '0\Close', $
               '2\Exit', $
            '1\
