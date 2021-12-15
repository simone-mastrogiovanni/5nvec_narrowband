function g=gd_smooth(gin,len,icb,typ)
%GD_SMOOTH smooth a gd operating in the time domain
%
%   len   length of smoothing
%   icb   = 0 normal
%         = 1 bidirectional
%         =-1 only retrograde
%   typ   type (1 rectangular, 0 exponential)

% Version 2.0 - April 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isa(gin,'gd')
    g=y_gd(gin);
else
    g=gin;
end

n=length(g);
ii=ones(n,1);

if ~exist('icb')
    icb=1;
end

if ~exist('typ')
    typ=1;
end

if icb >= 1
    len=ceil(len/2);
end

if typ == 1
    b=ones(1,len)/len;

    switch icb
        case 1
            g=filtfilt(b,1,g);
            ii=filtfilt(b,1,ii);
            g=g./ii';
        case 0
            g=filter(b,1,g);
            ii=filter(b,1,ii);
            g=g./ii';
        case -1
            g=g(length(g):-1:1);
            g=filter(b,1,g);
            ii=filter(b,1,ii);
            g=g./ii';
            g=g(length(g):-1:1);
    end
else
    w=exp(-1/len);
    a(1)=1;
    a(2)=-w;

    switch icb
        case 1
            g=filtfilt(1,a,g);
            ii=filtfilt(1,a,ii);
            g=g./ii';
        case 0
            g=filter(1,a,g);
            ii=filter(1,a,ii);
            g=g./ii';
        case -1
            g=g(length(g):-1:1);
            g=filter(1,a,g);
            ii=filter(1,a,ii);
            g=g./ii';
            g=g(length(g):-1:1);
    end
end

if isa(gin,'gd')
    g=edit_gd(gin,'y',g,'addcapt','smoothing on:');
end
