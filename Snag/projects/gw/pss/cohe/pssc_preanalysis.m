function [dat_5 sim0_5 sim45_5 dat_5_noeq A0_deq A45_deq]=pssc_preanalysis(gin,wien,ant)
% PSSC_PREANALYSIS pssc coherent search preanalysis
%
%    gin    input gd
%    wien   wiener mask; 1 auto-compute window, 0 no wiener 

% Version 2.0 - May 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ST=86164.09053083288;

if length(wien) == 1
    if wien == 1
        wien=check_nonzero(gin);
    else
        wien=ones(1,n_gd(gin));
    end
end

cont=cont_gd(gin);

[geq weq dat_5 dat_5_noeq w5 sim0_5 sim45_5 A0_deq A45_deq]=tsid_equaliz(gin,wien,ant);
fr0=cont.appf0;
