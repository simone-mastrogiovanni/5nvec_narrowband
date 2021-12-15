function [peaks,pm_corr,frs,wien]=peak_correction(pm,frsd,alpha,delta,wid,nofreq)
% corrects peaks from a pm extracted by read_peakmap
%
%     [peaks pm_corr frs wien]=peak_correction(pm,tim,vel,frsd,alpha,delta,wid,nofreq)
%
%   pm           extracted gd2 
%   frsd         [T0,fr0,sd,dfr] epoch, frequency, spin-down, resolution of the source
%   alpha,delta  of the source
%   wid          width (in units of dfr/2; def 1)
%   nofreq       frequencies to be excluded
%
%   peaks        (6,M) time, frequency, signal frequency, amplitude, pmean, wiener of the peaks
%   pm_corr      gd2 with the corrected peak map
%   frs          frequencies of the signal at tim
%   wien         wiener weights

% Version 2.0 - September 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('wid','var')
    wid=1;
end
if ~exist('nofreq','var')
    nofreq=[];
end
cont=cont_gd2(pm);
tim0=cont.tim0;
vel=cont.vp;
pmean=cont.pmean;
gsp=cont.gsp;
epoch=cont.runstr.epoch;
sp=y_gd2(gsp);
inisp=ini2_gd2(gsp);
dfsp=dx2_gd2(gsp);
[n1 n2]=size(sp);
sp1=zeros(n1,1);
fsp=inisp+(0:n2-1)*dfsp;

r=astro2rect([alpha,delta],0);
v=vel(1:3,:);
tim=x_gd2(pm)+tim0;
N=length(tim);
v1=zeros(1,N);

for i = 1:N
    v1(i)=dot(v(:,i),r);
end
T0=frsd(1);
fr0=frsd(2);
sd=frsd(3);
dfr=frsd(4);
fr1=(tim'-T0)*86400*sd+fr0;%N,n1,n2,size(fr1),size(v1)
frs=fr1.*(1+v1);
frepoch=(epoch-T0)*86400*sd+fr0;

f2=x2_gd2(pm);    
mindf=min(round((min(f2)-frs)/dfr));
maxdf=max(round((max(f2)-frs)/dfr));
M=maxdf-mindf+1;
A=sparse(N,M);
Apm=sparse(N,M);
a=y_gd2(pm);
[n1 n2]=size(a);
[ni nj s]=find(a);
ui=unique(ni);
uj=unique(nj);
disp(sprintf('input: %dx%d matrix, %d peaks in unique %d rows  %d cols  ratio: %f',...
    n1,n2,length(s),length(ui),length(uj),n1*n2/length(s)))
inifrout=mindf*dfr;

if length(nofreq) > 0
    for j = 1:length(f2)
        if min(abs(f2(j)-nofreq)/dfr) < 0.5
            a(:,j)=0;
        end
    end
    [ni nj s]=find(a);
    ui=unique(ni);
    uj=unique(nj);
    disp(sprintf('input: %dx%d matrix, %d peaks in unique %d rows  %d cols  ratio: %f',...
    n1,n2,length(s),length(ui),length(uj),n1*n2/length(s)))
end

peaks=zeros(6,N);
Np=0;

for i = 1:N
    ii=find(a(i,:));
    ff=f2(ii)-frs(i);
    [ffmin, ll]=min(abs(ff)); %if ll > 1 ; disp([i,ll]);end
    kk=round((f2(ii)-frs(i)-inifrout)/dfr)+1; 
    A(i,kk)=a(i,ii);
    Apm(i,kk)=pmean(i,ii);
    
    ffsp=fsp-frs(i);
    [ffminsp, llsp]=min(abs(ffsp)); %if ll > 1 ; disp([i,ll]);end
    sp1(i)=sp(i,llsp);
    if ffmin  <= wid*dfr/2;
        Np=Np+1;
        peaks(1,Np)=tim(i);
        peaks(2,Np)=f2(ii(ll));
        peaks(3,Np)=frs(i);
        peaks(4,Np)=a(i,ii(ll));
        peaks(5,Np)=pmean(i,ii(ll));
        peaks(6,Np)=i;
    end
end

excl=2/3;
m=median(sp1);
wien=sp1*0;
ii=find(sp1 < excl*m);
sp1(ii)=0;
ii=find(sp1);
sp1=1./sp1(ii);
wien(ii)=sp1/mean(sp1);

peaks=peaks(:,1:Np);
peaks(6,:)=wien(peaks(6,:));
[ni nj s]=find(A);
ui=unique(ni);
uj=unique(nj);
disp(sprintf('input: %dx%d matrix, %d peaks in unique %d rows  %d cols  ratio: %f',...
    N,M,length(s),length(ui),length(uj),N*M/length(s)))

pm_corr=pm;
cont.pmean=Apm;
cont.frsd=frsd;
cont.frepoch=frepoch;
pm_corr=edit_gd2(pm_corr,'y',A,'ini2',inifrout+frepoch,'cont',cont);

disp(sprintf('   %d peaks found; ratio %f',Np,N/Np))