function str=mjds2s(mjd)
%MJD2S   converts a modified julian date array to string time

n=length(mjd);
str='';

for i = 1:n
	str0=datestr(floor(mjd(i)*86400)/86400+678942,0);
	
	dif=mjd(i)*86400;
	dif=round((dif-floor(dif))*1000000);
	
	str1=sprintf('%06d \n',dif);
	str=[str str0 '.' str1];
end