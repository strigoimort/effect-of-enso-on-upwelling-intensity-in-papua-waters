pro convert_clim_occci
TIC
;-------image_coverage-------
latmin=-20
latmax=10
lonmin=95
lonmax=146
;======================
;---spatial_resolution---
grid_interval=0.041666666666657193
;------------data_dimension-------------------
image_width=round((lonmax-lonmin)/grid_interval+1)
image_height=round((latmax-latmin)/grid_interval+1)
count_mchl=0
;stop
;*****************************************************************************************************************
;-------------------loop_for_month-------------------------90_ID
;start_day=1
;end_day=31
;for day= start_day, end_day do begin
;day_st = strtrim(string(day,format='(I2.2)'),2)

start_month=1
end_month=12
for month=start_month,end_month do begin
month_st=strtrim(string(month,format='(I2.2)'),2)

;start_year=2020
;end_year=2020
;for year= start_year, end_year do begin
;year_st = strtrim(string(year,format='(I4.4)'),2)

;======================================================
;path_input3='D:\SKRIPSI\database\occci\neutral\compile climatology\chl'+month_st+'.sav'
;path_input3='D:\SKRIPSI\database\occci\el nino\compile climatology\chl2020'+month_st+'.sav'
;path_input3='D:\SKRIPSI\database\occci\la nina\compile climatology\chl2020'+month_st+'.sav'
;path_input3='E:\dwy\Compile Monthly\'+year_st+'\chl'+year_st+month_st+'.sav'
;path_input3='E:\dwy\Compile Climatology\chl'+month_st+'.sav'
path_input3='D:\SKRIPSI\database\occci\neutral\compile monthly\2020\chl2020'+month_st+'.sav'

restore,path_input3
chl_map=data_map
;stop
;==================
nama1='Perairan Utara Papua'
;Pak Anin
;latmin_cut1=-4
;lonmin_cut1=137
;latmax_cut1=-2
;lonmax_cut1=145

;Stasiun A
;latmin_cut1=-2
;lonmin_cut1=137.5
;latmax_cut1=-0.5
;lonmax_cut1=139

;Stasiun B
;latmin_cut1=-2.5
;lonmin_cut1=132.5
;latmax_cut1=-1
;lonmax_cut1=140

;;Stasiun C
;latmin_cut1=-4
;lonmin_cut1=143.5
;latmax_cut1=-2.5
;lonmax_cut1=145

;============
;Stasiun 1
;latmin_cut1=-1.5
;lonmin_cut1=138
;latmax_cut1=-1
;lonmax_cut1=138.5

;Stasiun 2
;latmin_cut1=-2.5
;lonmin_cut1=141.5
;latmax_cut1=-2
;lonmax_cut1=142

;Stasiun 3
;latmin_cut1=-3.75
;lonmin_cut1=144
;latmax_cut1=-3.25
;lonmax_cut1=144.5

;Stasiun 4
;latmin_cut1=-3
;lonmin_cut1=144
;latmax_cut1=-2.5
;lonmax_cut1=144.5

;Stasiun 5
;latmin_cut1=-3
;lonmin_cut1=143
;latmax_cut1=-2.5
;lonmax_cut1=143.5

;Stasiun 6
latmin_cut1=-3
lonmin_cut1=142
latmax_cut1=-2.5
lonmax_cut1=142.5

;=======================================
a1 = fix ((lonmin_cut1-lonmin)/grid_interval)
b1 = fix ((lonmax_cut1-lonmin)/grid_interval)
c1 = fix ((latmin_cut1-latmin)/grid_interval)
d1 = fix ((latmax_cut1-latmin)/grid_interval)
;stop
chl_map21= chl_map[a1:b1,c1:d1]
;stop
;======================================= 1
;stop
indx_chl1=where(chl_map21 lt 999.0)
chl_mean1=mean(chl_map21[indx_chl1])
;stop
;=======================================
;stop
;if(count_mchl eq 0) then begin
;dataset1=[chl_mean1,month]
;endif else begin
;dataset1=[[dataset1],[chl_mean1,month]]
;endelse

if(count_mchl eq 0) then begin
  dataset1=[chl_mean1,month]
endif else begin
  dataset1=[[dataset1],[chl_mean1,month]]
endelse

;stop
count_mchl=count_mchl+1
;stop
;endfor
;endfor
endfor
;stop
;===========================================================================
file_mkdir,'D:\SKRIPSI\database\occci\neutral\timeseries'
;file_mkdir,'D:\SKRIPSI\database\occci\el nino\timeseries'
;file_mkdir,'D:\SKRIPSI\database\occci\la nina\timeseries'
;path_output1='D:\SKRIPSI\database\occci\neutral\timeseries\timeseries occci neutral 6 2020.txt'
;path_output1='D:\SKRIPSI\database\occci\el nino\timeseries\timeseries occci el nino 2020 c.txt'
;path_output1='D:\SKRIPSI\database\occci\la nina\timeseries\timeseries occci la nina 2020 c.txt'

file_mkdir,'D:\SKRIPSI'
path_output1='D:\SKRIPSI\0.txt'

format1='(2F15.5)'
openw,3,path_output1
printf,3,dataset1, format=format1
close,3
;===========================================================================
TOC
print,'finish'
stop
end
