function [ncout,synt]=noncohe_cross(sids,tit)
% noncoherent cross-spectrum analysis
%
%    sids   output of sid_sweep_multi with output channels
%    tit    title argument

% Snag Version 2.0 - July 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('tit','var')
    tit=' ';
end

SD=86164.09053083288;
SOL=86400;
nsid=length(sids{1}.ww);

nant=length(sids)-1;

switch nant
    case 2
        in=[1,2];
    case 3
        in=[1,2; 1,3; 2,3];
    case 4
        in=[1,2; 1,3; 1,4; 2,3; 2,4; 3,4];
end

[ncoupl,~]=size(in);
nout=length(sids{1}.datout);   % number of chosen microbands
Nfr_mb=sids{1}.Nfr_mb;   % number of all microbands
dt=sids{1}.datout{1}.dt;
Nfr2=round(Nfr_mb/2);
fr=((0:Nfr_mb-1)-Nfr2)/(Nfr_mb*dt);
elem=0;

for k = 1:ncoupl
    in1=in(k,1);
    in2=in(k,2);
    cover1=sids{in1}.datout{1}.cover;
    cover2=sids{in2}.datout{1}.cover;
    cover=cover1.*cover2;
    figure
    for j = 1:nout
        elem=elem+1;
        y1=sids{in1}.datout{j}.y1;
        y2=sids{in2}.datout{j}.y1;
        
        st=sids{in1}.datout{j}.st;
        
        for ij = 1:nsid
            i1=find(st == ij);
            ww(ij)=mean(cover(i1));
        end
        YY=fft(y1.*conj(y2));
        YY=rota(YY,Nfr2);%length(fr),length(YY)
%         semilogy(fr,abs(YY)),title(sprintf('ants %d %d, out %d',in1,in2,j)),grid on,hold on
        semilogy(fr,abs(YY)),title(sprintf('%s ants %d %d',tit,in1,in2)),grid on,hold on
        if elem == 1
            cross=abs(YY).^2;
        else
            cross=cross+abs(YY).^2;
        end
        ncout{elem}.in1=in1;
        
        ncout{elem}.in2=in2;
        ncout{elem}.iout=j;
        ncout{elem}.YY=YY;
        
        py=y1.*conj(y2); 

        for ij = 1:nsid
            i1=st == ij;
            pp(ij)=mean(py(i1));
            app(ij)=mean(abs(py(i1)));
        end
        jjj=isnan(pp);
        pp(jjj)=0;
        pow_=pp./ww;
        jjj=pow_>0;
        mu=mean(pow_(jjj));
        jjj=pow_==0;
        pow_(jjj)=mu;
        ff_=fft(pow_); 
        
        jjj=isnan(app);
        app(jjj)=0;
        pow=app./ww;
        jjj=pow>0;
        mu=mean(pow(jjj));
        jjj=pow==0;
        pow(jjj)=mu;
        ff=fft(pow);
%         sidsig(j)=sum((abs(ff(2:5)).^2).*weig);
%         sidnois(j)=mean(abs(ff(6:wnois)).^2);
        ncout{elem}.pow_=pow_;
        ncout{elem}.ff_=ff_;
        ncout{elem}.pow=pow;
        ncout{elem}.ff=rota(ff,nsid/2);
    end
    synt{k}.cross=cross;
    xlim([-3e-6,3e-6])
    figure,semilogy(fr,cross),title(sprintf('%s ants %d %d',tit,in1,in2)),grid on
    xlim([-1e-4,1e-4])
end

elem=0;
for k = 1:ncoupl
    in1=in(k,1);
    in2=in(k,2);
    pow=ncout{1}.pow*0;
    pow1=pow;
    pow2=pow;
    for j = 1:nout
        elem=elem+1;
        pow=pow+ncout{elem}.pow;
        pow1=pow1+sids{in1}.datout{j}.pow;
        pow2=pow1+sids{in2}.datout{j}.pow;
    end
    ff=fft(pow);
    ff1=fft(pow1);
    ff2=fft(pow2);
    figure,plot((0:nsid-1)*24/nsid,pow),grid on,hold on,plot((0:nsid-1)*24/nsid,pow1,'r'),plot((0:nsid-1)*24/nsid,pow2,'g'),title(['sid pattern ' tit])
    ccpow=circ_cross(pow1-min(pow1),pow2-min(pow2)); 
    figure,plot((0:nsid-1)*24/nsid,ccpow),grid on,title(['circular cross-corr ' tit])
    synt{k}.ccorr=ccpow;
    ccff=abs(fft(ccpow));
    figure,semilogy(0:nsid/2-1,ccff(1:nsid/2)),grid on,hold on,semilogy(0:nsid/2-1,ccff(1:nsid/2),'r.')
    title(['circular cross-corr spectrum ' tit])
    figure,semilogy(0:nsid/2-1,abs(ff(1:nsid/2))),grid on,hold on,semilogy(0:nsid/2-1,abs(ff(1:nsid/2)),'r.')
    semilogy(0:nsid/2-1,abs(ff1(1:nsid/2)),'mx'),semilogy(0:nsid/2-1,abs(ff2(1:nsid/2)),'gx'),title(['sid pattern harmonics ' tit])
end