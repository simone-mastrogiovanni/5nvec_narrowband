function out=show_tfstr_cell(in)
% shows features of a tfstr
%
%    in    bsd gd or tfstr

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~isstruct(in)
    in=tfstr_gd(in);
end

n=length(in.tpeaks);
peaks=zeros(9,in.ntotpeaks);
nfr=in.bandw/in.dfr;
persist=zeros(1,round(nfr));
nnekkmax=zeros(7,n);
ii=0;
iii=[];

for i = 1:n
    pea=in.peaks{i};
    nn=length(pea.fr);
    if nn > 0
        peaks(1,ii+1:ii+nn)=in.tpeaks(i);
        peaks(2,ii+1:ii+nn)=pea.fr;
        peaks(3,ii+1:ii+nn)=pea.amp;
        peaks(6,ii+1:ii+nn)=pea.cr;
        peaks(7,ii+1:ii+nn)=real(pea.cc);
        peaks(8,ii+1:ii+nn)=imag(pea.cc);
        ang=angle(real(pea.cc)+1j*imag(pea.cc))*180/pi;
        peaks(9,ii+1:ii+nn)=ang;
        ifr=round((pea.fr-in.inifr)/in.dfr)+1;
        persist(ifr)=persist(ifr)+1;
        [mm,kk]=max(pea.amp);
        nnekkmax(1,i)=nn;
        nnekkmax(2,i)=ii+kk;
        nnekkmax(3,i)=in.tpeaks(i);
        nnekkmax(4,i)=pea.fr(kk);
        nnekkmax(5,i)=pea.amp(kk);
        nnekkmax(6,i)=pea.cr(kk);
        nnekkmax(7,i)=ang(kk);
        iii=[iii i];
        ii=ii+nn;
    end
end

out.peaks=peaks;
out.nnekkmax=nnekkmax;

figure,plot(peaks(1,:),peaks(2,:),'.'),grid on,xlabel('time (days)'),ylabel('frequency')
figure,plot(peaks(1,:),peaks(3,:),'.'),grid on,xlabel('time (days)'),ylabel('amplitude')
figure,plot(peaks(1,:),peaks(6,:),'.'),grid on,xlabel('time (days)'),ylabel('cr')
figure,plot(peaks(1,:),peaks(9,:),'.'),grid on,xlabel('time (days)'),ylabel('angle')

figure,hist(peaks(1,:),100),title('time histogram'),grid on
figure,hist(peaks(2,:),100),title('frequency histogram'),grid on
figure,hist(log10(peaks(3,:)),100),title('log10(amp) histogram'),grid on
figure,hist(log10(peaks(6,:)),100),title('log10(cr) histogram'),grid on
figure,hist(peaks(9,:),100),title('angle histogram'),grid on

out.pers(2,:)=persist;
out.pers(1,:)=(0:nfr-1)*in.dfr+in.inifr;
figure,plot(out.pers(1,:),out.pers(2,:),'.'),grid on,title('persistence'),xlabel('Hz')

figure,hist(out.pers(2,:),200),title('persistence histogram'),grid on

image_gd2(in.hdens,0,0),grid on

% sel max
% iii,nnekkmax(2,iii)
figure,plot(nnekkmax(3,iii),nnekkmax(4,iii),'.'),grid on,xlabel('time (days)'),ylabel('frequency max')
figure,plot(nnekkmax(3,iii),nnekkmax(5,iii),'.'),grid on,xlabel('time (days)'),ylabel('amplitude max')
figure,plot(mod(nnekkmax(3,iii),1)*24,nnekkmax(5,iii),'.'),grid on,xlabel('time (hours)'),ylabel('amplitude max')
figure,plot(nnekkmax(3,iii),nnekkmax(7,iii),'.'),grid on,xlabel('time (days)'),ylabel('angle max')
figure,plot(mod(nnekkmax(3,iii),1)*24,nnekkmax(7,iii),'.'),grid on,xlabel('time (hours)'),ylabel('angle max')