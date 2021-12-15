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

if ~exist('chn')
    chn=sds_selch(inpfile);
end

if ~exist('tau')
    answ=inputdlg({'Length of the ffts','AR power spectrum estimate tau (s)'}, ...
        'Filtering parameters',2,{'16384','60'});
    fftlen=eval(answ{1});
    tau=eval(answ{2});
end

d=ds(fftlen);
d=edit_ds(d,'type',2);
A=zeros(3,fftlen/2);
ps=zeros(1,fftlen);
n0=0;
w=exp(-sds_.dt*fftlen/(2*tau));

while sds_.eof < 2
    [d,sds_]=sds2ds(d,sds_,chn);
    y=y_ds(d);
    fy=fft(y);
end
    