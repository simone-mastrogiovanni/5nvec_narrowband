function sfdb09_us=read_sfdb_userheader(sbl_)

fid=sbl_.fid;

fseek(fid,sbl_.hlen,'bof')

sfdb09_us.einstein=fread(fid,1,'float32');
sfdb09_us.detector=fread(fid,1,'int32');
sfdb09_us.tsamplu=fread(fid,1,'double');
sfdb09_us.typ=fread(fid,1,'int32');
sfdb09_us.wink=fread(fid,1,'int32');
sfdb09_us.nsamples=fread(fid,1,'int32');
sfdb09_us.tbase=fread(fid,1,'double');
sfdb09_us.deltanu=fread(fid,1,'double');
sfdb09_us.firstfrind=fread(fid,1,'int32');
sfdb09_us.frinit=fread(fid,1,'double');
sfdb09_us.normd=fread(fid,1,'float32');
sfdb09_us.normw=fread(fid,1,'float32');
sfdb09_us.red=fread(fid,1,'int32');

fseek(fid,sbl_.point0,'bof')