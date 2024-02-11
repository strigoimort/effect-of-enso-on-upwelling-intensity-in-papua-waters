function true2lon,rgb
;rgb is array of lonarr(3)
    return,(long(rgb[0]) or ishft(long(rgb[1]),8) or ishft(long(rgb[2]),16))
end
;==============================
pro draw_clim_oisst
TIC
;===========================COLOR===========================
!p.background='ffffff'x
!p.color=0

;===========================BORDER===========================
;!P.Region=[0.02,0.09,0.98,0.98] ;minimal 0 maksimal 1 
;!P.Position=[0.07,0.25,0.96,0.90]

;!P.Region=[0.01,0.01,0.99,0.99] ;minimal 0 maksimal 1
;!P.Position=[0.05,0.01,0.95,0.99]

!P.Region=[0.01,0.01,0.99,0.99] ;minimal 0 maksimal 1
!P.Position=[0.05,0.01,0.95,0.99]

;POSITION BUAT COLORBAR
;!P.Position=[0.03,0.15,0.97,0.98]

;======================colorbar==========================
loadct,33,/silent ;lihat di l3harrisgeospatial
tvlct,r,g,b,/get
rgb1=(long(r) or ishft(long(g),8) or ishft(long(b),16))
rgb2=[[[rgb1 and 'ff'x]],[[ishft(rgb1 and 'ff00'x,-8)]],[[ishft(rgb1 and 'ff0000'x,-16)]]]
;*********************************************************************

xsize=1000 ;ukuran kanvas dalam pixel
ysize=430

;SIZE BUAT YG ADA COLORBAR
;xsize=1000 ;ukuran kanvas dalam pixel
;ysize=550

bar_length=fix(xsize*0.7) ;panjang dari colorbar di bawah peta
rgb3=byte(congrid(rgb2,bar_length,15,3))
;stop
;---------------------------------------data coverage
latmin=-4 
latmax=6
lonmin=130
lonmax=145

;-------image_coverage-------
;latmin_plot = -34 ;selatan
;latmax_plot = -16 ;utara
;lonmin_plot= 101 ;barat
;lonmax_plot= 119 ;timur

;latmin_plot =-4 ;selatan
;latmax_plot =6 ;utara
;lonmin_plot=130 ;barat
;lonmax_plot=145 ;timur

latmin_plot =-4 ;selatan
latmax_plot =2 ;utara
lonmin_plot=130 ;barat
lonmax_plot=145 ;timur

;---spatial_resolution---
grid_interval=0.050003052

;------------data_dimension-------------------
image_width=round((lonmax-lonmin)/grid_interval+1)
image_height=round((latmax-latmin)/grid_interval+1)
;stop
;;*****************************************************************************************************************

;-------------------loop_for_month-------------------------90_ID
start_month=1
end_month=12
for month=start_month,end_month do begin
month_st=strtrim(string(month,format='(I2.2)'),2)

;======================================================
path_input='D:\SKRIPSI\database\ostia\neutral\compile climatology\sst'+month_st+'.sav'  
datanc=findfile(path_input,count=num_ncf)
if num_ncf ne 0 then begin
;stop

;LAYOUTING
restore,path_input
data=data_map
idx= where (data lt 500.)
;stop

;--------menampilkan peta--------
window,0,xsize=xsize,ysize=ysize,/pixmap 
;stop
lon2=lonmin+findgen(round(image_width))*grid_interval
lat2=latmin+findgen(round(image_height))*grid_interval
;stop
map_set,0,180,limit=[latmin_plot,lonmin_plot,latmax_plot,lonmax_plot],/iso

max_value=31;range datanya kl gak 30 31 aja y
min_value=27
;stop
index_max=where((data gt max_value)and(data lt 500),count_max);ketika data nilainya bh bsr drpd max value dan lebih kecil dari 500
if (count_max ne 0)then data[index_max]=max_value ;

index_min=where(data lt min_value,count_min)
if (count_min ne 0)then data[index_min]=min_value
;stop
;**************************************************************************
data[index_max]=max_value
;stop

;---------------------------contour interval
level_interval=0.001 ;interval konturnya, makin kecil makin halus

numlevel=fix((max_value-min_value)/level_interval+1)
col=lonarr(numlevel)
;stop
for e=0,numlevel-1 do begin
  cc=byte(e*level_interval/(max_value-min_value)*255)
  col[e]=true2lon(rgb2[cc,0,*])
endfor

levels=findgen(numlevel)*level_interval+min_value
;stop

;===========kontur====== dimatiin aja kalau cuman mau liat layouting
contour,data,lon2,lat2,/overplot, $
  max_value=max_value, $
  min_value=min_value, $
  levels=levels, $
  /cell_fill, $
  font=1, $
  c_colors=col[indgen(numlevel)]
; 
;stop

;levels =[28.,28.2,28.4,28.6,28.8,29.]
;c_labels=[0,0,0,0,0,0]


levels =[29.5]
c_labels=[1]

contour,data,lon2,lat2,levels=levels,c_labels=c_labels,c_charthick=1.5,c_charsize=1.3,thick=3,/overplot

;===================================================================
map_continents,/coasts,mlinethick=2.5,/hires ;menggambarkan garis pantai
;stop
map_grid,/box_axes,londel=5., latdel=2.,charsize=2.5,charthick=2.5 ;longlat del adalah interval grid
;stop

;================================================================
;tv,rgb3,tr=3,0.15,0.08,/normal ;posisi colorbar, ...,x,y
;======================================================================
;stop

;;===========================COLORBAR===========================
;interval_measure=1 ;interval warna di colorbar
;num_interval=round((max_value-min_value)/interval_measure)
;
;for w=0,num_interval do begin
;  index_value=w*(max_value-min_value)/float(num_interval)+min_value
;  index_plot=string(index_value,format='(F5.1)')
;  x_position=0.142+0.7/num_interval*w
;  y_position=0.03
;  xyouts,x_position,y_position,index_plot,charsize=2.,charthick=2.5,font=1,/normal,alignment=0.5
;
;endfor
;stop

;===========================LAYOUTING===========================
title2='SST '+month_st+' 
XYOUTs,0.12,0.85,title2,/normal,alignment=0.5,charsize=3.5,charthick=1.5,font=1;,color=255 ;judul peta
;XYOUTs,0.5,0.15,'Longitude (!U0!NE)',/normal,alignment=0.5,charsize=3.,charthick=2.5,font=1, color='000000'xl ;tulisan longitude
;XYOUTs,0.09,0.6,'Latitude (!U0!NS)',/normal,alignment=0.5,charsize=3.,charthick=2.5,font=1, orientation=90, color='000000'xl ;tulisan latitude
unit_st='(!U0!NC)'
XYOUTs,0.87,0.08,unit_st,/normal,alignment=0.5,charsize=2.0,charthick=2.0,font=1;,color=255 ;tulisan derajat

;stop
;============================= 'E:\SKRIPSI\pasifik\klorofil\common\'+year_st+'\chl_'+year_st+month_st+'.sav'
file_mkdir, 'D:\SKRIPSI\database\ostia\neutral\draw\
path_output ='D:\SKRIPSI\database\ostia\neutral\draw\sst_'+month_st+'.png'
;stop
;==================================================
T=TVRD(channel=0,true=1,order=0)
write_png,path_output,T
endif
;=========================
;*********************************************************************************

ENDFOR

print,'finish'
;stop
!P.Region=0
!P.Position=0
TOC
end

