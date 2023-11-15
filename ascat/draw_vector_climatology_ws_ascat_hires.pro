function true2lon,rgb
;rgb is array of lonarr(3)
    return,(long(rgb[0]) or ishft(long(rgb[1]),8) or ishft(long(rgb[2]),16))
end
;===========================================================================
pro draw_vector_climatology_ws_ascat_hires
tic
;===========================================================================
;-----------background_color------------
!p.background='ffffff'x ;---putih---
!p.color=0 ;---hitam---
;---------------------------------------
;----------window_region---------
;!P.Region=[0.02,0.09,0.98,0.98] 
;!P.Position=[0.07,0.25,0.96,0.90]

;!P.Region=[0.01,0.01,0.99,0.99] ;minimal 0 maksimal 1 (atas bawah kanan kiri)
;!P.Position=[0.05,0.01,0.95,0.99]

!P.Region=[0.01,0.01,0.99,0.99] ;minimal 0 maksimal 1 (atas bawah kanan kiri)
!P.Position=[0.05,0.01,0.95,0.99]
;
;!P.Position=[0.03,0.15,0.97,0.98]
;--------------------------------
;---window_pixels---
xsize=1000
ysize=430
;**************************************************************************************
;-------image_coverage-------
latmin=-5 
latmax=7
lonmin=129
lonmax=146
;===========================================================================
grid_interval =0.125
;===========================================================================
widht = round((lonmax-lonmin)/grid_interval)
height = round((latmax-latmin)/grid_interval+1)
;===========================================================================
lon=lonmin+findgen(round(widht))*grid_interval
lat=latmin+findgen(round(height))*grid_interval
;stop
;===========================================================================
;;------------ploting image
;Indonesia
latmin_cut =-4
latmax_cut =2
lonmin_cut =130
lonmax_cut =145
;===========================================================================
;stop
widht2 = round((lonmax-lonmin_cut)/grid_interval +1)
height2 = round((latmax-latmin_cut)/grid_interval +1)
lon2=lonmin+findgen(round(widht2))*grid_interval
lat2=latmin+findgen(round(height2))*grid_interval
;===========================================================================
lat_map=fltarr(widht,height)
for i=0,widht-1 do begin
lat_map[i,*]=lat
endfor

lon_map=fltarr(widht,height)
for i=0,height-1 do begin
lon_map[*,i]=lon
endfor
;===========================================================================
;------------------------------color_table_default-----------------------------------------
loadct,33,/silent
tvlct,r,g,b,/get
rgb1=(long(r) or ishft(long(g),8) or ishft(long(b),16))
rgb2=[[[rgb1 and 'ff'x]],[[ishft(rgb1 and 'ff00'x,-8)]],[[ishft(rgb1 and 'ff0000'x,-16)]]]

bar_length=fix(xsize*0.7)
rgb3=byte(congrid(rgb2,bar_length,15,3))
;========================================
start_month=1
end_month=12
for month=start_month,end_month do begin
month_st=strtrim(string(month,format='(I2.2)'),2)
;========================================
path_input3='D:\SKRIPSI\database\ascat\neutral\compile climatology\ugd\ugd_'+month_st+'.sav'
;===========================================================================
restore,path_input3
map_u=data_map
;stop
;===========================================================================
path_input4='D:\SKRIPSI\database\ascat\neutral\compile climatology\vgd\vgd_'+month_st+'.sav'
restore,path_input4
map_v=data_map
;===========================================================================
ws = sqrt(map_u^2+map_v^2)
;stop
;===========================================================================
window,0,xsize=xsize,ysize=ysize;,/pixmap
map_set,limit = [latmin_cut, lonmin_cut, latmax_cut, lonmax_cut],/iso
;===========================================================================
ws_map=ws
;===========================================================================
ws_map2 = ws_map;[a:b,c:d]
ws_map3 = ws_map2
;===========================================================================
idx = where(ws_map gt 0.01 and ws_map lt 10,countt)
speed=mean(ws_map[idx])
;===========================================================================
max_value=5.
min_value=0.
;===========================================================================
idx_low = where (ws_map2 le min_value)
idx_high = where (ws_map2 ge max_value and ws_map2 lt 200)
;===========================================================================
ws_map2[idx_low] = min_value
ws_map2[idx_high] = max_value
;===========================================================================
level_interval = 0.1
;===========================================================================
;-------------default_4_contour_level-----------------
numlevel=fix((max_value-min_value)/level_interval+1)
col=lonarr(numlevel)

