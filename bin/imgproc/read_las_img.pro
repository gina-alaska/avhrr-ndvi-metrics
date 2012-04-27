; program to select & read a .img file
pro read_las_img

  imgfile = dialog_pickfile(filter="*.img")
  print,'img ',imgfile
  ddrfile = str_sep(imgfile,".img") + ".ddr"
  print,'ddr ',ddrfile(0)
  read_las_ddr,ddrfile(0),nb,nl,ns

  openr, lun, imgfile, /get_lun

  img = bytarr(ns,nl)
  readu, lun, img

  window,/free,xsize=ns,ysize=nl,retain=2
  tv, img

  close,lun
  free_lun,lun

end
