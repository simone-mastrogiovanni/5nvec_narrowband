function check=check_ana_sidpat(ant,snr,sour)
% check ana_sidpat
%
%    ant    antenna structure
%    snr    snr values
%    sour   source (if absent, casual choice)

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

culm=1;
if ~exist('sour','var')
    [sour0,sour]=pss_rand_sour(1,1,100,0);
end

check.a=sour.a;
check.d=sour.d;
check.eta=sour.eta;
check.psi=sour.psi;

[sidpat,ftsp,v]=pss_sidpat(sour,ant,240,culm); 

sidpat_base=ana_sidpat_base(ant,sour); 
check.ana=ana_sidpat(y_gd(sidpat),sidpat_base);
[cr1,cr2,cr0]=gd2_crest(check.ana.spb_fit,'x','ro');

% sp=y_gd(check.ana.spb_fit);
% [Meta,Ieta]=max(sp');
% [Mpsi,Ipsi]=max(sp);
% figure,plot(sidpat_base.eta,Meta),hold on,plot([check.eta check.eta],[min(Meta) max(Meta)],'g'),title('max eta')
% figure,plot(sidpat_base.psi,Mpsi),hold on,plot([check.psi check.psi],[min(Mpsi) max(Mpsi)],'g'),title('max psi')