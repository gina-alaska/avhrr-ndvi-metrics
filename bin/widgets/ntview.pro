PRO NTView

MosInfo = OsInfo()
mFont = FontGen()
FieldFont = mFont.mono10m
FileWidth = 33
FieldWidth = 4



;
;  Create Mother of all Bases
;
      wBase = Widget_Base(Title="NDVI vs. Temperature Viewer", $ 
                      /base_align_center, /column)

;
;  Create sub-base for image information
;
      wLabel = Widget_Label(wBase, Value='Image Info')
      wBaseImage = Widget_Base(wBase, /Column, /Frame)

;
;  Create file selection compound widget
;
      WFFImage = CW_File(wBaseImage, FileLabel="Image", FieldWidth=FileWidth,$
                   /Row, Filter='*.img');, event=wBase)

      wBaseIInfo = Widget_Base(wBaseImage, Row=2)

;
;  Create sub-sub-base for input lines/samples/bands info
;
      wBaseILSB = Widget_Base(wBaseIInfo, /Row)

      wFINSamp = CW_Field(wBaseILSB, Title="#Samples", Value=512, $
                          XSize=FieldWidth, /Row)
      wFINLine = CW_Field(wBaseILSB, Title="#Lines", Value=512, $
                          XSize=FieldWidth, /Row)
      wFINBand = CW_Field(wBaseILSB, Title="#Bands", Value=10, $
                          XSize=FieldWidth, /Row)
;
;   Create sub-sub-base for input data type
;
      wBaseIDt = Widget_Base(wBaseImage, /Row)
      wLIDT = Widget_Label(wBaseIDT, Value="Data Type:")
      asText = ["Byte ", "I*2  ", "I*4  ", "R*4  "]
      wBGIDT = CW_BGROUP(wBaseIDT, asText,  $
           /Exclusive, /Row, Set_Value=1, ids=awBGIDTIds)
      
; Desensitize data types that are currently unavailable
      FOR lCount = 2, (N_Elements(awBGIDTIds)-1) DO $ 
         Widget_Control, awBGIDTIds(lCount), Sensitive=0


;
;   Create sub-sub-base for band 1 & 2 radiance or reflectance
;

      wBaseRR = Widget_Base(wBaseImage, /Row)
      wLRR = Widget_Label(wBaseRR, Value="Bands 1 & 2:")
      asText = ["Radiance", "Reflectance"]
      wBGRR = CW_BGroup(wBaseRR, asText, $
          /Exclusive, /Row, Set_Value=1, ids=awBGRRIds)
 

;
;  Get geometry for prior su-base, use to size button group
;
      mGeo = Widget_Info(wBaseImage, /Geometry)

;
;  Create sub-sub-base for Dimensions/Load buttons
;
      asText = ["Dimensions...", "Load"]
      wBGDL = CW_BGroup2(wBaseImage, asText,/Row, $
              ButtonSize=mGeo.XSize/N_Elements(asText) - $
              mOsInfo.mBuffer.button)

;
;   Create sub-base for band view information
;
      ;wLabel = Widget_Label(wBase, Value='View:')
      wBaseBV = Widget_Base(wBase, Column=2)
      asText=["Band 1", "Band 2","Temperature 3","Temperature 4",$
              "Temperature 5", "NDVI","Satellite Zenith","Solar Zenith", $
              "Relative Azimuth","Time"];, "Empty","Cloud"]
      wLabel = Widget_Label(wBaseBV, Value='Bands:')
      wBGBV=CW_BGroup2(wBaseBV, asText,Column=2, /NonExclusive,  /Frame, $
               UValue=N_Elements(asText),ids=awBGBVIds )
      aBGBVText = asText

      asText=["NDVI vs T", "T4 vs T5","T3","T4","T5"]
      wLabel = Widget_Label(wBaseBV, Value='Plots:')
      wBGPV=CW_BGroup(wBaseBV, asText,Column=1, /NonExclusive, /Frame)

;
;   Get geometry for prior su-base, use to size button group
;
      mGeo = Widget_Info(wBase, /Geometry)


;
;  Create sub-sub-base for Dimensions/Load buttons
;
      asText = ["Done", "Cancel"]
      wBGDC = CW_BGroup2(wBase, asText,/Row, $
        ButtonSize=mGeo.XSize/N_Elements(asText) - $
        mOsInfo.mBuffer.button)

;
;  Pop-up dialog for Dimensions button
;
      wBaseSize = Widget_Base(Title='Dimensions', /Column, $
                     Group_Leader=wBase)
      wLabelSize = Widget_Label(wBaseSize, Value='FileName')

      wListSize = Widget_List(wBaseSize, XSize=16, YSize=10)
      mGeo = Widget_Info(wBaseSize, /Geometry)
      asText = ['Done', 'Cancel']
      wBGSize = CW_BGroup2(wBaseSize, asText, /Row, $
                   ButtonSize=mGeo.Xsize/N_Elements(asText) - $
                   mOsInfo.mBuffer.button)
      Widget_Control, wBaseSize, Event_Pro='NTViewList_event',$
                   Set_UValue={wParentBase:wBase, wListSize: wListSize, $
                   wBGSize: wBGSize}




;
;  Desensitize Band View and Plot View Buttons
;
      Widget_Control, wBGBV, Sensitive=0
      Widget_Control, wBGPV, Sensitive=0

;
;  Set up image structure
;
      mImage = {$
                aImage: -1L, $
                lSamp:  -1L, $
                lLine:  -1L, $
                lBand:  -1L, $
                lDataType: -1L, $
                lRadRefType: -1L, $
                aBandNames: -1L $
               }

;
;  Set up structure to be passed to event handler
;
      mLocal = {$
           wBase: wBase, $
           wFFImage: wFFImage, $
           wFINSamp: wFINSamp, $
           wFINLine: wFINLine, $
           wFINBand: wFINBand, $
           wBGIDT: wBGIDT, $
           wBGRR: wBGRR, $
           wBGDL: wBGDL, $
           wBGBV: wBGBV, $
           aBGBVText: aBGBVText, $
           wBGPV: wBGPV, $
           wBGDC: wBGDC, $
           wBaseSize: wBaseSize, $
           wLabelSize: wLabelSize, $
           wListSize: wListSize, $
           wBGSize: wBGSize, $
           wChildBase: -1L, $
           awChildBase: LonArr(12) - 1L, $
           mImage: mImage, $
           lPixID: -1L $
            }


;
;  Realize the application window - set the UValue
;
      Widget_Control, wBase, /Realize, Set_UValue=mLocal, /No_Copy

;
;  Call the XManager
;
      XManager, 'NTView', wBase, No_Block=No_Block

END
