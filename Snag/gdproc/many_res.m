function mr=many_res(gin,res,typ)
% MANY_RES  multiple low-pass filter to reduce resolution
%
%    mr=many_res(gin,res)
%
%   gin   input gd or array
%   res   array of resolutions (integer, > 1)
%   typ   0 plot, 1 semilogx, 2 semilogy, 3 loglog

% Version 2.0 - December 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isa(gin,'gd')
    y=y_gd(gin);
    dx=dx_gd(gin);
    ic=1;
else
    y=gin;
    dx=1;
    ic=0;
end
n=length(y);

if ~exist('typ','var')
    typ=0;
end

switch typ
    case 0
        figure,plot(gin),hold on
    case 1
        figure,semilogx(gin),hold on
    case 2
        figure,semilogy(gin),hold on
    case 3
        figure,loglog(gin),hold on
end

for i = 1:length(res)
    w=exp(-1/res(i));
    y1=filtfilt(1/res(i),[1 -w],y);
    y1=y1(1:res(i):n);
    if ic == 1
        y1=edit_gd(gin,'y',y1,'dx',dx*res(i));
    end
    mr{i}=y1;
    [tcol colstr colchar]=rotcol(i+1); 
    switch typ
        case 0
            plot(y1,colchar);
        case 1
           semilogx(y1,colchar);
        case 2
            semilogy(y1,colchar);
        case 3
            loglog(y1,colchar);
    end
end

grid on