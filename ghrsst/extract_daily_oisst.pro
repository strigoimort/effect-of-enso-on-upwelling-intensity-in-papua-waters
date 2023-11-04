pro extract_daily_oisst                                       ;Nama filenya, Nama file harus sama dengan *.pro bila tidak sama akan Error

;===========================COORDINATE=================================
;-----------------cut area coordinate------------------------
TIC
latmin_cut=-4
latmax_cut=6
lonmin_cut=130
lonmax_cut=145
;stop

;===========================LOOPING=================================
;--------------------loop_for_year--------------------------
start_year=2007  
end_year=2020    
for year= start_year, end_year do begin 
year_st = strtrim(string(year,format='(I4.4)'),2) ;I4 artinya berapa digit tahunnya, strtrim untuk menghapus karakter spasi di depan nama, dan string untuk mengubah menjadi digit angka

;--------------------loop_for_month-------------------------
start_month=1
end_month=12
for month= start_month, end_month do begin
month_st = strtrim(string(month,format='(I2.2)'),2) ;I2 berarti berapa digit bulannya

;--------------------loop_for_day-------------------------
start_day=1
end_day=31
for day= start_day, end_day do begin
day_st = strtrim(string(day,format='(I2.2)'),2) ;I2 berapa digit harinya

;===========================PATH_INTPUT=================================
path_input='D:\SKRIPSI\vault\data\ghrsst\'+year_st+'\'+year_st+month_st+day_st+'*.nc'  
datanc= findfile(path_input,count=num_files) 
;stop

;===========================START=================================
;stop                                                
if num_files gt 0 then begin ;gt singkatan dari greater than, jadi kalau udah dapat data langsung mulai looping
for inc=0,num_files-1 do begin  
;stop

;===========================VARIABLE=================================
cdfid = NCDF_OPEN(datanc[inc])
varnames = ncdf_vardir(cdfid) ;lihat varnames nya ada banyak, tapi cuman diambil yg lan lot time sama analysis sst
;stop
NCDF_VARGET, cdfid, 0, lat ;0 dihitung sebagai data pertama
NCDF_VARGET, cdfid, 1, lon       
NCDF_VARGET, cdfid, 2, time
NCDF_VARGET, cdfid, 3, analysed_sst
;stop 

;=============================ATTRIBUTE===============================
attnames = ncdf_attdir(cdfid,'analysed_sst') ; attribute name isinya adalah atribut dalam analysis sst karena cmn butuh analysis sst aja
;stop
NCDF_ATTGET,cdfid,'analysed_sst','_FillValue',_FillValue ;fill value artinya data kosong stsu bolong, diisi dengan -32767
NCDF_ATTGET,cdfid,'analysed_sst','add_offset',add_offset ;add offset dipakai kalau mau dijadiin kelvin, jadi ditambah 273
NCDF_ATTGET,cdfid,'analysed_sst','units',units ;satuannya celcius
NCDF_ATTGET,cdfid,'analysed_sst','scale_factor',scale_factor  ;faktor pengali karena kalau gk dikali hasilnya ratusan derajat

a=string(units)     
;stop
;============================================================
sst=analysed_sst
;============================================================
latmin=min(lat)
lonmin=min(lon)            
grid_interval=lon[1]-lon[0] ;0.087890625 
sst_map=sst*scale_factor;+add_offset
stop
;============================================================
index = where(sst eq _FillValue, count_index) ;data kosong dinamakan index
;stop
sst_map[index]=999 ;index atau data kosong diganti dengan angka 999 biar gampang difilter     
lon_beg = lonmin_cut  
lon_end = lonmax_cut
lat_beg = latmin_cut
lat_end = latmax_cut
a = fix ((lon_beg-lonmin)/grid_interval)
b = fix ((lon_end-lonmin)/grid_interval)
c = fix ((lat_beg-latmin)/grid_interval)
d = fix ((lat_end-latmin)/grid_interval)

data_map = sst_map[a:b,c:d] ;172 115
;stop
;=========================================================
file_mkdir,'D:\SKRIPSI\database\ghrsst\extract dialy\'+year_st+'\'+month_st+'
save,data_map,filename='D:\SKRIPSI\database\ghrsst\extract dialy\'+year_st+'\'+month_st+'\sst'+year_st+month_st+day_st+'.sav' 
;stop
print,year,month,day
NCDF_CLOSE, Cdfid
;================CATATAN PENTING==================================
; 1. Sebelum close program cek dulu dimensi dari data_map diingat jika perlu di catat karena sangat penting untuk program kedepannya
; 2. Catat juga nilai grid_interval
; 3. Perhatikan penyimpanan filenya bila menyimpan menggunakan berikut
;    
;    save,data_map,filename='folder dan nama file.sav'
;    
;    Pastikan saat open pada script berikutnya saat open file seperti berikut
;    
;    path_input = 'folder dan nama file.sav'
;    datanc= findfile(path_input,count=num_files)   ;Script ini tergantung kebutuhan bila open menggunakan * maka pakai ini jika tidak, tidak perlu ada tidak masalah
;    for inc=0,num_files-1 do begin                   ;ini mengikuti datanc tadi
;    restore,datanc[inc]                              ;bila menggunakan datanc
;    restore,path_input                               ;bila tidak menggunakan datanc tapi perlu diperhatikan juga nama di path_input harus lengkap
;    data=data_map                                    ;mengambil data dari file tadi
;stop
endfor
endif
endfor
endfor
endfor
;stop
TOC
print, 'finish'
stop
end
