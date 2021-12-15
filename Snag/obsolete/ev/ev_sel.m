function out=ev_sel(in,ch,t,a,l)
%EV_SEL  selects events
%
%  out   output evch structure
%
%  in    input evch structure
%  ch    if array, probability selection of different channels,
%         prob<0 -> ch disappear
%  t     if array of length 2, contains tmin, tmax; if tmin > tmax, exclude band
%  a     if array of length 2, contains amin, amax; if amin > amax, exclude band
%  l     if array of length 2, contains lmin, lmax; if lmin > lmax, exclude band

nout=0;
out=in;
r=rand(1,in.n);

ict=0;
if length(t) == 2
    ict=1;
    if t(1) > t(2)
        ict=2;
    end
end

ica=0;
if length(a) == 2
    ica=1;
    if a(1) > a(2)
        ica=2;
    end
end

icl=0;
if length(l) == 2
    icl=1;
    if l(1) > l(2)
        icl=2;
    end
end

lch=length(ch);

for i = 1:in.n
    if ict == 1
        t0=in.ev(i).t;
        if t0 < t(1) | t0 > t(2)
            continue
        end
    elseif ict == 2
        t0=in.ev(i).t;
        if t0 > t(1) & t0 < t(2)
            continue
        end
    end
    
    if ica == 1
        a0=in.ev(i).a;
        if a0 < a(1) | a0 > a(2)
            continue
        end
    elseif ica == 2
        a0=in.ev(i).a;
        if a0 > a(1) & a0 < a(2)
            continue
        end
    end
    
    if icl == 1
        l0=in.ev(i).l;
        if l0 < l(1) | l0 > l(2)
            continue
        end
    elseif icl == 2
        l0=in.ev(i).l;
        if l0 > l(1) & l0 < l(2)
            continue
        end
    end
    
    ch0=in.ev(i).ch;
    if lch > 1 & lch >= ch0
        if r(i) > ch(ch0)
            continue
        end
    end
    nout=nout+1;
    out.ev(nout)=in.ev(i);
end

out.n=nout;
out.ev=out.ev(1:nout);