function evch=crea_ev(n,chstr,tobs)
%CREA_EV  creates an event-channel structure
%
%    Event structure ev data members:
%            ev(i).t        time (days, normally mjd)
%            ev(i).tm       time of the maximum
%            ev(i).ch       channel
%            ev(i).a        amplitude
%            ev(i).cr       critical ratio
%            ev(i).a2       secondary amplitude (e.g. bandwidth)
%            ev(i).l        length (s)
%            ev(i).fl       flag
%            ev(i).ci       cluster index (0 default)
%            ev(i).shy()    shape
%            ev(i).sht      shape initial time
%            ev(i).shdt     shape sampling time
%
%
%   Array event structure ew data members
%
%           ew.nev          number of event
%           ew.t()          time (days, normally mjd)
%           ew.tm()         time of the maximum
%           ew.ch()         channel
%           ew.a()          amplitude
%           ew.cr()         critical ratio
%           ew.a2()         secondary amplitude (e.g. bandwidth)
%           ew.l()          length (s)
%           ew.fl()         flag
%           ew.ci()         cluster index (0 default)
%
%  The ew array structure is more compact and simpler to use, but doesn't
%  have the shape.
%  The two functions ev2ew and ew2ev convert ev in ew and vice versa.
%
%         tobs   observation time span

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nchtot=length(chstr.an);
nch=zeros(1,chstr.na);
for i = 1:chstr.na
    nch(i)=length(find(chstr.an==i));
end

nlc=sum(chstr.lcn);
nld=chstr.lml;
nldtot=sum(nld);
ngw=chstr.lmg;
ntot=nlc+nldtot+ngw;
fact=n/ntot
nlc=round(nlc*fact);
nld=round(nld*fact);
nldtot=sum(nld);
ngw=round(ngw*fact);

tlc=rand(1,nlc)*tobs;
tld=rand(1,nldtot)*tobs;
tgw=rand(1,ngw)*tobs;

maxev=nlc+sum(nld.*nch)+ngw*nchtot;

e(maxev).t=0;
e(maxev).tm=0;
e(maxev).ch=0;
e(maxev).a=0;
e(maxev).cr=0;
e(maxev).a2=0;
e(maxev).l=0;
e(maxev).fl=0;
e(maxev).ci=0;
%e(maxev).shy=[];
%e(maxev).sht=0;
dt=6;

app=0;
rapp0=1;
for j = 1:nchtot
    app=app+chstr.lcn(j);
    rapp=round(app*fact);
    for k = rapp0:rapp
        dt1=dt*rand(1);
        a=randn(1).^2;
        e(k).t=tlc(k);
        e(k).tm=tlc(k)+dt1/(2*86400);
        e(k).ch=j;
        e(k).a=a;
        e(k).cr=a;
        e(k).a2=0;
        e(k).l=dt1;
        e(k).fl=0;
        e(k).ci=0;
        %e(k).shy=[];
        %e(k).sht=0;
    end
    rapp0=rapp;
end

ii=nlc;
kk=0;
kch0=0;
for j = 1:chstr.na
    for i = 1:nld(j)
        kk=kk+1;
        for k = 1:nch(j)
            kch=kch0+k;
            if rand(1) > chstr.lds(kch)
                ii=ii+1;
                dt1=dt*rand(1);
                a=randn(1).^2;
                e(ii).t=tld(kk);
                e(ii).tm=tld(kk)+dt1/(2*86400);
                e(ii).ch=kch;
                e(ii).a=a;
                e(ii).cr=a;
                e(ii).a2=0;
                e(ii).l=dt1;
                e(ii).fl=0;
                e(ii).ci=0;
                %e(ii).shy=[];
                %e(ii).sht=0;
            end
        end
    end
    kch0=kch0+nch(j);
end

for i = 1:ngw
    for k = 1:nchtot
        if rand(1) > chstr.lds(k)
            ii=ii+1;
            dt1=dt*rand(1);
            a=randn(1).^2;
            e(ii).t=tgw(i);
            e(ii).tm=tgw(i)+dt1/(2*86400);
            e(ii).ch=k;
            e(ii).a=a;
            e(ii).cr=a;
            e(ii).a2=0;
            e(ii).l=dt1;
            e(ii).fl=0;
            e(ii).ci=0;
            %e(ii).shy=[];
            %e(ii).sht=0;
        end
    end
end

e=e(1:ii);
e=sort_ev(e);

evch.ev=e;
evch.ch=chstr;
evch.n=ii;

