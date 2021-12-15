function out=sid_det(N,direc,ant,nharm)
% sidereal detection components
%
%   N       number of sources
%   direc   source position or 1 (all) or 0 (only noise)
%   ant     antenna (structure)
%   nharm   number of harmonics

% Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n240=240;
s=zeros(nharm+1,N);
pow=zeros(1,N);

if isnumeric(direc)
    if direc == 1
        disp('  ---  All sky ')
        sour=pss_rand_sour(N,1.e-25,[100 100 1],[0 0 1]);
    end
    if direc == 0
        disp('  ---  only noise ')
        for i = 1:N
            nois=exprnd(1,1,n240);
            fnois=fft(nois);
%             s(1:nharm+1,i)=abs(fnois(1:nharm+1)).^2;
            s(1:nharm+1,i)=abs(fnois(1:nharm+1));
            pow(i)=sum(nois)/n240;
        end
        out.s=s;
        out.s_mu=mean(s');
        out.s_std=std(s');
        out.pow=pow;
        out.pow_mu=mean(pow);
        out.pow_std=std(pow);
        out.sidp=nois;
        return
    end
else
    alfa=direc.a;
    delta=direc.d;
    sour=pss_rand_direc_sour(N,alfa,delta,1.e-25,[100 100 1],[0 0 1]);
    sour1=direc;
end

out.sour=sour;

for i = 1:N
    sour1.a=sour(i,9);
    sour1.d=sour(i,10);
    sour1.eta=sour(i,7);
    sour1.psi=sour(i,8);
    [sidpat,ftsp,v]=pss_sidpat(sour1,ant,n240,1);
%     s(1:nharm+1,i)=abs(ftsp(1:nharm+1)).^2;
    s(1:nharm+1,i)=abs(ftsp(1:nharm+1));
    pow(i)=sum(sidpat)/n240;
end

out.sidp=sidpat;
out.s=s;
out.s_mu=mean(s');
out.s_std=std(s');
out.pow=pow;
out.pow_mu=mean(pow);
out.pow_std=std(pow);