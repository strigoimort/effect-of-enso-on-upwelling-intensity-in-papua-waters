pro compile_climatology_occci
TIC
;====================================================
grid_interval= 0.041666666666657193

latmin=-20
latmax=10
lonmin=95
lonmax=146

image_width = round((lonmax-lonmin)/grid_interval+1)
image_height = round((latmax-latmin)/grid_interval+1)
;stop

;============= RANGE WAKTU ==================
;==================month===============
start_month=1
end_month=12
for month= start_month, end_month do begin
month_st = strtrim(string(month,format='(I2.2)'),2)
;====================================================
chl_monthly_map = fltarr(image_width,image_height)
num_monthly_map = fltarr(image_width,image_height)
num=0.
;==============year===================
start_year=2012
end_year=2012
for year= start_year, end_year do begin
year_st = strtrim(string(year,format='(I4.4)'),2)

;============= MEMBUKA FILE HASIL EKSTRAK BULANAN ==================
;=============masukin data==============
path_input='D:\SKRIPSI\database\occci\la nina\compile monthly\'+year_st+'\chl'+year_st+month_st+'.sav'
datanc= findfile(path_input,count=num_files)
;stop
if num_files gt 0 then begin
for inc=0,num_files-1 do begin

restore,datanc[inc]
indx_chl = where (data_map ne 999., count_index)
;stop
;==================================================

chl_monthly_map[indx_chl] = chl_monthly_map[indx_chl] + data_map[indx_chl]  ; Data yang kurang dari 100 masuk perhitungan
num_monthly_map[indx_chl] = num_monthly_map[indx_chl] + 1 ;jumlah tahunnya brp
num=num+1

;stop
endfor
endif
endfor
;stop
;===================AVERAGING (default)=================
indx_chl_monthly=where(num_monthly_map gt 0,count_indx_chl_monthly)
data_map=fltarr(image_width,image_height)+999.
;stop
data_map[indx_chl_monthly]=chl_monthly_map[indx_chl_monthly]/float(num_monthly_map[indx_chl_monthly]) ;float = numerik desimal
;stop
file_mkdir, 'D:\SKRIPSI\database\occci\la nina\compile climatology\'
path_output='D:\SKRIPSI\database\occci\la nina\compile climatology\chl2012'+month_st+'.sav
save,data_map,filename=path_output
endfor
;stop
print, 'finish'
TOC
stop
end
