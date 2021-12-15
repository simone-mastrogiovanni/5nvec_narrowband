function tfstr=bsd_peakmap_cell(in,lfft,thr,typ)
% peakmap creation
%
%      tfstr=bsd_peakmap(in,lfft,thr,typ)
%
%    in     input bsd
%    lfft   length of the ffts (possibly enhanced, multiple of 4)
%    thr    normalized threshold
%    typ    type structure

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tfstr.peaktype='cell';

if ~exist('thr')
    thr=2.5;
end

cont=cont_gd(in);
inifr=cont.inifr;
dt=dx_gd(in);
n=n_gd(in);
y=y_gd(in);

if ~exist('typ','var')
    typ.sstype='median'; % very short spectrum type % NOT USED !
    typ.ssred=256; % reduction factor for very short spectrum
    typ.minno0=0.5; % min number of non-zero
end

if ~isfield(typ,'maxwn')
    typ.maxwn=5;
end

sstype=typ.sstype;
ssred=typ.ssred;
ssred=round(ssred);
if ssred ~= typ.ssred
    fprintf(' *** new ssred = %d \n',ssred)
end
minno0=typ.minno0;

lfft2=ceil(lfft/2);
if lfft ~= lfft2*2
    lfft=lfft2*2;
    fprintf(' *** new lfft = %d \n',lfft)
end
DT=lfft2*dt;
dfr=1/(lfft*dt);

N=round(2*n/lfft);
n1=(N+1)*lfft2;
y(n+1:n1)=0;
len_ss=ceil(lfft/ssred); 
ssred1=ceil(lfft/len_ss); 
delayfft=DT/86400;

tfstr.ant=cont.ant;
tfstr.t0=cont.t0;
tfstr.dt=dx_gd(in);
tfstr.inifr=cont.inifr;
tfstr.bandw=cont.bandw;
tfstr.lfft=lfft;
tfstr.Nfft=N;
tfstr.dfr=dfr;
tfstr.DT=DT;
tfstr.gdlen=n;
tfstr.subsp.Nsstim=N;
tfstr.subsp.len_ss=len_ss;
tfstr.subsp.ssred1=ssred1;
tfstr.subsp.init=delayfft;
tfstr.pt.thr=thr;
tfstr.subsp.typ=typ;

ss=zeros(N,len_ss);%N,lfft,nss,lss
ss0=zeros(len_ss,1)';
i1=1;
totpeaks=cell(1,N);
ntotpeaks=0;

ok=[];
yy=zeros(1,lfft);

for i = 1:N
    i2=i1+lfft-1;
    yy(1:lfft)=y(i1:i2);
    ii=find(yy(1:lfft));
    lii=length(ii);
    if lii >= lfft*minno0
        YY=fft(yy)*sqrt(dt/lii);
        Y=abs(YY).^2;  % CHECK NORMALIZZAZIONE
        j1=1;
        for j = 1:len_ss
            j2=min(j1+ssred1-1,lfft);
            ss0(j)=median(Y(j1:j2));
            j1=j*ssred1+1;
        end
        ss0=ss0/log(2); % correction for using the median
        ss(i,:)=ss0;
        iii=floor((1:lfft)/ssred1)+1; % iii,nss,size(Y)
%         iii(nss)=min(iii(nss),floor(lfft/lss));
        jjj=find(iii > len_ss);
        if ~isempty(jjj)
            for j = 1:length(jjj)
                fprintf(' i = %d  j = %d  iii(jjj(j)) = %d   changed in %d \n',i,j,iii(jjj(j)),len_ss)
                iii(jjj(j))=len_ss;
            end
        end
%         size(Y),size(ss0(iii))
        Y1=Y./ss0(iii);
        kkk=find(Y1 >= thr);
        if ~isempty(kkk)
            [x,cr]=oned_peaks(Y1,-thr,0); %length(x) %figure,plot(x,z,'.')
        else
            x=[];
            cr=x;
            disp(' *** WARNING no peaks in this fft')
        end
        amp=Y(x);
        cc=YY(x);
        ok=[ok i];
        ntotpeaks=ntotpeaks+length(x);
    else
        x=[];cr=[];amp=[];cc=[];
    end
    peaks.fr=(x-1)*dfr+inifr;
    peaks.cr=cr;
    peaks.amp=sqrt(amp');
    peaks.cc=cc';
    totpeaks{i}=peaks;
%     tpeaks(i)=adds2mjd(cont.t0,(i-0.5)*lfft2*dt);
    tpeaks(i)=adds2mjd(cont.t0,i*lfft2*dt); % Ornella 10-5-18
    npeaks(i)=length(x);
    i1=i1+lfft2;
end

n1=length(npeaks);
index=ones(1,n1+1);
index(2:n1+1)=cumsum(npeaks); 
ii=find(index == 0);
index(ii)=1;
wn=ss*0;

for j = 1:len_ss
    ss1=ss(:,j);
    ii=find(ss1 > 0);
    ss1=ss1(ii);
    wn1=1./ss1;
    wn10=wn1/median(wn1);
    iii=find(wn10 > typ.maxwn);
    wn1(iii)=0;
    wn1=wn1/mean(wn1); % CONTROLLARE LA RAGIONEVOLEZZA: forse dovrebbe essere solo sui non-0
%     ss1a=ss1(iii);
%     wn1a=1./ss1a;
%     wn1a=wn1a/mean(wn1a);
    wn(ii,j)=wn1;
end

hdens=gd2(sqrt(ss));
% hdens=edit_gd2(hdens,'x',tpeaks+delayfft,'ini2',inifr,'dx2',dfr*ssred); 
hdens=edit_gd2(hdens,'x',tpeaks,'ini2',inifr,'dx2',dfr*ssred); % Ornella 10-5-18

tfstr.subsp.hdens=hdens;
tfstr.subsp.wn=wn;
tfstr.pt.tpeaks=tpeaks;
tfstr.pt.npeaks=npeaks;
tfstr.pt.peaks=totpeaks;
tfstr.pt.ntotpeaks=ntotpeaks;
tfstr.pt.ok=ok;
tfstr.pt.index=index;
% i2,n1,N