function bsd_plot(typ,in,col)
% plots a bsd
%
%  typ    1  mjd,real
%         11 mjd,imag
%         21 mjd,abs
%         2  doys,real
%         12 doys,imag
%         22 doys,abs
%         3  s from 0 h,real
%         13 s from 0 h,imag
%         23 s from 0 h,abs
%          negative: zero window
%  in     bsd
%  col    color char 'b','r',... def 'b'

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('col','var')
    col='b';
end

if typ < 0
    typ=-typ;
    icz=1;
else
    icz=0;
end

absc=ceil(typ/10);
what=typ-(absc-1)*10;

x=x_gd(in);
y=y_gd(in);
cont=cont_gd(in);
t0=cont.t0;

switch what
    case 1
        y=real(y);
    case 2
        y=imag(y);
    case 3
        y=abs(y);
end

switch absc
    case 1
        x=x/86400+t0;
    case 2
        v=mjd2v(t0);
        t00=v2mjd([v(1) 1 1 0 0 0]);
        x=x/86400+t0-t00;
    case 3
        x=x+(t0-floor(t0))*86400;
end

eval(['plot(x,y,''' col '''),grid on'])

if icz > 0
    zers=cont.tfstr.zeros;
    [nz,~]=size(zers);
    
    switch absc
    case 1
        zers=zers/86400+t0;
    case 2
        v=mjd2v(t0);
        t00=v2mjd([v(1) 1 1 0 0 0]);
        zers=zers/86400+t0-t00;
    case 3
        zers=zers+(t0-floor(t0))*86400;
    end
    
    ama=max(y)/2;
    xx=zeros(1,4*nz+2);
    yy=xx;
    xx(1)=x(1);
    yy(1)=0;
    xx(1,4*nz+2)=x(end);
    for i = 2:4:4*nz
        ii=ceil(i/4);
        xx(i)=zers(ii,1);
        xx(i+1)=xx(i);
        xx(i+2)=zers(ii,2);
        xx(i+3)=xx(i+2);
        yy(i)=0;
        yy(i+1)=ama;
        yy(i+2)=ama;
        yy(i+3)=0;
    end
    hold on,plot(xx,yy,'g')
end