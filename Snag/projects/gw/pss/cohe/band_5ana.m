function [outmf cohe x inif DF]=band_5ana(gin,fr0,sigs,data,band,k4)
% BAND_5MATFILT  computes a set of matched filters on an entire band
%
%   [outmf cohe x inif DF]=band_5ana(gin,fr0,sigs,data,band,k4)
%
%    gin         input gd
%    fr0         signal apparent frequency
%    sigs(4,5)   4 signals bank (lin0,lin45,circA,circC)
%    data        data 5-vect
%    band        [mean max] frequency
%    k4          spectral enhancement factor
%
%    outmf(6,:)  m.f. quadratic outputs (lin0,lin45,circA,circC,pseudo-lin45a,pseudo-circCa)
%    cohe(6,:)   coherence outputs (lin0,lin45,circA,circC,[lin0,lin45a],[circA,circCa])

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('k4','var')
    k4=4;
end

mf(1,:)=conj(sigs(1,:))/sum(abs(sigs(1,:)).^2);
mf(2,:)=conj(sigs(2,:))/sum(abs(sigs(2,:)).^2);
mf(3,:)=conj(sigs(3,:))/sum(abs(sigs(3,:)).^2);
mf(4,:)=conj(sigs(4,:))/sum(abs(sigs(4,:)).^2);

% out12=sum(sigs(2,:).*mf(1,:));
% out34=sum(sigs(4,:).*mf(3,:));

out12=sum(sigs(2,:).*conj(sigs(1,:)))/sqrt((sum(abs(sigs(2,:)).^2)*sum(abs(sigs(1,:)).^2)));
out34=sum(sigs(4,:).*conj(sigs(3,:)))/sqrt((sum(abs(sigs(4,:)).^2)*sum(abs(sigs(3,:)).^2)));

sigs(5,:)=sigs(2,:)-out12*sigs(1,:); % pseudo cross
% sigs(5,:)=sigs(5,:)*sqrt(sum(abs(sigs(2,:)).^2)/sum(abs(sigs(5,:)).^2));
sigs(6,:)=sigs(4,:)-out34*sigs(3,:); % pseudo circC
% sigs(6,:)=sigs(6,:)*sqrt(sum(abs(sigs(4,:)).^2)/sum(abs(sigs(6,:)).^2));
mf(5,:)=conj(sigs(5,:))/sum(abs(sigs(5,:)).^2);
mf(6,:)=conj(sigs(6,:))/sum(abs(sigs(6,:)).^2);

v(1:7)=0;

disp('     Application of Mat.Filt.')
disp('   lin0     lin45     circA     circC    pslin45    pscircC       data')

for i = 1:6
    for j = 1:6
        v(j)=abs(sum(sigs(j,:).*mf(i,:))).^2;
    end
    v(7)=abs(sum(data.*mf(i,:))).^2;
    disp(sprintf(' %f  %f  %f  %f  %f  %f    %e ',v))
end

disp('     Versors scalar product')
disp('   lin0     lin45     circA     circC    pslin45    pscircC       data')

for i = 1:6
    for j = 1:6
        v(j)=abs(sum(sigs(j,:).*conj(sigs(i,:)))).^2/(sum(abs(sigs(j,:)).^2)*sum(abs(sigs(i,:)).^2));
    end
    v(7)=abs(sum(data.*sigs(i,:))).^2/(sum(abs(data).^2)*sum(abs(sigs(i,:)).^2));
    disp(sprintf(' %f  %f  %f  %f  %f  %f    %e ',v))
end


y=y_gd(gin);
dt=dx_gd(gin);
n=length(y);

TS=86164.09053083288;

N=round(ceil(k4*n*dt/TS)*TS/dt);
y(n:N)=0;

DF=1/(N*dt);
dn=round(1/(DF*TS));
y=fft(y);
k1=round(band(1)/DF)+1;
k2=round(band(2)/DF);
inif=(k1-1)*DF;
y=y(k1:k2)*dt;
n=length(y);

[i1,i2]=size(mf);
outmf=zeros(i1,n-4*dn);
cohe=zeros(i1+2,n-4*dn);

data=[y(1:n-4*dn) y(1+dn:n-3*dn) y(1+2*dn:n-2*dn) y(1+3*dn:n-dn) y(1+4*dn:n)];

for i = 1:i1
    outmf(i,:)=mf(i,1)*y(1:n-4*dn)+mf(i,2)*y(1+dn:n-3*dn)+...
        mf(i,3)*y(1+2*dn:n-2*dn)+mf(i,4)*y(1+3*dn:n-dn)+mf(i,5)*y(1+4*dn:n);
    for j = 1:5
        if i < 5
            cohe(i,:)=cohe(i,:)+abs(outmf(i,:).*sigs(i,j)).^2;
        elseif i == 5
            cohe(i,:)=cohe(i,:)+abs(outmf(i,:).*sigs(i,j)).^2+abs(outmf(1,:).*sigs(1,j)).^2;
            cohe(i+2,:)=cohe(i+2,:)+abs(outmf(2,:).*sigs(2,j)).^2+abs(outmf(1,:).*sigs(1,j)).^2;
        elseif i == 6
            cohe(i,:)=cohe(i,:)+abs(outmf(i,:).*sigs(i,j)).^2+abs(outmf(3,:).*sigs(3,j)).^2;
            cohe(i+2,:)=cohe(i+2,:)+abs(outmf(4,:).*sigs(4,j)).^2+abs(outmf(3,:).*sigs(3,j)).^2;
        end
    end
    cohe(i,:)=cohe(i,:)./sum(abs(data').^2);
    if i == 5
        cohe(i+2,:)=cohe(i+2,:)./sum(abs(data').^2);
    end
    if i == 6
        cohe(i+2,:)=cohe(i+2,:)./sum(abs(data').^2);
    end
end

[j1,j2]=size(outmf);
x=(inif-fr0+2/TS)+(0:j2-1)*DF;
