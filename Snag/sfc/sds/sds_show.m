function sds_=sds_show(sds_)
%SDS_SHOW  shows the sds structure

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if exist('sds_')
    sds_
else
    file=selfile(' ');
    sds_=sds_open(file)
end

strt=mjd2s(sds_.t0);
disp(['start at ' strt])
disp(' ')
disp(['Label :  ' char(sds_.label')])
disp(' ')
disp(['Caption :  '  sds_.capt])
disp(' ')
for i = 1:sds_.nch
    str=sprintf('Channel %d :  %s',i,sds_.ch{i});
    disp(str)
end