for c=0,numlevel-1 do begin
cc=byte(c*level_interval/(max_value-min_value)*255)
col[c]=true2lon(rgb2[cc,0,*])
endfor
;=========================================================
;-------------array_4_contour_interval-------------
levels=findgen(numlevel)*level_interval+min_value
;----contour_interval----
level_interval = 0.001
;-------------default_4_contour_level-----------------
numlevel=fix((max_value-min_value)/level_interval+1)
col=lonarr(numlevel)

for c=0,numlevel-1 do begin
cc=byte(c*level_interval/(max_value-min_value)*255)
col[c]=true2lon(rgb2[cc,0,*])
endfor
;=========================================================
;-------------array_4_contour_interval-------------
levels=findgen(numlevel)*level_interval+min_value
;===================================================
;---------------------------------land_layout---------------------------------------
map_continents,/coasts,mlinethick = 2., /hires;, color ='7f7f7f'xl,fill_continents=0
map_grid,/box_axes, londel=5, latdel=2, charsize = 2.3, charthick = 2.5, /label
;-----------------------------------------------------------------------------------
;============================================
;-----color_legend_&_position------
;tv,rgb3, tr=3,0.15,0.08, /normal

;-----interval_value_legend-----
num_interval=5
;=========================================================
;-------------------------loop_legend---------------------------
;for w=0,num_interval do begin
;  index_value=w*(max_value-min_value)/float(num_interval)+min_value
;  index_plot=string(index_value,format='(F5.1)')
;  x_position=0.142+0.7/num_interval*w
;  y_position=0.03
;  xyouts,x_position,y_position,index_plot,charsize=2.,charthick=2.,font=1,/normal,alignment=0.5
;endfor
;;===============================================================
ws_unit='(m/s)'
;XYOUTs,0.91,0.05,ws_unit,/normal,alignment=0.1,charsize=2.5,charthick=2,font=1
;stop
;sampling=8
;sampling=2 ;yg bagus
sampling = 4
width2=round(widht/sampling)
height2=round(height/sampling)
map_u=congrid(map_u,width2,height2)
map_v=congrid(map_v,width2,height2)
lon_map=congrid(lon_map,width2,height2)
lat_map=congrid(lat_map,width2,height2)

u_array=reform(map_u,width2*height2)
v_array=reform(map_v,width2*height2)
lat_array=reform(lat_map,width2*height2)
lon_array=reform(lon_map,width2*height2)
;stop

in= where(u_array lt 50, count_in)
if count_in ne 0 then begin
u_array= u_array[in]
v_array= v_array[in]
lat_array= lat_array[in]
lon_array= lon_array[in]
endif
;===========================================================================
index=where((lat_array ge latmin_cut)and(lat_array le latmax_cut)and $
      (lon_array ge lonmin_cut)and(lon_array le lonmax_cut),count)

u_array=u_array[index]
v_array=v_array[index]
lat_array=lat_array[index]
lon_array=lon_array[index]

;yg bener
;my_varrows,u_array,v_array,lon_array,lat_array,rgb2, Length =0.8 ,Title = title, $
;        Color='666666'x,Thick=1,mag_ref=max_value, $
;        min_value=min_value;,/monotone
        
      my_varrows,u_array,v_array,lon_array,lat_array,rgb2, Length =1 ,Title = title, $
        Color='666666'x,Thick=2,mag_ref=max_value, $
        min_value=min_value;,/monotone

;my_gtopo30plot_max1000_westpac3,latmin_cut,lonmin_cut,latmax_cut,lonmax_cut,xsize,charsize=2.,symsize=1,colorbar=1  
;===========================================================================       
XYOUTs,0.13, 0.85, 'WIND '+month_st, /normal,alignment=0.5,charsize=2.9, charthick=2.5;, font=1
;XYOUTs,0.5,0.15,'Longitude (!U0!NE)',/normal,alignment=0.5,charsize=2.5,charthick=2,font=1, color='000000'xl
;XYOUTs,0.09,0.6,'Latitude (!U0!NN)',/normal,alignment=0.5,charsize=2.5,charthick=2,font=1, orientation=90, color='000000'xl
;XYOUTs, 0.88, 0.08, ws_unit,  /normal,alignment=0.5,charsize=2., charthick=2., font=1

;===========================================================================
;stop
file_mkdir, 'D:\SKRIPSI\database\ascat\neutral\draw coba lg'
path_output='D:\SKRIPSI\database\ascat\neutral\draw coba lg\wind_'+month_st+'.png'
T=TVRD(channel=0,true=1,order=0)
write_png,path_output,T
;===============================================================
endfor 
print,'finish'
;===============================================================
!P.Region=0
!P.Position=0
;===============================================================
toc
end

;------------program_is_done!-----------
