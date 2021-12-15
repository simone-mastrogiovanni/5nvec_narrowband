function [hsets fsets]=cerca_gdl(h,f,nmin)
% CERCA_GDL  da un'istogramma cerca il numero di gradi di libertà
%
%      h       istogramma
%      nmin    minimo in un bin

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

ngdl=0;
mh=0;
mf=0;

for i = 1:length(h)
    mh=mh+h(i);
    mf=mf+f(i);
    if mh >= nmin
        ngdl=ngdl+1;
        hsets(ngdl)=mh;
        fsets(ngdl)=mf;
        mh=0;
        mf=0;
    end
end

if ngdl > 0
    hsets(ngdl)=hsets(ngdl)+mh;
    fsets(ngdl)=fsets(ngdl)+mf;
else
    hsets(1)=mh;
    fsets(1)=mf;
end
