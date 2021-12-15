function gg_mixed=decoherence(gg_sc,cycle)

% This program mixed the data to eliminate the presence of the signals

% Input arguments:
%
% inmat:Input gd from the selection file in the reduce pss2
% cycle: How many times we want to mix


% Output arguments:
% decoherence_file: Contain the mixed time series

% Note:We have noticed that the mixing procedure, whitened the noise all
% over the frequency range aviable

% Made by Simone Mastrogiovanni 2017


gar=y_gd(gg_sc);
for icount=1:1:cycle

    jj=randperm(length(gar));
    rangar=gar(jj);
    gar=rangar;

end
gg_mixed=gg_sc;
gg_mixed=edit_gd(gg_mixed,'y',gar);
end
