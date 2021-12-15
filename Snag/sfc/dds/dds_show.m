function dds_=dds_show(dds_)
%dds_SHOW  shows the dds structure

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if exist('dds_')
    dds_
else
    file=selfile(' ');
    dds_=dds_open(file)
end

strt=mjd2s(dds_.t0);
disp(['start at ' strt])
disp(' ')
disp(['Label :  ' char(dds_.label')])
disp(' ')
disp(['Caption :  '  dds_.capt])
disp(' ')
for i = 1:dds_.nch
    str=sprintf('Channel %d :  %s',i,dds_.ch{i});
    disp(str)
end