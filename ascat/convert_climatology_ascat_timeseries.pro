;==============================
pro convert_climatology_ascat_timeseries
;==============================
TIC
;-------image_coverage-------
latmin=-5 
latmax=7
lonmin=129
lonmax=146
 
;---spatial_resolution---
grid_interval=0.125
  
;------------data_dimension-------------------
image_width=round((lonmax-lonmin)/grid_interval)
image_height=round((latmax-latmin)/grid_interval+1)
count_msst=0
;stop
  
;-------------------loop_for_month-------------------------90_ID
start_month=1
end_month=12
for month=start_month,end_month do begin
month_st=strtrim(string(month,format='(I2.2)'),2)
;======================================================
path_input3='D:\SKRIPSI\database\ascat\neutral\compile climatology\ugd\ugd2020_'+month_st+'.sav'
;path_input3='D:\SKRIPSI\database\ascat\neutral\compile monthly\ugd\2020\ugd_2020'+month_st+'.sav'
restore,path_input3
u_map=data_map
;u_map=ugd
restore,'D:\SKRIPSI\database\ascat\neutral\compile climatology\vgd\vgd2020_'+month_st+'.sav
;restore,'D:\SKRIPSI\database\ascat\neutral\compile monthly\vgd\2020\vgd_2020'+month_st+'.sav
v_map=data_map
;v_map=vgd
;ws=sqrt(u_map^2+v_map^2)
;ws=u_map+v_map
ws=-1*((sin(68)*v_map)+(cos(180+68)*u_map))
;stop

;=======================================case1
nama1='titik 1'
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
latmin_cut1=-1.5
lonmin_cut1=138
latmax_cut1=-1
lonmax_cut1=138.5

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
;latmin_cut1=-3
;lonmin_cut1=142
;latmax_cut1=-2.5
;lonmax_cut1=142.5

a1 = fix((lonmin_cut1-lonmin)/grid_interval)
b1 = fix((lonmax_cut1-lonmin)/grid_interval)
c1 = fix((latmin_cut1-latmin)/grid_interval)
d1 = fix((latmax_cut1-latmin)/grid_interval)

;=======================================no case
;latmin_cut1=latmin
;lonmin_cut1=lonmin
;latmax_cut1=latmax
;lonmax_cut1=lonmax
;a1 = fix((lonmin_cut1-lonmin)/grid_interval)
;b1 = fix((lonmax_cut1-lonmin)/grid_interval)
;c1 = fix((latmin_cut1-latmin)/grid_interval)
;d1 = fix((latmax_cut1-latmin)/grid_interval)

;stop
ws21= ws[a1:b1,c1:d1]

;stop
indx_ws1=where(ws21 lt 999.0)
ws_mean1=mean(ws21[indx_ws1])
;stop
if(count_msst eq 0) then begin
  dataset1=[ws_mean1,month]
endif else begin
  dataset1=[[dataset1],[ws_mean1,month]]
endelse
;stop
count_msst=count_msst+1
;stop
endfor
;stop
;===========================================================================
file_mkdir,'D:\SKRIPSI\database\ascat\neutral\timeseries2\'
;===========================================================================
path_output1='D:\SKRIPSI\database\ascat\neutral\timeseries2\timeseries ascat neutral 1 2020.txt'
format1='(2F15.5)'
openw,3,path_output1
printf,3,dataset1, format=format1
close,3
;===========================================================================
TOC
print,'finish'
stop
end