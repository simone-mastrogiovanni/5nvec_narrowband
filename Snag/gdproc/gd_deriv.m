function [dy,dy1,dy2]=gd_deriv(y)
% computes an unbiased derivative 
%
%     y    input gd or array (the first and last samples may be unmeaningful)
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

n=length(y);
dy2=diff(y)/dx;
dy2(n)=dy2(n-1);
dy1=-diff(y(n:-1:1))/dx;
dy1(n)=dy1(n-1);
dy1=dy1(n:-1:1);

dy=(dy1+dy2)/2;

if icgd == 1
    dy=edit_gd(y1,'y',dy);
    dy1=edit_gd(y1,'y',dy1);
    dy2=edit_gd(y1,'y',dy2);
end