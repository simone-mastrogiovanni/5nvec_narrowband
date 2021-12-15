function out=bsd_notch(in,parnotch)
% notches on bsds
%
%     out=bsd_notch(in,parnotch)
%
%   in             input bsd
%   parnotch       notch parameters (if absent or a void structure or not a structure, default values)
%           .thr      threshold on persistence
%           .win      window (def 1)
%           .linel    line list [n,2] (frmin frmax)

% Snag Version 2.0 - November 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

n=n_gd(in);
lenini=n;
y=y_gd(in);
cont=cont_gd(in);
tfstr=cont.tfstr;

dt=tfstr.dt;
DT=tfstr.DT;
gdlen=tfstr.gdlen;

inifr=tfstr.inifr;
bandw=tfstr.bandw;
dfr=tfstr.dfr;

lfft=tfstr.lfft;
lfft2=ceil(lfft/2);
if isfield(tfstr,'Nfft')
    Nfft=tfstr.Nfft;
else
    Nfft=floor(2*n/lfft);
end

persist0=tfstr.clean.persist0;

if ~exist('parnotch','var')
    parnotch.thr=0.2;
    parnotch.win=1;
elseif ~isstruct(parnotch)
    parnotch.lfft=lfft;
    parnotch.thr=0.25;
    parnotch.win=1;
end
if ~isfield(parnotch,'lfft')
    parnotch.lfft=lfft;
end
if ~isfield(parnotch,'thr')
    parnotch.thr=0.25;
end
if ~isfield(parnotch,'win')
    parnotch.win=1;
end

notch=persist0*0+1;
ii=find(persist0 >= parnotch.thr);
npers=length(ii);
parnotch.npers=npers;
parnotch.fpers=(ii-1)*dfr+cont.inifr;

if npers > 0
    notch(ii)=0;

    ii1=ii-1;
    if ii1(1) < 1
        ii1(1)=1;
    end
    notch(ii1)=notch(ii1)/2;

    ii1=ii+1;
    if ii1(npers) > lfft
        ii1(npers)=lfft;
    end
    notch(ii1)=notch(ii1)/2;
end

if isfield(parnotch,'linel')
    linel=parnotch.linel;
    [~,nlin0]=size(linel);
    ilin=linel*0;
    nlin=0;
    for i = 1:nlin0
        ilin1=floor((linel(1,i)-inifr)/dfr);
        ilin2=ceil((linel(2,i)-inifr)/dfr); % fprintf(' %d %d %d \n',i,ilin1,ilin2)
        if ilin1 > 0 & ilin2 <= lfft
            nlin=nlin+1; disp('ok')
            ilin(1,nlin)=ilin1;
            ilin(2,nlin)=ilin2;
            ibord1(nlin)=1;
            ibord2(nlin)=1;
        end
        if ilin1 < 0 & ilin2 <= lfft & ilin2 > 0
            nlin=nlin+1; % disp('ok')
            ilin(1,nlin)=1;
            ilin(2,nlin)=ilin2;
            ibord1(nlin)=0;
            ibord2(nlin)=1;
        end
        if ilin1 > 0 & ilin2 > lfft & ilin1 <= lfft
            nlin=nlin+1; disp('ok')
            ilin(1,nlin)=ilin1;
            ilin(2,nlin)=lfft;
            ibord1(nlin)=1;
            ibord2(nlin)=0;
        end
    end
else
    disp(' *** no lines')
    parnotch
    return
end

nlin,Nfft,size(notch)
for i = 1:nlin
    notch(ilin(1,i):ilin(2,i))=0;
    notch(ilin(1,i)-ibord1(i))=notch(ilin(1,i)-ibord1(i))/2;
    notch(ilin(2,i)+ibord2(i))=notch(ilin(2,i)+ibord2(i))/2;
end

ycl=y;
yy=zeros(1,lfft);
i1=1;
lfft4=lfft/4;
k1=lfft4+1;
k2=3*lfft4;

for i = 1:Nfft
    i2=i1+lfft-1;
    if i2 > n
        yy=yy*0;
        yy(1:lfft+n-i2)=y(i1:n);
    else
        yy=y(i1:i2);
    end
    YY=ifft(fft(yy).*notch');
    j1=i1+lfft4;
    j2=j1+lfft2-1; %i1,i2,j1,j2
    ycl(j1:j2)=YY(k1:k2);
    i1=i1+lfft2;
end

parnotch.notch=notch;
tfstr.parnotch=parnotch;
lenfin=length(ycl);
if lenfin > lenini
    ycl=ycl(1:lenini);
end
if lenfin < lenini
    ycl(lenfin+1:lenini)=ycl(lenfin+1:lenini);
end

cont=cont_gd(in);
cont.tfstr=tfstr;
out=edit_gd(in,'y',ycl,'cont',cont);