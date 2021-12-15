function dd=ev_dens(evch,selch,dt,n)
%EV_DENS   event density 
%
%   evch    event-channel structure; it can be also a simple double array,
%           with event times
%   selch   selection array for the channels (0 exclude, 1 include)
%   dt      interval (s); if 0, consider n
%   n       number of bins
%
%   dd      density diagram (gd)
%

% Version 2.0 - April 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


i1=0;i2=0;

if isnumeric(evch)
    t1=evch;
    nev=length(t1);
else
    ewyes=0;
	if isfield(evch,'ew')
        ewyes=1;
	else
        evch.ew=ev2ew(evch.ev);
	end

	nchtot=length(evch.ch.an);
	t1(1:evch.n)=0;
	
	for i = 1:evch.n
        for j = find(selch==1)
            if j == evch.ew.ch(i)
                i1=i1+1;
                t1(i1)=evch.ew.t(i);
            end
        end
	end
	
	nev=i1
	t1=t1(1:i1);
end

mi=min(t1);
ma=max(t1);
mami=ma-mi;
if dt > 0
    n=ceil(mami*86400/dt);
else
    dt=86400*mami/n;
end
dx=mami/n;
x=(0:(n-1))*dx+mi;
hi=hist(t1,x+dx/2);
%hi=hist(t1,x);
figure

v=mjd2v(mi);
v(2:3)=1;v(4:6)=0;
miy=v2mjd(v);

x1=(0:n)*dx+mi-miy;
hi1=hi;
hi1(n+1)=hi1(n);
stairs(x1,hi1);zoom on, grid on

dd=gd(hi);
%x=x-miy;%miy,min(x),max(x)
%dd=edit_gd(dd,'capt','Density diagram','x',x,'type',2);
dd=edit_gd(dd,'capt','Density diagram','ini',x(1),'dx',dt/86400);

bin=mami/n;
secbin=bin*86400
