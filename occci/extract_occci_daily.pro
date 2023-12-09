pro extract_occci_daily                                       ;Nama filenya, Nama file harus sama dengan *.pro bila tidak sama akan Error

;===========================COORDINATE=================================
;-----------------cut area coordinate------------------------
TIC
latmin_cut=-20
latmax_cut=10
lonmin_cut=95
lonmax_cut=146
;stop

;===========================LOOPING=================================
;--------------------loop_for_year--------------------------
start_year=2007
end_year=2007
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
;path_input='H:\OCCCIGEODAILY\'+year_st+'\ESACCI-OC-L3S-CHLOR_A-MERGED-1D_DAILY_4km_GEO_PML_OCx-'+year_st+month_st+day_st+'*.nc'
path_input='E:\'+year_st+'\ESACCI-OC-L3S-CHLOR_A-MERGED-1D_DAILY_4km_GEO_PML_OCx-'+year_st+month_st+day_st+'*.nc';PATH INPUTNYA FORMAT HRS KEK GINI Y BABI
;path_input='D:\SKRIPSI\vault\data\occci\*.nc';BENER NIH
;path_input='D:\SKRIPSI\vault\data\occci\'+year_st+'\'+month_st+'\ESACCI-OC-L3S-CHLOR_A-MERGED-1D_DAILY_4km_GEO_PML_OCx-'+year_st+month_st+day_st+'*.nc' 
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
NCDF_VARGET, cdfid, 5, chlor_a
NCDF_VARGET, cdfid, 9, lat
NCDF_VARGET, cdfid, 10, lon
NCDF_VARGET, cdfid, 11, time
;stop

;=============================ATTRIBUTE===============================
attnames = ncdf_attdir(cdfid,'chlor_a') ; attribute name isinya adalah atribut dalam chl
;stop
NCDF_ATTGET,cdfid,'chlor_a','_FillValue',_FillValue ;fill value artinya data kosong
NCDF_ATTGET,cdfid,'chlor_a','units',units 
;stop

a=string(units);milligram/m3
print, a
;stop
;============================================================
chl=chlor_a
;============================================================
latmin=min(lat)
lonmin=min(lon)
grid_interval=lon[1]-lon[0] ;0.041666666666657193

chl_map=chl
;stop
;============================================================
index = where(chl eq _FillValue, count_index) ;data kosong dinamakan index
;stop
chl_map[index]=999 ;index atau data kosong diganti dengan angka 999 biar gampang difilter
lon_beg = lonmin_cut
lon_end = lonmax_cut
lat_beg = latmin_cut
lat_end = latmax_cut
a = fix ((lon_beg-lonmin)/grid_interval)
b = fix ((lon_end-lonmin)/grid_interval)
c = fix ((lat_beg-latmin)/grid_interval)
d = fix ((lat_end-latmin)/grid_interval)

data_map = chl_map[a:b,c:d];data_map=[1225,721]
;data_map2 = rotate(data_map1,7)
;data_map = data_map2
;stop
;=========================================================
file_mkdir,'D:\SKRIPSI\database\occci\neutral\extract daily2\'+year_st+'\'+month_st+'
save,data_map,filename='D:\SKRIPSI\database\occci\neutral\extract daily2\'+year_st+'\'+month_st+'\chl'+year_st+month_st+day_st+'.sav'
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
