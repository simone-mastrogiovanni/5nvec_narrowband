function [dhms DHMS]=s2dhms(s)
% transform seconds in days hour minute and seconds
%
%  dhms   string with the result
%  DHMS   array with the result

d=floor(s/86400);
s=s-d*86400;
h=floor(s/3600);
s=s-h*3600;
m=floor(s/60);
s=s-60*m;

DHMS=[d h m s];

if d == 0
    if h == 0
        if m == 0
            dhms=sprintf('%.2f s',s);
        else
            dhms=sprintf('%d m %.2f s',m,s);
        end
    else
        dhms=sprintf('%d h %d m %.2f s',h,m,s);
    end
else
    dhms=sprintf('%d d %d h %d m %.2f s',d,h,m,s);
end