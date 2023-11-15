pro extract_daily_ascat_hires

path_list='D:\SKRIPSI\vault\data\ascat\*.nc'
datafiles=findfile(path_list,count=num_files)
;stop

if num_files gt 0 then begin
for x=0,num_files-1 do begin
  pos_filename=strpos(datafiles[x],'_12_')
  sign=strtrim(strmid(datafiles[x],pos_filename+4,3),2)

fid=NCDF_OPEN(datafiles[x])
varnames = ncdf_vardir(fid)
;stop

NCDF_VARGET, fid,0,eastward_wind
NCDF_VARGET, fid,1,time
NCDF_VARGET, fid,2,lat
NCDF_VARGET, fid,3,lon
NCDF_VARGET, fid,4,northward_wind
;stop

lonmin=min(lon)
latmin=min(lat)
grid_interval=(lon[1]-lon[0]) ;0.125
;stop

dimens=size(northward_wind,/dim) ;(136,97)
widht=dimens[0]
height=dimens[1]
;stop

attnames = ncdf_attdir(fid,'eastward_wind');-
;stop

NCDF_ATTGET,fid,'eastward_wind','scale_factor',scale_factor1
NCDF_ATTGET,fid,'eastward_wind','add_offset',add_offset1
NCDF_ATTGET,fid,'eastward_wind','_FillValue',_FillValue1
NCDF_ATTGET,fid,'eastward_wind','missing_value',missing_value1
NCDF_ATTGET,fid,'eastward_wind','units',units1
NCDF_ATTGET,fid,'eastward_wind','long_name',long_name1

NCDF_ATTGET,fid,'northward_wind','scale_factor',scale_factor2
NCDF_ATTGET,fid,'northward_wind','add_offset',add_offset2
NCDF_ATTGET,fid,'northward_wind','_FillValue',_FillValue2
NCDF_ATTGET,fid,'northward_wind','missing_value',missing_value2
NCDF_ATTGET,fid,'northward_wind','units',units2
NCDF_ATTGET,fid,'northward_wind','long_name',long_name2

attnames = ncdf_attdir(fid,'time');-
NCDF_ATTGET,fid,'time','units',units
NCDF_CLOSE,fid
;stop

ugd=northward_wind*scale_factor1+add_offset1
vgd=eastward_wind*scale_factor2+add_offset2
speed=sqrt(ugd^2+vgd^2)
idx= where(speed gt 100, count1)
ugd[idx]=999.
vgd[idx]=999.

time_length= size(time,/dim)
time_length=time_length[0]
count_time=0
;stop

for num_time=0,time_length-1 do begin
juldate=julday(1,1,1990,0,0,0+time[num_time])
caldat,juldate,month,day,year
print,year,month,day
;stop

year_st=strtrim(string(year,format='(I4.4)'),2)
month_st=strtrim(string(month,format='(I2.2)'),2)
day_st=strtrim(string(day,format='(I2.2)'),2)
stop

data_map= ugd[*,*,num_time]
file_mkdir, 'D:\SKRIPSI\database\ascat\ugd\'+year_st+'\'+month_st
save,data_map,filename='D:\SKRIPSI\database\ascat\ugd\'+year_st+'\'+month_st+'\ugd_'+year_st+month_st+day_st+'_'+sign+'.sav'
data_map= vgd[*,*,num_time]
file_mkdir, 'D:\SKRIPSI\database\ascat\vgd\'+year_st+'\'+month_st
save,data_map,filename='D:\SKRIPSI\database\ascat\vgd\'+year_st+'\'+month_st+'\vgd_'+year_st+month_st+day_st+'_'+sign+'.sav'
;stop

endfor
endfor
endif

;stop

;==========================================================1000
;===================end of pro
print,'finished'
stop
;================================reset the system parameter
!P.Region=0
!P.Position=0

end


