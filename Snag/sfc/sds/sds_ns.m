function sds_ns(file,chn,nlevel,fftlen,nmax)
%SDS_NS  creates an sds file containing time-frequency informations
%
%          m=sds_ns(file,nlevel)
% 
%     file      first file of a concatenated set
%     nch       channel number
%     npart     number of partitions of the spectrum

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file')
    snag_local_symbols;
    file=selfile(virgodata);
end

sds_=sds_open(file);

if ~exist('chn')
    chn=sds_selch(file);
end

if ~exist('nlevel')
    answ=inputdlg({'Number of partitions ?','Length of ffts ?','Max number of values ?'}, ...
        'Analysis parameters',1,{'8','4096','10000'});
    npart=eval(answ{1});
    fftlen=eval(answ{2});
    nmax=eval(answ{3});
end

nchan=npart;
len=fftlen/2;
partlen=floor(len/npart+0.001);
A(nchan)=0;

sdsout_=sds_;
sdsout_.nch=nchan;
sdsout_.dt=fftlen*sds_.dt;
sdsout_capt='time-frequency analysis';
for i = 1: nchan
    fr1=(i-1)*partlen/(sds_.dt*fftlen);
    fr2=i*partlen/(sds_.dt*fftlen);
    sdsout_.ch{i}=sprintf('channel %d min,max freq. %f, %f',i,fr1,fr2);
end
sdsout_=sds_openw('medie.sds',sdsout_);
fid=sdsout_.fid;

sds_=sds_open(file)

d=ds(fftlen);
d=edit_ds(d,'type',1,'verb',0);
itot=0;

while itot < nmax
    [d,sds_]=sds2ds(d,sds_,chn);
    if sds_.eof > 1
        break
    end
    y=fft(y_ds(d));
    y=(abs(y(1:len)).^2)*2;
    
    for i = 1:npart
        ii=(i-1)*partlen+1;
        A(i)=sum(y(ii:ii+partlen-1));
    end
    fwrite(fid,A,'float');
    itot=itot+1;
end
    
fclose(fid);

fid=fopen(sdsout_.file,'r+');
fseek(fid,8,'bof');
fwrite(fid,itot,'int64');
fclose(fid);
