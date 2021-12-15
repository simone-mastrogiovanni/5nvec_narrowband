function deca_vector_weight(cell_INMAT,cell_TEMP,path_name)
%This function compute the detection statistic using two interferometers datasets
%The files must be computed with the same reference time and the frequency
%arrays must be coincident, written to work after reuced_pss2...

% NB FREQ GRID MUST BE COINCIDENT
% Input:
% cell_INMAT: cell array containing the path of the INMAT files
% cell_TEMP: cell array containing the path of the sidereal template files
% path_name:path or name with which you want to save the file put somenthing
% that recognize the file
%
% External Output:
% File containing the joint analysis @-->[path_name,'deca_vector_results.mat']



for i_IFO=1:1:length(cell_INMAT)
    load(cell_INMAT{i_IFO});
    load(cell_TEMP{i_IFO});
    gg_permed=decoherence(gg_sc_clean,1);
    spectrum_esti=gd_pows(gg_permed,'pieces',100);
    rel_weights(i_IFO)=1.0/mean(spectrum_esti);
    
    Ap_IFO{i_IFO}=pentaAplusfft;
    Ac_IFO{i_IFO}=pentaAcrossfft;
    Ap2_IFO{i_IFO}=(norm(Ap_IFO{i_IFO}))^2;
    Ac2_IFO{i_IFO}=(norm(Ac_IFO{i_IFO}))^2;
    hvectors_IFO=hvectors;
    hvectors_IFO.hplusfft=hvectors_IFO.hplusfft*Ap2_IFO{i_IFO};
    hvectors_IFO.hplusfftshifted=hvectors_IFO.hplusfftshifted*Ap2_IFO{i_IFO};
    hvectors_IFO.hcrossfft=hvectors_IFO.hcrossfft*Ac2_IFO{i_IFO};
    hvectors_IFO.hcrossfftshifted=hvectors_IFO.hcrossfftshifted*Ac2_IFO{i_IFO};
    hvectors_IFO_tot{i_IFO}=hvectors_IFO;
end

rel_weights=rel_weights/mean(rel_weights);


hvectorsTOT=hvectors_IFO_tot{1};

hvectorsTOT.hplusfft=hvectorsTOT.hplusfft*rel_weights(1);
hvectorsTOT.hplusfftshifted=hvectorsTOT.hplusfftshifted*rel_weights(1);
hvectorsTOT.hcrossfft=hvectorsTOT.hcrossfft*rel_weights(1);
hvectorsTOT.hcrossfftshifted=hvectorsTOT.hcrossfftshifted*rel_weights(1);

pentaAplusfft=Ap_IFO{1}*sqrt(rel_weights(1));
pentaAcrossfft=Ac_IFO{1}*sqrt(rel_weights(1));

for i_IFO=2:1:length(cell_INMAT)
    hvectorsTOT.hplusfft=hvectorsTOT.hplusfft+hvectors_IFO_tot{i_IFO}.hplusfft*rel_weights(i_IFO);
    hvectorsTOT.hplusfftshifted=hvectorsTOT.hplusfftshifted+hvectors_IFO_tot{i_IFO}.hplusfftshifted*rel_weights(i_IFO);
    hvectorsTOT.hcrossfft=hvectorsTOT.hcrossfft+hvectors_IFO_tot{i_IFO}.hcrossfft*rel_weights(i_IFO);
    hvectorsTOT.hcrossfftshifted=hvectorsTOT.hcrossfftshifted+hvectors_IFO_tot{i_IFO}.hcrossfftshifted*rel_weights(i_IFO);
    pentaAplusfft=[pentaAplusfft;Ap_IFO{i_IFO}*sqrt(rel_weights(i_IFO))];
    pentaAcrossfft=[pentaAcrossfft;Ac_IFO{i_IFO}*sqrt(rel_weights(i_IFO))];
end

Ap2TOT=(norm(pentaAplusfft))^2;
Ac2TOT=(norm(pentaAcrossfft))^2;

hvectorsTOT.hplusfft=hvectorsTOT.hplusfft/Ap2TOT;
hvectorsTOT.hplusfftshifted=hvectorsTOT.hplusfftshifted/Ap2TOT;
hvectorsTOT.hcrossfft=hvectorsTOT.hcrossfft/Ac2TOT;
hvectorsTOT.hcrossfftshifted=hvectorsTOT.hcrossfftshifted/Ac2TOT;

Sfft=(Ap2TOT^2)*abs(hvectorsTOT.hplusfft).^2+(Ac2TOT^2)*abs(hvectorsTOT.hcrossfft).^2;
Sfftshifted=(Ap2TOT^2)*abs(hvectorsTOT.hplusfftshifted).^2+(Ac2TOT^2)*abs(hvectorsTOT.hcrossfftshifted).^2;
hvectors=hvectorsTOT;

% Read the second file and obtain the ensable of scalar product (without
% normalizzation)


% Create the deca-vector product and normalize to the decavector sidereal
% response

save([path_name,'deca_vector_results.mat'],'Sfft','Sfftshifted','fra','hvectors','info','count_sd','rel_weights');
[ppath,namesf,ext1]=fileparts([path_name,'deca_vector_results.mat']);
tname=fullfile(ppath,[namesf,'_deca_vector_templates.mat']);
save(tname,'pentaAplusfft','pentaAcrossfft');
   
end
