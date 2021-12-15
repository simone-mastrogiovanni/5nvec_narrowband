function out=fu_sampling(band)
% compute optimal sampling time for sousas
%
%   out=fu_sampling(band)
%
%   band  [minfr maxfr] considering also the overband

% Snag Version 2.0 - March 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

epsfr=0.1;

dband=band(2)-band(1);

intsf=ceil(dband);
semintsf=ceil(dband*2)/2;
optsf=1.001*dband;

intbandout=mod(band,intsf);
i=0;
while intbandout(1) > intbandout(2)
    i=i+1;
    fprintf('Integer frequency : iter = %d  freq = %f  bandout = %f  %f \n',i,intsf,intbandout);
    intsf=intsf+1;
    intbandout=mod(band,intsf);
end

out.intsf=intsf;
out.intbandout0=intbandout;
out.intbasefr=intsf*floor(band(1)/intsf);
out.intbandout=intbandout+out.intbasefr;

semintbandout=mod(band,semintsf);
i=0;
while semintbandout(1) > semintbandout(2)
    i=i+1;
    fprintf('SemiInteger frequency : iter = %d  freq = %f  bandout = %f  %f \n',i,semintsf,semintbandout);
    semintsf=semintsf+0.5;
    semintbandout=mod(band,semintsf);
end

out.semintsf=semintsf;
out.semintbandout0=semintbandout;
out.semintbasefr=semintsf*floor(band(1)/semintsf);
out.semintbandout=semintbandout+out.semintbasefr;

optbandout=mod(band,optsf);
i=0;
while optbandout(1) > optbandout(2)
    i=i+1;
    fprintf('Optimal frequency : iter = %d  freq = %f  bandout = %f  %f \n',i,optsf,optbandout);
    optsf=optsf+epsfr;
    optbandout=mod(band,optsf);
end

out.optsf=optsf;
out.optbandout0=optbandout;
out.optbasefr=optsf*floor(band(1)/optsf);
out.optbandout=optbandout+out.optbasefr;
