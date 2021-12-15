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


load(inmatH,'Sfft'); 
if exist('Sfft','var')
    which_case='nored';
else
    which_case='red';
end

switch which_case
    case 'nored' 
        
        for i_IFO=1:1:length(cell_INMAT)
            load(cell_INMAT{i_IFO},'hvectors');
            load(cell_TEMP{i_IFO});
            
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
        
        Ap2TOT=Ap2_IFO{1};
        Ac2TOT=Ac2_IFO{1};
        hvectorsTOT=hvectors_IFO_tot{1};
        
        for i_IFO=2:1:length(cell_INMAT)
           Ap2TOT=Ap2TOT+Ap2_IFO{i_IFO};
           Ac2TOT=Ac2TOT+Ac2_IFO{i_IFO};
           hvectorsTOT.hplusfft=hvectorsTOT.hplusfft+hvectors_IFO_tot{i_IFO}.hplusfft;
           hvectorsTOT.hplusfftshifted=hvectorsTOT.hplusfftshifted+hvectors_IFO_tot{i_IFO}.hplusfftshifted;
           hvectorsTOT.hcrossfft=hvectorsTOT.hcrossfft+hvectors_IFO_tot{i_IFO}.hcrossfft;
           hvectorsTOT.hcrossfftshifted=hvectorsTOT.hcrossfftshifted+hvectors_IFO_tot{i_IFO}.hcrossfftshifted;
           
        end
        
        hvectorsTOT.hplusfft=hvectorsTOT.hplusfft/Ap2TOT;
        hvectorsTOT.hplusfftshifted=hvectorsTOT.hplusfftshifted/Ap2TOT;
        hvectorsTOT.hcrossfft=hvectorsTOT.hcrossfft/Ac2TOT;
        hvectorsTOT.hcrossfftshifted=hvectorsTOT.hcrossfftshifted/Ac2TOT;
        
        ARRIVATO QUI
        
        % Read the second file and obtain the ensable of scalar product (without
        % normalizzation)
        
        
        % Create the deca-vector product and normalize to the decavector sidereal
        % response
        
     
        Ap2TOT=Ap2H+Ap2L;
        Ac2TOT=Ac2H+Ac2L;
        
        hvectorsTOT.hplusfft=(hvectorsL.hplusfft+hvectorsH.hplusfft)/Ap2TOT;
        hvectorsTOT.hplusfftshifted=(hvectorsL.hplusfftshifted+hvectorsH.hplusfftshifted)/Ap2TOT;
        hvectorsTOT.hcrossfft=(hvectorsL.hcrossfft+hvectorsH.hcrossfft)/Ac2TOT;
        hvectorsTOT.hcrossfftshifted=(hvectorsL.hcrossfftshifted+hvectorsH.hcrossfftshifted)/Ac2TOT;
        
        Sfft=(Ap2TOT^2)*abs(hvectorsTOT.hplusfft).^2+(Ac2TOT^2)*abs(hvectorsTOT.hcrossfft).^2;
        Sfftshifted=(Ap2TOT^2)*abs(hvectorsTOT.hplusfftshifted).^2+(Ac2TOT^2)*abs(hvectorsTOT.hcrossfftshifted).^2;
        
        hvectors=hvectorsTOT;
        pentaAplusfft=[Ap_H;Ap_L];
        pentaAcrossfft=[Ac_H;Ac_L];
        save([path_name,'deca_vector_results.mat'],'Sfft','Sfftshifted','fra','hvectors','info','count_sd');
        [ppath,namesf,ext1]=fileparts([path_name,'deca_vector_results.mat']);
        tname=fullfile(ppath,[namesf,'_deca_vector_templates.mat']);
        save(tname,'pentaAplusfft','pentaAcrossfft');
    case 'red'
        load(inmatH);
        load(tempH);
        Ap_H=pentaAplusfft;
        Ac_H=pentaAcrossfft;
        Ap2=(norm(pentaAplusfft))^2;
        Ac2=(norm(pentaAcrossfft))^2;
        Ap2H=Ap2;
        Ac2H=Ac2;
        hvectorsH=r_hvectors;
        hvectorsH.hplusfft=r_hvectorsH.hplusfft*Ap2H;
        hvectorsH.hcrossfft=r_hvectorsH.hcrossfft*Ac2H;
               
        clearvars -except hvectorsH Ap2H Ac2H inmatL tempL strings info inout Ap_H Ac_H path_name count_sd
        
        % Read the second file and obtain the ensable of scalar product (without
        % normalizzation)
        
        
        load(inmatL);
        load(tempL);
        Ap_L=pentaAplusfft;
        Ac_L=pentaAcrossfft;
        Ap2=(norm(pentaAplusfft))^2;
        Ac2=(norm(pentaAcrossfft))^2;
        Ap2L=Ap2;
        Ac2L=Ac2;
        hvectorsL=r_hvectors;
        hvectorsL.hplusfft=r_hvectorsL.hplusfft*Ap2L;
        hvectorsL.hcrossfft=r_hvectorsL.hcrossfft*Ac2L;
               
        clearvars -except hvectorsH Ap2H Ac2H hvectorsL Ap2L Ac2L fra strings info inout Ap_H Ac_H Ap_L Ac_L path_name
        
        % Create the deca-vector product and normalize to the decavector sidereal
        % response
        
        
        Ap2TOT=Ap2H+Ap2L;
        Ac2TOT=Ac2H+Ac2L;
        
        hvectorsTOT.hplusfft=(hvectorsL.hplusfft+hvectorsH.hplusfft)/Ap2TOT;
        hvectorsTOT.hcrossfft=(hvectorsL.hcrossfft+hvectorsH.hcrossfft)/Ac2TOT;
               
        r_Sfft=(Ap2TOT^2)*abs(hvectorsTOT.hplusfft).^2+(Ac2TOT^2)*abs(hvectorsTOT.hcrossfft).^2;
                
        r_hvectors=hvectorsTOT;
        pentaAplusfft=[Ap_H;Ap_L];
        pentaAcrossfft=[Ac_H;Ac_L];
        save([path_name,'reduced_deca_vector_results.mat'],'r_Sfft','r_fra','r_hvectors','info','count_sd');
        [ppath,namesf,ext1]=fileparts([path_name,'deca_vector_results.mat']);
        [ppath,namesf,ext1]=fileparts([path_name,'deca_vector_results.mat']);
        tname=fullfile(ppath,[namesf,'_deca_vector_templates.mat']);
        save(tname,'pentaAplusfft','pentaAcrossfft');
end
