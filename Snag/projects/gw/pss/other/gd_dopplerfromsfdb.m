function [dop del]=gd_dopplerfromsfdb(tim,vv,pp,source,cont)
% GD_DOPPLERFROMSFDB computes the percentual doppler shift and the delay
%                    from the data in the sfdb files
%
%  Extract vv,pp,tim for example by [g vv pp tim]=pss_band_recos(vela,'pulsar_3.sbl',1024);
%
%   vv,pp,tim    velocity, position and time
%   source       source structure
%   cont         = 0 -> begins from the time 0 of the first day (default)

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=length(vv);

if ~exist('cont','var')
    cont=0;
end

fprintf('Time interval: %s -> %s /n',mjd2s(tim(1)),mjd2s(tim(n)))

if cont == 0
    tim=tim-floor(tim(1));
end
r=astro2rect([source.a source.d],0);


for i = 1:n
    dop(i)=sum(vv(i,:).*r);
    del(i)=sum(pp(i,:).*r);
end

dop=gd(1+dop);
dop=edit_gd(dop,'x',tim,'ini',tim(1),'capt','doppler effect factor');

del=gd(del);
del=edit_gd(del,'x',tim,'ini',tim(1),'capt','doppler delay');