function [peaks,basic_info,checkB]=crea_peak_table(A,basic_info)
% creates a peak_table from a gd2 as created by read_peakmap computing the noise wiener weights,
%                  (without radiation pattern)
%
%   [peaks,basic_info]=crea_peak_table(A,basic_info,basic_info)
%
%    A            peaks gd2 as created by read_peakmaps
%    basic_info   basic info structure
%
%    peaks        [5,N]; the rows are [tim fr amp noisw sigw]

% Version 2.0 - October 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

tic
checkB=struct();
% checkB.A=A;
basic_info.proc.B_crea_peak_table.vers='140630';
basic_info.proc.B_crea_peak_table.tim=datestr(now);

tim0=basic_info.tim0;

if isfield(basic_info.mode,'pers_par')
    pers_par=basic_info.mode.pers_par;
else
    pers_par=[1 1];
end
    
gsp=basic_info.gsp;
sp=y_gd2(gsp);
inisp=ini2_gd2(gsp);
dfsp=dx2_gd2(gsp);
[m1,m2]=size(sp); % m1 times num, m2 freqs num

B=y_gd2(A);
[n1,n2]=size(B);
N=length(find(B));
basic_info.npeaks_ori=N;
tim=x_gd2(A)+tim0;
fr=x2_gd2(A);
convfr=round((fr-inisp)/dfsp)+1; % figure,plot(conv,'.')
B1=y_gd2(cut_gd2(A,[0 1e6],[basic_info.frin basic_info.frfi],1));
bt=sum(sign(B1'));
basic_info.npeak_fft=full(bt);

% clean big persistence
b=sum(sign(B));
robst=robstat(b,0.01);
[aaa,iii]=find(b > pers_par(1)*robst(4)+pers_par(2)*robst(2));
B(:,iii)=0;
basic_info.mode.veto_lines=fr(iii);
basic_info.mode.veto_lines_amp=b(iii);

excl=2/3;
wien=sp*0;
for i = 1:m2
    sp1=sp(:,i);
    m=median(sp1);
    ii=find(sp1 < excl*m);
    sp1(ii)=0;
    jj=find(sp1);
    sp1=1./sp1(jj);
    wien(jj,i)=sp1/mean(sp1);
end

sp=sp.*wien;
wsp=zeros(1,m2);
for i = 1:m2
    wsp(i)=sum(sp(:,i))/sum(wien(:,i));
end
wsp=gd(wsp);
wsp=edit_gd(wsp,'ini',inisp,'dx',dfsp);

peaks=zeros(5,N);

index=zeros(1,n1+1);
index(1)=1;
n=0;

for i = 1:n1
    [ii,jj,val]=find(B(i,:));
    njj=length(jj);
    if njj > 0
        peaks(1,n+1:n+njj)=tim(i);
        peaks(2,n+1:n+njj)=fr(jj);
        peaks(3,n+1:n+njj)=val;
        peaks(4,n+1:n+njj)=wien(i,convfr(jj));
        peaks(5,n+1:n+njj)=0;
    end
    n=n+njj;
    index(i+1)=n+1;
end
peaks=peaks(:,1:n);
ii=find(peaks(4,:) > 0);
nii=length(ii);
tim1=unique(peaks(1,:));
nz_fft=length(tim1);

basic_info.nz_fft=nz_fft;
basic_info.npeaks=n;
basic_info.NPeak(3)=n;
basic_info.NPeak(4)=nii;
basic_info.Dt=(max(peaks(1,:))-min(peaks(1,:)))*86400;
basic_info.Df_sd=basic_info.Dt*max(abs(basic_info.run.sd.min),abs(basic_info.run.sd.max));
basic_info.index=index;
basic_info.frs=fr;
basic_info.wsp=wsp;
checkB.noise_wien=wien;

basic_info.proc.B_crea_peak_table.duration=toc;