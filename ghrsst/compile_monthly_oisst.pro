pro compile_monthly_oisst                      
TIC
;====================================================
grid_interval= 0.087890625

latmin=-4 
latmax=6
lonmin=130
lonmax=145

image_width = round((lonmax-lonmin)/grid_interval+1)       
image_height = round((latmax-latmin)/grid_interval+1)
;stop   

;==============LOOPING===================
;==============year===================
start_year=2007
end_year=2020
for year= start_year, end_year do begin
year_st = strtrim(string(year,format='(I4.4)'),2)

;==================month===============
start_month=1
end_month=12
for month= start_month, end_month do begin
month_st = strtrim(string(month,format='(I2.2)'),2)

;====================ARRAY================================
SST_monthly_map = fltarr(image_width,image_height)          
num_monthly_map = fltarr(image_width,image_height)
num=0.
;stop

;=============masukin data==============
path_input='D:\SKRIPSI\database\ghrsst\neutral\extract dialy\'+year_st+'\'+month_st+'\sst'+year_st+month_st+'*.sav' 
;stop'  
datanc= findfile(path_input,count=num_files)   
stop
if num_files gt 0 then begin
for inc=0,num_files-1 do begin

restore,datanc[inc]
indx_sst = where (data_map ne 999., count_index) ;ini untuk data kosong    
;stop
;==================================================

SST_monthly_map[indx_sst] = SST_monthly_map[indx_sst] + data_map[indx_sst]  
num_monthly_map[indx_sst] = num_monthly_map[indx_sst] + 1
num=num+1

;stop
endfor
endif
;===================AVERAGING (default)=================
indx_sst_monthly=where(num_monthly_map gt 0,count_indx_sst_monthly)
data_map=fltarr(image_width,image_height)+999.
;stop
data_map[indx_sst_monthly]=SST_monthly_map[indx_sst_monthly]/float(num_monthly_map[indx_sst_monthly]) ;float = numerik desimal
;stop
file_mkdir, 'D:\SKRIPSI\database\ghrsst\compile monthly\'+year_st+'\'
path_output='D:\SKRIPSI\database\ghrsst\compile monthly\'+year_st+'\sst'+year_st+month_st+'.sav
save,DATA_MAP,filename=path_output

endfor
endfor
;stop
print, 'finish'
TOC
stop
end
