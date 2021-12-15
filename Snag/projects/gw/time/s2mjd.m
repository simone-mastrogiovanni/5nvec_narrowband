function t=s2mjd(str)
%S2MJD   converts string time to mjd (modified julian date)

t=datenum(str)-678942;