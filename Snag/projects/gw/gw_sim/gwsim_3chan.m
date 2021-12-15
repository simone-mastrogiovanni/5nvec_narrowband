function sds_3chan(inpfile,chn,fftlen,tau)
%SDS_3CHAN  from a hrec file collection creates a file collections with also
%           whitened and wiener filtered data
%
%   inpfile   first input file
%   chn       input channel number
%   fftlen    length of the ffts
%   tau       tau of the autoregressive mean (in s)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('inpfile')
    snag_local_symbols;
    inpfile=selfile(virgodata);
end

sds_=sds_open(inpfile);
len=sds_.len;
sdsout_=sds_;
sdsout_.nch=3;
sdsout_.capt=['Created from hrec data from file ' sds_.filme];
sdsout_.ch{1}=[blank_trim(sds_.ch{1}) ' (hrec)'];
sdsout_.ch{2}='whitened hrec';
sdsout_.ch{3}='Wiener filter on hrec';

sdsout_=sds_openw(modi_name(sds_.filme),sdsout_);

if ~exist('chn')
    chn=sds_selch(inpfile);
end

if ~exist('tau')
    answ=inputdlg({'Length of the ffts','AR power spectrum estimate tau (s)'}, ...
        'Filtering parameters',2,{'16384','60'});
    fftlen=eval(answ{1});
    tau=eval(answ{2});
end

len2=fftlen/2;
len14=fftlen/4+1;
len34=3*fftlen/4;

d=ds(fftlen);
d=edit_ds(d,'type',2);
A=zeros(len2,3);
ps0=zeros(fftlen,1);
n0=0;
w=exp(-sds_.dt*fftlen/(2*tau));

while sds_.eof < 2
    [d,sds_]=sds2ds(d,sds_,chn);
    if sds_.eof == 2
        break   % provvisorio
    elseif sds_.eof == 1
    end
    y=y_ds(d);
    fy=fft(y);
    ps0=ps0+w*abs(fy).^2;
    n0=1+w*n0;
    ps=ps0/n0;
    fwh=tdwin(1./sqrt(ps),'hhole');
    fwi=tdwin(1./ps,'hhole');
    ywh=real(ifft(fy.*fwh));
    ywi=real(ifft(fy.*fwi));
    A(1:len2,1)=y(len14:len34);
    A(1:len2,2)=ywh(len14:len34);
    A(1:len2,3)=ywi(len14:len34);
    
%     figure,plot(y)
%     figure,semilogy(ps)
%     figure,plot(ywh)
%     figure,plot(ywi)
%     stopgo;
    
    fwrite(sdsout_.fid,A','float');
end

 
fclose(sdsout_.fid);

%---------------------------------------------------


function newname=modi_name(oldname)
%

newname=blank_trim(oldname)

o=double(newname)
in=double('hwhW')
for i = 1:4
    o(20+i)=in(i);
end

newname=char(o)

