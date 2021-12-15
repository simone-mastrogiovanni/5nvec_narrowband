function out=stat_nonzero(gin)
% statistics on non-zero data
%
%     out=stat_nonzero(gin)
%
%   gin   arragin, gd or gd2

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isa(gin,'gd')
    gin=y_gd(gin);
elseif isa(gin,'gd2')
    gin=y_gd2(gin);
end

n0=length(gin);
ii=find(gin ~= 0);
gin=gin(ii);

ic=1;
if isreal(gin)
    ic=0;
end

n=length(gin);

nh=min(250,round(sqrt(n)));

rgin=real(gin);
[his,xhis]=hist(rgin,nh);
out.n0=n0;
out.n=n;
out.hist=his;
out.xhist=xhis;
figure,stairs(xhis,his),grid on,set(gca, 'YScale', 'log')
if ic == 1
    igin=imag(gin);
    [his1,xhis1]=hist(igin,nh);
    hold on,stairs(xhis1,his1,'r'),grid on,set(gca, 'YScale', 'log')
    
    out.mu=mean(rgin)+1j*mean(igin);
    out.median=median(rgin)+1j*median(igin);
    out.stdev=std(rgin)+1j*std(igin);
    out.min=min(rgin)+1j*min(igin);
    out.max=max(rgin)+1j*max(igin);
    out.hist=his+1j*his1;
    out.xhist=xhis+1j*xhis1;
else
    out.mu=mean(rgin);
    out.median=median(rgin);
    out.std=std(rgin);
    out.min=min(rgin);
    out.max=max(rgin);
end
