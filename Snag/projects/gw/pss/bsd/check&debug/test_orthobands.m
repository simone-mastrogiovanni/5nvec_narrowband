function out=test_orthobands(bands,dt)
% 
%    bands   [frin frfi DFR maxfr]
%    dt      def 0.1

if ~exist('dt')
    dt=0.1;
end

frin=bands(1);
frfi=bands(2);
DFR=bands(3);
maxfr=bands(4);

N=ceil(maxfr/DFR);
nband=zeros(1,N);
kord=nband;
jband=nband;
dtout=nband;

for i = 1:N
    bandin=bands(1:2)+(i-1)*DFR;
    out1=base_orthobands(bandin,dt);
    nband(i)=out1.nband;
    kord(i)=out1.kord;
    jband(i)=out1.jband;
    dtout(i)=out1.dtout;
end

out.nband=nband;
out.kord=kord;
out.jband=jband;
out.dtout=dtout;

figure,plot(out.nband),grid on,hold on,plot(out.nband,'r.'),title('nband'),xlabel('kband')
figure,plot(out.kord,'b.'),grid on,hold on,plot(out.jband,'r.'),title('kord and jband'),xlabel('kband')
figure,plot(out.dtout),grid on,hold on,plot(out.dtout,'r.'),title('dtout'),xlabel('kband')