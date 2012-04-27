PRO Zoom_Menu_event, ev
END
PRO Zoom_Menu;, mZoom

;
; This procedure is a pop-up menu for the Zoom window
; Options are available for zoom factor and resampling
; type
;


wBase = Widget_Base(/column)

desc = ['1\Zoom', $
           '1\Zoom Factor', $
              '0\2x', $
              '0\4x', $
              '0\8x', $
              '2\16x', $
           '1\Resampler', $
              '0\Nearest Neighbor', $
              '0\Bilinear', $
              '2\Cubic', $
        '0\Close' $
        ]

wMenu = CW_PdMenu(wBase, desc)


Widget_Control, wBase, /realize
xmanager, 'zoom_menu', wbase, Event_Handler='zoom_menu_event'

END
