function [k,k1,k2]=pss_sensfact(fr,tobs)
%PSS_SENSFACT  sensitivity factor to have sensitivity from H
%              (the radiation pattern loss 2 is taken into account) 
%
%   fr     frequencies
%   tobs   observation time (in days)

rad_pat_loss_fact=2;
stobs=tobs*86400;
k1=(0.077*fr.^0.125)/stobs^0.25;
k20=(0.71*log(fr)+0.29);
k2=sqrt(0.65.*log(fr)+0.415*log(tobs/30)-0.63);
k=rad_pat_loss_fact*k1.*k2;