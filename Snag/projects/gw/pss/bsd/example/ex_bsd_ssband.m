% ex_bsd_ssband  
%
% extracts a tiny band around the pulsar_3 
%
% after ex_bsd_sband and ex_bsd_dedop 

tic

cont=cont_gd(bsd_outL);

pp=new_posfr(pulsar_3,cont.t0);  %  not updated sources !
fr=pp.f0;
fr1=fr-cont.inifr;%fr1=fr
band=[fr1-0.00005 fr1+0.00005];
st=1000;

[bsd_corrL1,extr_pars]=bsd_subband(bsd_corrL,[],band,st);
[bsd_corrH1,extr_pars]=bsd_subband(bsd_corrH,[],band,st);

toc