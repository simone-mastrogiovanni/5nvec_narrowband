function ev_plot(ev, nch, type)
%EV_PLOT  plots an array of events
%
%    ev      array of events
%            ev(i).t    time
%            ev(i).tm   time of the maximum
%            ev(i).ct   channel type
%            ev(i).cf   channel frequency
%            ev(i).a    amplitude
%            ev(i).cr   critical ratio
%            ev(i).l    length
%            ev(i).ci   cluster index (0 default)
%            ev(i).sh   shape
%    nch     number of channels
%    type    = 0 simple
%            = 1 amplitude colored
%            = 2 length colored
%            = 3 both
%            = 4 stem3 ampiezza
%            = 5 stem3 lunghezza
%            = 6 stem3 ambedue

n=length(ev);

t(1:n)=0;
y=t;
a=t;
l=t;

for i = 1:n
    t(i)=ev(i).t;
    y(i)=ev(i).ch;
    a(i)=ev(i).a;
    l(i)=ev(i).l;
end

amin=min(a);
amax=max(a);
lmin=min(l);
lmax=max(l);
tmin=min(t);
tmax=max(t);
ymin=min(y);
ymax=max(y);

tm=(tmax-tmin)/30;
tmin=tmin-tm;
tmax=tmax+tm;

ym=(ymax-ymin);
ymin=ymin-ym/20;
ymax=ymax+ym/20;
if ymax/ym < 1.5
    ymin=0;
end

figure

if type == 0
    plot(t,y,'bx');
else
    if type == 1 | type == 3
        color_sc=['''yo''';'''go''';'''co''';'''mo''';'''ro''';'''bo''';'''ko'''];
        for i = 1:n
            amp=ceil((a(i)-amin)*6/(amax-amin))+1;
            eval(['plot(t(i),y(i),' color_sc(amp,:) ')']);
            hold on
        end
    end
    if type == 2 | type == 3
        color_sc=['''yx''';'''gx''';'''cx''';'''mx''';'''rx''';'''bx''';'''kx'''];
        for i = 1:n
            amp=ceil((l(i)-lmin)*6/(lmax-lmin))+1;
            eval(['plot(t(i),y(i),' color_sc(amp,:) ')']);
            hold on
        end
    end
    if type == 4
        stem3(t,y,a,'r')
    end
    if type == 5
        stem3(t,y,l*amax/lmax,'b')
    end
    if type == 6
        stem3(t,y,a,'r'), hold on
        stem3(t,y,l*amax/lmax,'b')
    end
end

if type <= 3
    zoom on
else
    rotate3d on
end
axis([tmin tmax ymin ymax])