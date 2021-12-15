function s=mjd2_d_t(mjd)
%MJD2_d_t   converts a modified julian date to DDDDDDDD_TTTTTT

v=datevec(mjd+678942);
v(6)=floor(v(6)+0.0005);
s=sprintf('_%04d%02d%02d_%02d%02d%02d_',v);