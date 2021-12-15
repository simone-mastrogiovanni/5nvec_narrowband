function [g,t]=sabrina_read(file,ini)
%SABRINA_READ reads a file in Sabrina format in a gd
%
%    [g,t]=sabrina_read(file,ini)
%
%    t init in seconds from midnight
%    ini = -1 ini at midnight, time in days, otherwise in seconds
%
% Data written on 2 columns (x and y), no header

a=readascii(file,0,2);
x=a(:,1);
y=a(:,2);
t=x(1)*86400;
dx=x(2)-x(1);
if ini >= 0
    dx=dx*86400;
    if ini > 0
        ini=x(1)*86400-ini;
    end
else
    ini=x(1)-floor(x(1));
end
g=gd(y);
g=edit_gd(g,'dx',dx,'ini',ini);