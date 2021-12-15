function ok=coinfun_0(len1,len2,amp1,amp2)
%COINFUN_0  basic coincidence function (for ev_coin)
%
%  len1,len2    lengths of the coincidence events
%  amp1,amp2    amplitudes of the coincidence events

ok=1;
r=amp1/amp2;

if r > 2 | r < 0.5
    ok=0;
end
