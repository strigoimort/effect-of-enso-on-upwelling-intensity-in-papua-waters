;==============================
pro convert_climatology_oisst
;==============================
TIC
;-------image_coverage-------
latmin=-4 
latmax=6
lonmin=130
lonmax=145
;======================
;---spatial_resolution---
grid_interval=0.087890625
;------------data_dimension-------------------
image_width=round((lonmax-lonmin)/grid_interval+1)
image_height=round((latmax-latmin)/grid_interval+1)
count_msst=0
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
;path_input3='D:\SKRIPSI\database\ghrsst\neutral\compile climatology\sst'+month_st+'.sav'
;path_input3='D:\SKRIPSI\database\ghrsst\el nino\compile climatology\sst2020'+month_st+'.sav'
;path_input3='D:\SKRIPSI\database\ghrsst\la nina\compile climatology\sst2020'+month_st+'.sav'
;path_input3='E:\dwy\Compile Monthly\'+year_st+'\sst'+year_st+month_st+'.sav'
;path_input3='E:\dwy\Compile Climatology\sst'+month_st+'.sav'
path_input3='D:\SKRIPSI\database\ghrsst\neutral\compile monthly\2020\sst2020'+month_st+'.sav'

restore,path_input3
sst_map=data_map
;stop
;==================case1 TOMINI
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

;Stasiun C
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
sst_map21= sst_map[a1:b1,c1:d1]
;stop
;======================================= 1
;stop
indx_sst1=where(sst_map21 lt 999.0)
SSt_mean1=mean(sst_map21[indx_sst1])
;stop
;=======================================
;stop
;if(count_msst eq 0) then begin
;dataset1=[sst_mean1,month]
;endif else begin
;dataset1=[[dataset1],[sst_mean1,month]]
;endelse

if(count_msst eq 0) then begin
  dataset1=[sst_mean1,month]
endif else begin
  dataset1=[[dataset1],[sst_mean1,month]]
endelse

;stop
count_msst=count_msst+1
;stop
;endfor
;endfor
endfor
;stop
;===========================================================================
file_mkdir,'D:\SKRIPSI\database\ghrsst\neutral\timeseries'
;file_mkdir,'D:\SKRIPSI\database\ghrsst\el nino\timeseries'
;file_mkdir,'D:\SKRIPSI\database\ghrsst\la nina\timeseries'
path_output1='D:\SKRIPSI\database\ghrsst\neutral\timeseries\timeseries ghrsst neutral 6 2020.txt'
;path_output1='D:\SKRIPSI\database\ghrsst\el nino\timeseries\timeseries ghrsst el nino 2020 c.txt'
;path_output1='D:\SKRIPSI\database\ghrsst\la nina\timeseries\timeseries ghrsst la nina 2020 c.txt'

format1='(2F15.5)'
openw,3,path_output1
printf,3,dataset1, format=format1
close,3
;===========================================================================
TOC
print,'finish'
stop
end

