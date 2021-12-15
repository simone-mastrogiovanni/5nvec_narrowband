function y=am_filter(x,amf,inv,norm)
%AM_FILTER  filters a double array or a gd 
%
%     y=am_filter(x,amf,inv,norm)
%
%   x       input data
%   amf     filter am object
%   inv     = 1 applied in reverse order, = 0 normal
%   norm    normalization; 0 no, 1 delta, 2 noise
%
%
%   y       output

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('norm','var')
    norm=0;
end
su=1;
if norm > 0
    switch norm
        case 1
            n2000=2000;
            win=y_gd(am_trfun_nofig(amf,n2000,1));
            su=abs(sum(win))/n2000;
        case 2
            n2000=2000;
            win=y_gd(am_trfun_nofig(amf,n2000,1));
            su=sqrt(sum(win.^2)/n2000);
    end
end

b(1)=amf.b0/su;
if amf.nb > 0
    b(2:amf.nb+1)=amf.b;
end
a(1)=1;
if amf.na > 0
    a(2:amf.na+1)=amf.a;
end

ic=0;
if ~isnumeric(x)
    g=x;
    x=y_gd(x);
    ic=1;
end
if ~exist('inv','var')
    inv=0;
end

if inv == 1
    x=x(length(x):-1:1);
end

y=filter(b,a,x);

if amf.bilat == 1
    y=filter(b,a,y(length(y):-1:1));
    inv=1;
end

if inv == 1
    y=y(length(x):-1:1);
end

if ic == 1
    y=edit_gd(g,'y',y);
end