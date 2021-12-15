function out=ev_sel(in,ch,t,a,l,fl)
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
%  fl    if array of length 2, contains flmin, flmax; if flmin > flmax, exclude band

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nout=0;
out=in;
r=rand(1,in.n);

ewyes=0;
if isfield(in,'ew')
    ewyes=1;
end

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

icfl=0;
if length(fl) == 2
    icfl=1;
    if fl(1) > fl(2)
        icfl=2;
    end
end

lch=length(ch);

for i = 1:in.n
    if ewyes > 0
        t0=in.ew.t(i);
        a0=in.ew.a(i);
        l0=in.ew.l(i);
        fl0=in.ew.fl(i);
        ch0=in.ew.ch(i);
    else
        t0=in.ev(i).t;
        a0=in.ev(i).a;
        l0=in.ev(i).l;
        fl0=in.ev(i).fl;
        ch0=in.ev(i).ch;
    end
    
    if ict == 1
        if t0 < t(1) | t0 > t(2)
            continue
        end
    elseif ict == 2
        if t0 > t(1) & t0 < t(2)
            continue
        end
    end
    
    if ica == 1
        if a0 < a(1) | a0 > a(2)
            continue
        end
    elseif ica == 2
        if a0 > a(1) & a0 < a(2)
            continue
        end
    end
    
    if icl == 1
        if l0 < l(1) | l0 > l(2)
            continue
        end
    elseif icl == 2
        if l0 > l(1) & l0 < l(2)
            continue
        end
    end
    
    if icfl == 1
        if fl0 < fl(1) | fl0 > fl(2)
            continue
        end
    elseif icfl == 2
        if fl0 > fl(1) & fl0 < fl(2)
            continue
        end
    end
    
    if lch > 1 & lch >= ch0
        if r(i) > ch(ch0)
            continue
        end
    end
    nout=nout+1;
    if ewyes > 0
        out.ew.t(nout)=in.ew.t(i);
        out.ew.tm(nout)=in.ew.tm(i);
        out.ew.a(nout)=in.ew.a(i);
        out.ew.cr(nout)=in.ew.cr(i);
        out.ew.a2(nout)=in.ew.a2(i);
        out.ew.l(nout)=in.ew.l(i);
        out.ew.fl(nout)=in.ew.fl(i);
        out.ew.ch(nout)=in.ew.ch(i);
        out.ew.ci(nout)=in.ew.ci(i);
    else
        out.ev(nout)=in.ev(i);
    end
end

out.n=nout;
if ewyes > 0
    out.ew.t=out.ew.t(1:nout);
    out.ew.tm=out.ew.tm(1:nout);
    out.ew.a=out.ew.a(1:nout);
    out.ew.cr=out.ew.cr(1:nout);
    out.ew.a2=out.ew.a2(1:nout);
    out.ew.l=out.ew.l(1:nout);
    out.ew.fl=out.ew.fl(1:nout);
    out.ew.ch=out.ew.ch(1:nout);
    out.ew.ci=out.ew.ci(1:nout);
else
    out.ev=out.ev(1:nout);
end