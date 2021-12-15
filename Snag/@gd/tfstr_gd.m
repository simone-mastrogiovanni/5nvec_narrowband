function tfstr=tfstr_gd(gin)
% extracts tfstr structure

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

a=gin.cont;

if isstruct(a)
    if isfield(a,'tfstr')
        tfstr=a.tfstr;
    else
        display('There is not tfstr structure')
    end
else
    display('There is not cont structure')
end
