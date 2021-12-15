function [out_sid,ftrim]=bsd_sid_wrap(in,sour,nsid,sband,epoch)
% wrapper for bsd_sid and ana_sid
%
%   in     input bsd (not corrected)
%   sour   source (alpha and fr)
%   nsid   number of sidereal bins (def 48)
%   sband  sub band (in units of 1/SD; def 10)
%   epoch  if present, if = 0 the t0 is epoch

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;

if ~exist('nsid','var')
    nsid=48;
end
if nsid == 0
    nsid=48;
end

if ~exist('sband','var')
    sband=10;
end
if sband == 0
    sband=10;
end

cont=ccont_gd(in);
ant=cont.ant;

if exist('epoch','var')
    if epoch == 0
        epoch=cont.t0;
    end
    sour=new_posfr(sour,epoch);
end
    
in=bsd_dopp_sd(in,sour);

ftrim=bsd_ftrim(in,sour.f0+(sband/SD)*[-0.5 0.5],10,1);

out_sid=bsd_sid(ftrim,sour,nsid);

eval(['sidpat_base=ana_sidpat_base(' ant ',sour);'])
out_sid.ana=ana_sidpat(out_sid.pow,sidpat_base)