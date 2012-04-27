PRO Metrics_event, ev

Widget_Control, ev.top, Get_UValue=mLocal


CASE (ev.value) OF

   'File.Open File...': BEGIN
;       mtmp = Open_File()
;       mLocal.mInfo = mtmp
        ;mLocal.wOpenFile=Open_File(mLocal)
        mLocal.wOpenFile=Open_File()
   END; File.Open


   'File.Exit':  Widget_Control, /Destroy, mLocal.wBase

   'View.Smoother': BEGIN 
                    IF (NOT Widget_Info(mLocal.wSmoother, /Valid_ID)) THEN $
                        mLocal.wSmoother = Smoother(mLocal)
                    END
   'View.Image':    IF (NOT Widget_Info(mLocal.wFSZView, /Valid_ID)) THEN $
                        mLocal.wFSZView =  fszview(mLocal)
   'View.Position': BEGIN
                    IF (NOT Widget_Info(mLocal.wPosition, /Valid_ID)) THEN $
                        mLocal.wPosition =  cw_projpos(mLocal)
                    Widget_Control, mLocal.wPosition, Map=1
                    END
   'View.Metrics':  IF (NOT Widget_Info(mLocal.wCalcMetrics, /Valid_ID)) THEN $
                        mLocal.wCalcMetrics = CalcMetrics(mLocal)

;   'Cube.Outlier Rejection':  $
;       IF (NOT Widget_Info(mLocal.wCubeOutlier, /Valid_ID)) THEN $
;          mLocal.wCubeOutlier = CubeOutlier(mLocal)
;
;   'Cube.Smooth Cube':  $
;       IF (NOT Widget_Info(mLocal.wCubeSmooth, /Valid_ID)) THEN $
;          mLocal.wCubeSmooth = CubeSmooth(mLocal)

   ELSE:
ENDCASE


IF (Widget_Info(ev.top, /Valid_ID)) THEN $
   Widget_Control, ev.top, Set_UValue=mLocal

END; Metrics_event


;
;
;
;PRO Metrics_Broadcast, ev
;
;END

;=============================;
;  WIDGET_DEFINITION: Metrics ;
;=============================;
PRO metrics


wBase = Widget_Base(Title="Seasonal Metrics", XSize = 320, App_MBar = App_MBar)

menu_desc = [ '1\File', $
                 '0\Open File...', $
                 '0\Close', $
                 '2\Exit', $
              '1\View', $
                 '0\Smoother', $
                 '0\Image', $
                 '0\Position', $
                 '2\Metrics', $
              '1\Cube', $
                 '0\Outlier Rejection', $
                 '2\Smooth Cube'$
            ]

wAppMenu = CW_PDMenu(App_MBar, menu_desc, /mbar, /return_full_name) 


Widget_Control, wBase, /Realize, TLB_Set_XOff = 0, TLB_Set_YOff = 0

;mInfo = {minfo}


IF (N_Elements(wFSZView) EQ 0 ) THEN wFSZView = -1L
IF (N_Elements(wSmoother) EQ 0 ) THEN wSmoother = -1L
IF (N_Elements(wCalcMetrics) EQ 0 ) THEN wCalcMetrics = -1L
IF (N_Elements(wCubeOutlier) EQ 0 ) THEN wCubeOutlier = -1L
IF (N_Elements(wCubeSmooth) EQ 0 ) THEN wCubeSmooth = -1L

IF (N_Elements(wPosition) EQ 0 ) THEN wPosition = -1L
IF (N_Elements(wOpenFile) EQ 0 ) THEN wOpenFile = -1L

mLocal = {  wBase:wBase $
;         ,  mInfo:mInfo $
         , wOpenFile:wOpenFile $
         ,  wFSZview: wFSZView $
         ,  wSmoother: wSmoother $
         ,  wCalcMetrics: wCalcMetrics $
         ,  wCubeOutlier: wCubeOutlier $
         ,  wCubeSmooth: wCubeSmooth $
         ,  wPosition: wPosition $
         }

;mlocal.minfo = minfo


Widget_Control, wBase, Set_UValue=mLocal
Xmanager, 'metrics', wBase, event_handler='metrics_event',/No_Block

END


