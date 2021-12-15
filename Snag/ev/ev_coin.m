function [dcp,ini3,len3,dens]=ev_coin(evch,selch,wind,dt,n,type,coinfun)
%EV_COIN   event coincidence by delay coincidence plot
%
%   evch      event-channel structure
%   selch     selection array for the channels (0 exclude, 1 first group, 
%                 2 second group, 3 both)
%   wind(:,2) observation window; if 0, from the first to the last event
%   dt        time resolution (s)
%   n         number of delays per side
%   type      type(1): 1  only event maxima
%                      2  whole length coincidences
%             type(2): 1  normal
%                      2  density normalized 
%             type(3)  3  density time scale (s) for density normalization
%   coinfun   coincidence function handle; to create, coinfun=@func.
%             If exists, external coincidence function is enabled. The
%             coincidence function is > 0 if the events are "compatible";
%             the inputs are (len1,len2,amp1,amp2), that are the lengths
%             and amplitudes for the two coincident event
%
%   dcp     output delay coincidence plot (gd)
%   ini3    coincidence starting time
%   len3    coincidence length
%   dens    coincidence density

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

cf=0;
if exist('coinfun')
    if isa(coinfun,'function_handle')
        cf=1;
    else
        disp(' *** NOT A FUNCTION HANDLE !!!')
    end
end
len3=0;
hi=0;

type2=1;
type3=3600;
if length(type) > 1
    type2=type(2);
end
if length(type) > 2
    type3=type(3);
end
mode(1)=type2;
mode(2)=type3;

ewyes=0;
if isfield(evch,'ew')
    ewyes=1;
else
    evch.ew=ev2ew(evch.ev);
end

nchtot=length(evch.ch.an);
i1=0;i2=0;
t1(1:evch.n)=0;
l1=t1;
t2=t1;
l2=t1;
if cf == 1
    a1=t1;
    a2=a1;
end

switch type(1)
    case 1
		for i = 1:evch.n
            for j = find(selch==1|selch==3)
                if j == evch.ew.ch(i)
                    i1=i1+1;
                    t1(i1)=evch.ew.tm(i);
                    l1(i1)=evch.ew.l(i);
                    if cf == 1
                        a1(i1)=evch.ew.a(i);
                    end
                end
            end
            for j = find(selch==2|selch==3)
                if j == evch.ew.ch(i)
                    i2=i2+1;
                    t2(i2)=evch.ew.tm(i);
                    l2(i2)=evch.ew.l(i);
                    if cf == 1
                        a2(i2)=evch.ew.a(i);
                    end
                end
            end
		end
    case 2
		for i = 1:evch.n
            for j = find(selch==1|selch==3)
                if j == evch.ew.ch(i)
                    i1=i1+1;
                    t1(i1)=evch.ew.t(i);
                    l1(i1)=evch.ew.l(i);
                    if cf == 1
                        a1(i1)=evch.ew.a(i);
                    end
                end
            end
            for j = find(selch==2|selch==3)
                if j == evch.ew.ch(i)
                    i2=i2+1;
                    t2(i2)=evch.ew.t(i);
                    l2(i2)=evch.ew.l(i);
                    if cf == 1
                        a2(i2)=evch.ew.a(i);
                    end
                end
            end
		end
end
i1,i2
t1=t1(1:i1);
l1=l1(1:i1);
t2=t2(1:i2);
l2=l2(1:i2);
if cf == 1
    a1=a1(1:i1);
    a2=a2(1:i2);
end

if cf == 0
	switch type(1)
        case 1
            [dcp,ini3,dens]=vec_coin_nolen(t1,t2,dt,n,mode);
        case 2
            [dcp,ini3,len3]=vec_coin(t1,l1,t2,l2,dt,n);
	end
else
	switch type(1)
        case 1
            [dcp,ini3,dens]=vec_coin_nolen(t1,t2,dt,n,mode,coinfun,a1,a2);
        case 2
            [dcp,ini3,len3]=vec_coin(t1,l1,t2,l2,dt,n,coinfun,a1,a2);
	end
end

m=mean(dcp),sd=std(dcp)

if type2 == 1
    x=(0:1:max(dcp));
else
    midcp=min(dcp);
    madcp=max(dcp);
    n=(length(dcp)/20+20)
    x=(0:n-1)*(madcp-midcp)/n;
end

hi=histc(dcp,x);
figure
stairs(x,log10(onlypos(hi)));zoom on, grid on

dcp=gd(dcp);
dcp=edit_gd(dcp,'ini',-n*dt,'dx',dt,'capt','Delay Coincidence Plot');