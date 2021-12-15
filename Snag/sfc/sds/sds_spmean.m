function sds_spmean(frbands,file,chn,fftlen,nmean,nmax)
%SDS_SPMEAN  creates an sds file containing time-frequency information
%            the file (psmean.sds) contains a channel with the time (in
%            days) and one channel for each band
%
%          m=sds_spmean(frbands,file,chn,fftlen,nmax)
% 
%     frbands   frequency bands (a Nx2 matrix or a file containing them)
%     file      first file of a concatenated set
%     chn       channel number
%     fftlen    length of the fft
%     nmean     number of periodograms to be averaged
%     nmax      max number of data (per band)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('frbands')
    [fnam,pnam]=uigetfile('*.*','Frequency File Selection');
    frbands=strcat(pnam,fnam);
end

if ischar(frbands)
    frbands=load(frbands)
end
    
if ~exist('file')
    snag_local_symbols;
    file=selfile('');
end

sds_=sds_open(file);

if ~exist('chn')
    chn=sds_selch(file);
end

if ~exist('fftlen')
    answ=inputdlg({'Length of ffts ?','Mean on ?','Max number of values ?'}, ...
        'Analysis parameters',1,{'4000','10','1000000'});
    fftlen=eval(answ{1});
    nmean=eval(answ{2});
    nmax=eval(answ{3});
end

nchan=size(frbands,1);
len=round(fftlen/2);
A(nchan+1)=0;

sdsout_=sds_;
sdsout_.nch=nchan+1;
sdsout_.dt=fftlen*sds_.dt*nmean;
sdsout_capt='time-frequency analysis';
sdsout_.ch{1}='timing channel - Starting Time';
for i = 1: nchan
    sdsout_.ch{i+1}=sprintf('channel %d min,max freq. %f, %f', ...
        i,frbands(i,1),frbands(i,2));
end
sdsout_=sds_openw('psmean.sds',sdsout_);
fid=sdsout_.fid;

sds_=sds_open(file);
dt=sds_.dt;
dfr=1/(dt*fftlen);
t0=floor(sds_.t0);

itot=0;
ii=0;

while itot < nmax
    [vec,sds_,tim0,holes]=vec_from_sds(sds_,chn,fftlen);
    if sds_.eof > 1
        break
    end
    
    ii=ii+1;
    if ii == 1
        A(1)=tim0-t0;
    end
    y=fft(vec);
    y=sqrt((abs(y(1:len)).^2)*2*dt/len);
    
    for i = 1:nchan
        ii1=round(frbands(i,1)/dfr)+1;
        if ii1 > len
            ii1=len;
        end
        ii2=round(frbands(i,2)/dfr)+1;
        if ii2 > len
            ii2=len;
        end
        A(i+1)=A(i+1)+mean(y(ii1:ii2));
    end
    if ii == nmean
        A(2:nchan+1)=A(2:nchan+1)/nmean;
        fwrite(fid,A,'float');
        itot=itot+1;
        A(:)=0;
        ii=0;
    end
end
    
fclose(fid);

fid=fopen(sdsout_.file,'r+');
fseek(fid,24,'bof');
fwrite(fid,itot,'int64');
fclose(fid);
