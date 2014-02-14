;this program test if I can multiply output data to file
pro test_multiple_out

data=intarr(5,2,2)

data(*,0,0)=[1,2,3,4,5]
data(*,1,0)=[2,3,4,5,6]
data(*,0,1)=[3,4,5,6,7]
data(*,1,1)=[5,6,7,8,9]


envi_write_envi_file,data(*,0,*),ns=5,nl=1,nb=2,out_name='test1', r_fid=rfid1
 
envi_write_envi_file,data(*,1,*),ns=5,nl=1,nb=2,out_name='test2', r_fid=rfid2


fid=[rfid1,rfid2]
dims=lonarr(5,2)
pos=[0,1]
dims(*,0)=[-1l,0l,4l,0l,0l]
dims(*,1)=[-1l,0l,4l,1l,1l]  



envi_doit,'CF_DOIT',dims=dims,fid=fid,pos=pos,out_name='test_all',r_fid=rfid_all

envi_file_query,rfid_all, dims=dims_all, ns=ns_all, nl=nl_all,nb=nb_all

end