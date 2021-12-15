function [dy,dy1,dy2]=gd_deriv_enh(y,enh)
% computes an unbiased derivative, enhanced sampling 
%
%     y    input gd or array (the first and last samples may be unmeaningful)
%     enh  sampling enhancement (def 10)
%
%     dy1  left derivative  (derivative of 000111 is 000100)
%     dy2  right derivative (derivative of 000111 is 001000)
%     dy   mean derivative

% Snag Version 2.0 - December 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca and Sabrina DÁntonio
% Department of Physics - Sapienza University - Rome

icgd=1;
if ~isnumeric(y)
    dx=dx_gd(y);
    y1=y;
    y=y_gd(y);
else
    dx=1;
    icgd=0;
end

if ~exist('enh','var')
    enh=10;
end

n=length(y);

t=1:n;
tt=1:1/enh:n;
nn=length(tt);
yy=spline(t,y,tt);

dy2=diff(yy)*enh/dx;
dy2(nn)=dy2(nn-1);
dy1=-diff(yy(nn:-1:1))*enh/dx;
dy1(nn)=dy1(nn-1);
dy1=dy1(nn:-1:1);

dy1=dy1(1:enh:nn-1);
dy2=dy2(1:enh:nn-1);

dy=(dy1+dy2)/2;

if icgd == 1
    dy=edit_gd(y1,'y',dy);
    dy1=edit_gd(y1,'y',dy1);
    dy2=edit_gd(y1,'y',dy2);
end