function t=v2mjd(v)
%V2MJD   converts vectorial time to mjd (modified julian date)

l=length(v);
if l < 6
    v(l+1:6)=0;
    if v(2) == 0
        v(2)=1;
    end
    if v(3) == 0
        v(3)=1;
    end
end
ye=v(1);mo=v(2);da=v(3);ho=v(4);mi=v(5);se=v(6);
t=datenum(ye,mo,da,ho,mi,se)-678942;