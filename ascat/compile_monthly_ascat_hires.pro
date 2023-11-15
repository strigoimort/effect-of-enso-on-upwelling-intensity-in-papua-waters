pro compile_monthly_ascat_hires
TIC

;-------image_coverage-------
latmin=-5 
latmax=7
lonmin=129
lonmax=146

;---spatial_resolution---
grid_interval=0.125

;------------data_dimension-------------------
image_width=round((lonmax-lonmin)/grid_interval);136
image_height=round((latmax-latmin)/grid_interval+1);97
;stop

start_year=2007
end_year=2020
for year=start_year,end_year do begin
year_st=strtrim(string(year,format='(I4.4)'),2)

start_month=1
end_month=12
for month=start_month,end_month do begin
month_st=strtrim(string(month,format='(I2.2)'),2)

;----initial_condition_for_calculating_monthly_compilation---
U_monthly_map=fltarr(image_width,image_height)
U_num_monthly_map=fltarr(image_width,image_height)
v_monthly_map=fltarr(image_width,image_height)
v_num_monthly_map=fltarr(image_width,image_height)

path_input3='D:\SKRIPSI\database\ascat\neutral\ugd\'+year_st+'\'+month_st+'\ugd_*.sav
datanc3=findfile(path_input3,count=num_ncf3)
if num_ncf3 gt 0 then begin
for inc3=0,num_ncf3-1 do begin

pos_filename3=strpos(datanc3[inc3],'\ugd_')
filename3=strtrim(strmid(datanc3[inc3],pos_filename3+5,16),2)
print, filename3
;stop

restore, datanc3[inc3]
emtx=data_map
restore,'D:\SKRIPSI\database\ascat\neutral\vgd\'+year_st+'\'+month_st+'\vgd_'+filename3
emty=data_map

;--------------------SST-----------------
indx_u=where(emtx lt 900.,count_u)
indx_v=where(emty lt 900.,count_v)
;stop

;================default_for_monthly_mean_calculation=========
u_monthly_map[indx_u]=u_monthly_map[indx_u]+emtx[indx_u]
u_num_monthly_map[indx_u]=u_num_monthly_map[indx_u]+1

v_monthly_map[indx_v]=v_monthly_map[indx_v]+emty[indx_v]
v_num_monthly_map[indx_v]=v_num_monthly_map[indx_v]+1
;stop

endfor

;*******************AVERAGING (default)****************
indx_u_monthly=where(u_num_monthly_map gt 0.,count_indx_u_monthly)

monthly_map_u=fltarr(image_width,image_height)+999.
;stop
monthly_map_u[indx_u_monthly]=u_monthly_map[indx_u_monthly]/float(u_num_monthly_map[indx_u_monthly])

indx_v_monthly=where(v_num_monthly_map gt 0.,count_indx_v_monthly)

monthly_map_v=fltarr(image_width,image_height)+999.
;stop
monthly_map_v[indx_v_monthly]=v_monthly_map[indx_v_monthly]/float(v_num_monthly_map[indx_v_monthly])
stop

file_mkdir,'D:\SKRIPSI\database\ascat\compile monthly\ugd\'+year_st+'
file_mkdir,'D:\SKRIPSI\database\ascat\compile monthly\vgd\'+year_st+'
save, monthly_map_u, filename ='D:\SKRIPSI\database\ascat\compile monthly\ugd\'+year_st+'\ugd_'+year_st+month_st+'.sav'
save, monthly_map_v, filename ='D:\SKRIPSI\database\ascat\compile monthly\vgd\'+year_st+'\vgd_'+year_st+month_st+'.sav'
print,year,month

endif
endfor
endfor 
TOC
print,'finish'
stop

!P.Region=0
!P.Position=0

end

