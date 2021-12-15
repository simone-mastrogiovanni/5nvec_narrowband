function sour1=use_ephem_file(ephyes,t,source,tephem,f0ephem,df0ephem)

if ephyes == 0
    sour1=new_posfr(source,t);
else
    source1=source;
    dtime=t-tephem;
    ind1=find(dtime > 0);
    iid=ind1(length(ind1));
    source1.d3f0=2*(df0ephem(iid+1)+df0ephem(iid))*1e-15/((tephem(iid+1)-tephem(iid))^2/6*86400^2)+...
        2*(f0ephem(iid)-f0ephem(iid+1))/((tephem(iid+1)-tephem(iid))^3/12*86400^3);
    source1.ddf0=-source1.d3f0*(tephem(iid)-source1.fepoch)*86400-2*(df0ephem(iid+1)+2*df0ephem(iid))*1e-15/((tephem(iid+1)-tephem(iid))/2*86400)+...
        2*(f0ephem(iid+1)-f0ephem(iid))/((tephem(iid+1)-tephem(iid))^2/6*86400^2);
    source1.df0=-0.5*source1.d3f0*((tephem(iid)-source1.fepoch)*86400)^2+...
        -source1.ddf0*(tephem(iid)-source1.fepoch)*86400+2*df0ephem(iid)*1e-15;
    source1.f0=-1/6*source1.d3f0*((tephem(iid)-source1.fepoch)*86400)^3-0.5*source1.ddf0*((tephem(iid)-source1.fepoch)*86400)^2+...
        -source1.df0*(tephem(iid)-source1.fepoch)*86400+2*f0ephem(iid);
    
    sour1=new_posfr(source1,t);
end
