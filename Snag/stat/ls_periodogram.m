function pls=ls_periodogram(t,y,freq)
% ls_periodogram  Lomb-Scargle periodogram
%
%    t      times
%    y      amplitude
%    freq   [min_freq max_freq resolution]

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

T=max(t)-min(t);
t=t-min(t);
dfr=1/(T*freq(3));
fr=freq(1):dfr:freq(2);
pls=fr*0;

for i = 1:length(fr)
    om=2*pi*fr(i);
    tau=atan(sum(sin(2*om*t))/sum(cos(2*om*t)))/(2*om);
    
    pls(i)=(sum(y.*cos(om*(t-tau))).^2/sum(cos(om*(t-tau)).^2)+...
        sum(y.*sin(om*(t-tau))).^2/sum(sin(om*(t-tau)).^2))/2;
end

pls=gd(pls);
pls=edit_gd(pls,'ini',freq(1),'dx',dfr);