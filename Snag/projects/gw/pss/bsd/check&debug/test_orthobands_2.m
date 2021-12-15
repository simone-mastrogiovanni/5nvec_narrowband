function out=test_orthobands_2(bands,dt)
% 
%    bands   [frin dfr DFR maxfr maxdfr]
%    dt      def 0.1

if ~exist('dt')
    dt=0.1;
end

frin=bands(1);
dfr=bands(2);
DFR=bands(3);
maxfr=bands(4);
maxdfr=bands(5);

N=ceil(maxfr/DFR);
M=ceil(maxdfr/dfr);
nband=zeros(M,N);
kord=nband;
jband=nband;
dtout=nband;

for k = 1:M
    wb=k*dfr;
    for i = 1:N
        bandin=[bands(1) bands(1)+wb]+(i-1)*DFR;
        out1=base_orthobands(bandin,dt);
        nband(k,i)=out1.nband;
        kord(k,i)=out1.kord;
        jband(k,i)=out1.jband;
        dtout(k,i)=out1.dtout;
    end
end

out.nband=nband;
out.kord=kord;
out.jband=jband;
out.dtout=dtout;

figure,plot(out.nband),grid on,hold on,plot(out.nband,'r.'),title('nband'),xlabel('kband')
figure,plot(out.kord,'b.'),grid on,hold on,plot(out.jband,'r.'),title('kord and jband'),xlabel('kband')
figure,plot(out.dtout),grid on,hold on,plot(out.dtout,'r.'),title('dtout'),xlabel('kband')