function [h,xout]=map2hist(m,n,par,linlog)
%MAP2HIST  from a map, creates a new map of histograms
%
%     m      input map (the second dimension is preserved)
%     n      number of bins
%    par     parameters of the histograms (par(i,1)=min, par(i,2)=max)
%               par = 0 automatic, all equal
%               par = 1 automatic, adapted
%   linlog   =0 -> linear, =1 -> logarithmic (base 10)
%
%     h      histograms map
%    xout    h x values

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if linlog == 1
    m=log10(m);
    if length(par) > 1
        par=log10(par);
    end
end

siz=size(m);

if length(par) == 1
    if par == 0
        [h,xout]=hist(m,n);
    else
        h=zeros(n,siz(2));
        xout=h;
        for i = 1:siz(2)
            [ha,xa]=hist(m(:,i),n);
            h(:,i)=ha.';
            xout(:,i)=xa.';
        end
    end
    return
else
    for i = 1:siz(2)
        dx=(par(i,2)-par(i,1))/n;
        xout(:,i)=((1:n)*dx-dx/2)+par(i,1);
        h(:,i)=hist(m(:,i),xout(:,i));
    end
end
        
    
    