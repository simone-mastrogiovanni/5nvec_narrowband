function fu_struct=crea_fu_struct(coin_struct)
% follow-up basic structure
%
%     fu_struct=crea_fu_struct(coin_struct)
%
%   coin_struct   any coincidence structure

% Snag Version 2.0 - December 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

fu_struct.info1=coin_struct.info1;
fu_struct.info2=coin_struct.info2;

fu_struct.T1=coin_struct.T1;
fu_struct.T2=coin_struct.T2;
fu_struct.T0=coin_struct.T0;

fu_struct.info1.epoch=fu_struct.T1;
fu_struct.info2.epoch=fu_struct.T2;