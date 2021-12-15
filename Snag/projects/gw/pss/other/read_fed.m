function g=read_fed(file,ini,fin)
% READ_FED  legge dati federica purged

fid=fopen(file);

capt1=fread(fid,23,'char');
capt='prova';

gpstim=fread(fid,1,'double');
gpsend=fread(fid,1,'double');
dt=fread(fid,1,'double');
n=fread(fid,1,'int');

pos=23+3*8+4+(ini-1)*4;
fseek(fid,pos,'bof');

g=fread(fid,(fin-ini+1),'float');

g=gd(g);
g=edit_gd(g,'dx',dt,'capt',capt);