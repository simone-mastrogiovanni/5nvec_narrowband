function hlp=hlp_frfilt(len,fr1,fr2,ictyp,icreal)
% HLP_FRFILT  frequency domain high-or-low-pass filter
%
%    hlp=hlp_frfilt(len,fr1,fr2,ictyp,icreal)
%
%   len        length (a multiple of 4)
%   fr1,fr2    fr1-fr2 transition band (units of sampling frequency) 
%              if fr1<fr2 high-pass, otherwise low-pass
%   ictyp      0 linear, 1 parabola, 2 sin, 3 gauss
%   icreal     =1 for real data (default)

% Version 2.0 - May 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n1=round(len*fr1);
n2=round(len*fr2);
hlp=zeros(len,1);

if fr1 <= fr2
    hlp(n2:len)=1;
    switch ictyp
        case 0
            hlp(n1:n2)=((n1:n2)-n1)/(n2-n1);
        case 1
            hlp(n1:n2)=(((n1:n2)-n1)/(n2-n1)).^2;
        case 2
            x=(0:abs(n2-n1))*pi/abs(n2-n1)-pi/2;
            hlp(n1:n2)=(sin(x)+1)/2;
        case 3
            x=3*(n2:-1:1)/(n2-n1);
            hlp(1:n2)=exp(-x.^2);
    end
else
    hlp(1:n2)=1;
    switch ictyp
        case 0
            hlp(n1:-1:n2)=((n2:n1)-n2)/(n1-n2);
        case 1
            hlp(n1:-1:n2)=(((n2:n1)-n2)/(n1-n2)).^2;
        case 2
            x=(0:abs(n2-n1))*pi/abs(n2-n1)-pi/2;
            hlp(n1:-1:n2)=(sin(x)+1)/2;
        case 3
            x=3*(0:len-n2)/(n1-n2);
            hlp(n2:len)=exp(-x.^2);
    end
end

if ~exist('ictyp','var')
    ictyp=3;
end

if ~exist('icreal','var')
    icreal=1;
end

if icreal == 1
    hlp(len:-1:len/2+2)=hlp(2:len/2);
end

hlp=create_frfilt(hlp);