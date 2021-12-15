function time=t0s_decode(t0s)
%T0S_DECODE   decodes the frame time string in MJD
%
%     time=t0s_decode(t0s)

i1=findstr(t0s,'Starting GPS time:');
str1=t0s(i1+22:i1+41);

mo=str1(1:3);
da=str1(5:6);
ti=str1(8:15);
ye=str1(17:20);

str2=[da '-' mo '-' ye ' ' ti];
t=datenum(str2)-678942;

i2=findstr(t0s,'(and');
i3=findstr(t0s,' usec)');
mic=sscanf(t0s(i2+4:i3),'%d');
time=t+mic/86400000000;