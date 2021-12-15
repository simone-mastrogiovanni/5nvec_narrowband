function [out,cl_sosa1,cl_sosa2]=fu_full_merge(sosa1,sosa2,fu_struct)
% full follow-up analysis
%   
%      out=fu_full_merge(sosa1,sosa2,instr) 
%
%   sosa1,sosa2     sosas
%   fu_struct       as created by crea_fu_struct

% Snag Version 2.0 - December 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isfield(fu_struct,'enh')
    enh=fu_struct.enh;
else
    enh=10;
end

if isfield(fu_struct,'thresh1')
    thresh=fu_struct.thresh1;
else
    thresh=0.04;
end
cl_sosa1=clean_sosa(sosa1,thresh);

if isfield(fu_struct,'thresh2')
    thresh=fu_struct.thresh2;
else
    thresh=0.04;
end
cl_sosa2=clean_sosa(sosa2,thresh);

out=fu_hfdf_merge(cl_sosa1,cl_sosa2,fu_struct,enh);