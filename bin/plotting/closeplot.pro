pro closeplot, title, flag

;
;
;

if (flag ne 0) then begin
  device,/close
  if (flag eq 1) then begin
    device,/close
    spawn, 'grep showpage '+title+'.ps'
    spawn, 'lp -dlw '+title+'.ps'
    spawn, 'rm '+title+'.ps'
  endif
  if (flag eq 1) then begin
    !p.font = -1
  endif
  set_plot,'x'
endif

return
end
