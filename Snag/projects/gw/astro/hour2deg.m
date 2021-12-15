function deg=hour2deg(hour)
% HOUR2DEG  transform hour to degrees (for right ascension)
%
%   hour   string (hh:mm:ss.ss) or vector [h m s]

if ischar(hour)
    [sn rs]=strtok(hour,':');
    hour=zeros(1,3);
    hour(1)=str2num(sn);
    [sn rs]=strtok(rs,':');
    hour(2)=str2num(sn);
    [sn rs]=strtok(rs,':');
    hour(3)=str2num(sn);
end

deg=15*(hour(1)+hour(2)/60+hour(3)/3600);

end
    
