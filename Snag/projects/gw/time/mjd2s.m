function str=mjd2s(mjd,typ)
%MJD2S   converts a modified julian date to string time
%
%   mjd    the date
%   typ    0 -> only second

if ~exist('typ','var')
    typ=1;
end

str=datestr(floor(mjd*86400)/86400+678942,0);

if typ == 0
    return
end

dif=mjd*86400;
dif=round((dif-floor(dif))*1000000);

str1=sprintf('%06d',dif);
str=[str '.' str1];