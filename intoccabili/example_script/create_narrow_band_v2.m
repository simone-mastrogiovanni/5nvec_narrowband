function create_narrow_band_v2(IFOS,list_par_files,narrow_path,delta,t_ini_run,t_end_run,out,segments_file_strings)
% This function creates the set up for the narrow-band search and write the
% scripts to perform the analysis
% INPUT:
% IFOS: String of IFOS 'H','L','V'. E.g. 'HLV'
% list_par_files = txt file containing the ephemeris files (String form)
% narrow_path = local path where to create the analysis.
% delta = the delta facotr of the narrow-band. See (PhysRevD.96.122006)
% t_ini_run = start time of the run MJD
% t_end_run = end time of the MJD
% out: Structure which contains variables needed for this function (if you
% want to generate the scripts on another machine)
% segments_file_strings: a cell array containing the strings of the SCIENCE segments list for each IFO

fileID=fopen(list_par_files); %Open the file containing the list of *.par
par_path=textscan(fileID,'%s');

if exist('out','var')
    t_ini_run=out.tini;
    t_end_run=out.tend;
    create_analysis(IFOS,out,narrow_path,t_ini_run,t_end_run,segments_file_strings) % Create the narrow-band scripts
else
    out=create_dir(IFOS,par_path,narrow_path,delta,t_ini_run,t_end_run); % Create the narrow-band directory
    out.tini=t_ini_run;
    out.tend=t_end_run;
    save('out.mat','out');
end
end


function out=create_dir(IFOS, par_path,narrow_path,delta,t_ini_run,t_end_run)
% This function creates the directories for the narrow-band search in which
% it creates the source matlab files. The function also set up the *.sbl
% creation for each directory.
% INPUT:
% IFOS: String of IFOS 'H','L','V'. E.g. 'HLV'
% par_path = txt file containing the ephemeris files (String form)
% narrow_path = local path where to create the analysis.
% delta = the delta facotr of the narrow-band. See (PhysRevD.96.122006)
% t_ini_run = start time of the run MJD
% t_end_run = end time of the MJD

number_targets=length(par_path{1}); % Identify number of candidates
disp(sprintf('Identified %d pulsars',number_targets)); % Control print

for i=1:1:number_targets % Loop on the number of candidates
    char(par_path{1}(i)) % Control print
    fileIDpulsar=fopen(char(par_path{1}(i))); % Open a given ephemeris
    par_cell=textscan(fileIDpulsar,'%s %s %s'); % Scan the ephemeris
    for j=1:1:length(par_cell{1})
        field=char(par_cell{1}(j));
        switch field %Switch case on the ephemeris field and create a matlab structure
            case 'PSRJ' % Name
                sour.name=char(par_cell{2}(j));
                [a,b]=strtok(sour.name,'+'); %substitute + and - with p and m
                if isempty(b)
                    [a,b]=strtok(sour.name,'-');
                    sour.name=[a,'m',b(2:end)];
                else
                    sour.name=[a,'p',b(2:end)];
                    
                end
            case 'RAJ' %RA converted in deg
                sour.a=hour2deg(char(par_cell{2}(j)));
            case 'DECJ'%dec converted in deg
                hour=char(par_cell{2}(j));
                [sn rs]=strtok(hour,':');
                hour=zeros(1,3);
                hour(1)=str2num(sn);
                [sn rs]=strtok(rs,':');
                hour(2)=str2num(sn);
                [sn rs]=strtok(rs,':');
                hour(3)=str2num(sn);
                if hour(1)>0
                    sour.d=hour(1)+hour(2)/60+hour(3)/3600;
                else
                    sour.d=hour(1)-hour(2)/60-hour(3)/3600;
                end
                %The frequency and its derivatives
            case 'F0'
                sour.f0=2*str2num(char(par_cell{2}(j)));
            case 'F1'
                sour.df0=2*str2num(char(par_cell{2}(j)));
            case 'F2'
                sour.ddf0=2*str2num(char(par_cell{2}(j)));
            case 'F3'
                sour.d3f0=2*str2num(char(par_cell{2}(j)));
            case 'F4'
                sour.d4f0=2*str2num(char(par_cell{2}(j)));
            case 'F5'
                sour.d5f0=2*str2num(char(par_cell{2}(j)));
            case 'F6'
                sour.d6f0=2*str2num(char(par_cell{2}(j)));
            case 'F7'
                sour.d7f0=2*str2num(char(par_cell{2}(j)));
            case 'F8'
                sour.d8f0=2*str2num(char(par_cell{2}(j)));
            case 'F9'
                sour.d9f0=2*str2num(char(par_cell{2}(j)));
            case 'F10'
                sour.d10f0=2*str2num(char(par_cell{2}(j)));
            case 'F11'
                sour.d11f0=2*str2num(char(par_cell{2}(j)));
            case 'F12'
                sour.d12f0=2*str2num(char(par_cell{2}(j)));
            case 'PEPOCH'
                sour.fepoch=str2num(char(par_cell{2}(j)));
            case 'POSEPOCH'
                sour.pepoch=str2num(char(par_cell{2}(j)));
            case 'DIST'
                sour.distance=str2num(char(par_cell{2}(j)));
            case 'PMRA'
                sour.v_a=str2num(char(par_cell{2}(j)));
            case 'PMDEC'
                sour.v_d=str2num(char(par_cell{2}(j)));
        end
        
        
    end
    
    %Initialize to 0 some of the dxf0 if not present
    if ~isfield(sour,'ddf0')
        sour.ddf0=0;
    end
    if ~isfield(sour,'d3f0')
        sour.d3f0=0;
    end
    if ~isfield(sour,'d4f0')
        sour.d4f0=0;
    end
    if ~isfield(sour,'d5f0')
        sour.d5f0=0;
    end
    if ~isfield(sour,'v_a')
        sour.v_a=0;
    end
    if ~isfield(sour,'v_d')
        sour.v_d=0;
    end
    if isfield(sour,'distance') % Compute the spin-down limit if distance present
        sour.h0=8.06e-19*sqrt(abs(sour.df0/sour.f0))/sour.distance;
    end
    dir_name=[narrow_path,sour.name];
    
    if ~exist(dir_name,'dir') % Create the directory of one target plus its sub-directories
        mkdir(fullfile(dir_name,'deca')) % Joint
        mkdir(fullfile(dir_name,'reduced')) % post-processed folder
        source=sour;
        for i_IFO=1:1:length(IFOS)
            switch IFOS(i_IFO)
                case 'H'
                    strIFO=IFOS(i_IFO);
                    ant=ligoh;
                case 'L'
                    strIFO=IFOS(i_IFO);
                    ant=ligol;
                case 'V'
                    strIFO=IFOS(i_IFO);
                    ant=virgo;
                otherwise
                    error(['IFO ',IFO(i_IFO),' not known'])
            end
            mkdir(fullfile(dir_name,strIFO,'sdindex')) % save IFO
            save(fullfile(dir_name,strIFO,[sour.name,strIFO,'O.mat']),'ant','source');
            
        end
    end
    fclose(fileIDpulsar);
    sournew=new_posfr(sour,t_ini_run); %Shift the source at the start of the run
    Delta_f=abs(2*sournew.f0*delta); %Compute the frequency width
    Delta_fdot=abs(2*sournew.df0*delta);%Compute the spin-down width
    ext_nb(i,1:2)=[sournew.f0-0.5*Delta_f,sournew.f0+0.5*Delta_f]; %Put the frequency NB extremes in a matrix
    ext_nb(i,3:4)=[sournew.df0-0.5*Delta_fdot,sournew.df0+0.5*Delta_fdot]; %Put the spin-down NB extremes in a matrix
    % Compute the minimum and maximum frequency values taking into account the doppler and spin-down modulations (worst case scenarios)
    ext_dopp(i,:)=[ext_nb(i,1)-max(abs(ext_nb(i,3:4)))*(t_end_run-t_ini_run)*86400-2e-4*(sournew.f0+max(abs(ext_nb(i,3:4)))*(t_end_run-t_ini_run)*86400),ext_nb(i,2)+max(abs(ext_nb(i,3:4)))*(t_end_run-t_ini_run)*86400+2e-4*(sournew.f0+max(abs(ext_nb(i,3:4)))*(t_end_run-t_ini_run)*86400)];
    if  i==1
        fp=fopen(fullfile(narrow_path,'frequncies_sbl_prod.txt'),'w');
        freq_int=floor(sournew.f0);
        
        %Series of controls to check if the extracted frequencies exceed
        %the [0,1] Hz intervals
        if ext_dopp(i,1)-freq_int<0
            ext_dopp(i,1)=freq_int+1e-5;
        end
        if ext_dopp(i,2)-freq_int>1
            ext_dopp(i,2)=freq_int+1-1e-5;
        end
        
        if ext_nb(i,1)-freq_int<0
            ext_nb(i,1)=freq_int+1e-5;
        end
        if ext_nb(i,2)-freq_int>1
            ext_nb(i,2)=freq_int+1-1e-5;
        end
        
        fprintf(fp,'%.4f\t%.4f\t%s\n',ext_dopp(i,1),ext_dopp(i,2),sour.name);
        fclose(fp);
    else
        fp=fopen(fullfile(narrow_path,'frequncies_sbl_prod.txt'),'a');
        freq_int=floor(sournew.f0)
        if ext_dopp(i,1)-freq_int<0
            ext_dopp(i,1)=freq_int+1e-5
        end
        if ext_dopp(i,2)-freq_int>1
            ext_dopp(i,2)=freq_int+1-1e-5
        end
        
        
        if ext_nb(i,1)-freq_int<0
            ext_nb(i,1)=freq_int+1e-5;
        end
        if ext_nb(i,2)-freq_int>1
            ext_nb(i,2)=freq_int+1-1e-5;
        end
        
        fprintf(fp,'%.4f\t%.4f\t%s\n',ext_dopp(i,1),ext_dopp(i,2),sour.name);
        fclose(fp);
    end
    pulsars_name{i}=sour.name;
    out.sources_ephe{i}=sournew;
    clearvars sour source
end
out.pulsars_name=pulsars_name;
out.ext_nb=ext_nb;
out.ext_dopp=ext_dopp;
out.IFOS=IFOS;
% Write the script that extract the sbl
fp_sbl=fopen(fullfile(narrow_path,'script_sbl_prod.m'),'wt');
fprintf(fp_sbl,'fileID=fopen(''frequncies_sbl_prod.txt'');\n');
fprintf(fp_sbl,'aa=textscan(fileID,''%%f %%f %%s'');\n');

for i_IFO=1:1:length(IFOS)
    switch IFOS(i_IFO)
        case 'H'
            strIFO=IFOS(i_IFO);
            
        case 'L'
            strIFO=IFOS(i_IFO);
 
        case 'V'
            strIFO=IFOS(i_IFO);           
    end
    fprintf(fp_sbl,['listpath= %% Insert here ',strIFO,'O sfdb path file\n']);
    fprintf(fp_sbl,'for i=1:1:length(aa{1})\n');
    fprintf(fp_sbl,'ext1=[aa{1}(i),aa{2}(i)];\n');
    fprintf(fp_sbl,'soustr=aa{3}{i};\n');
    fprintf(fp_sbl,['str',strIFO,'=[''',strIFO,'_'',aa{3}{i},''_'',num2str(ext1(1)),''to'',num2str(ext1(2)),''_sblfile.sbl''];\n']);
    fprintf(fp_sbl,['fileout=fullfile(''%s'',soustr,''',strIFO,''',str',strIFO,');\n'],narrow_path);
    fprintf(fp_sbl,'sfdb09_band2sbl3_sergio([ext1(1) ext1(2)],2,'''',listpath,fileout);\n');
    fprintf(fp_sbl,'end\n');
    
end

%h = matlab.desktop.editor.openDocument(fullfile(narrow_path,'script_sbl_prod.m'));
%h.smartIndentContents
%h.save
%h.close
fclose(fp_sbl);
end

function create_analysis(IFOS,in_dir_creation,narrow_path,t_ini_run,t_end_run,segments_file_strings)
% This function creates the scripts needed to perform the NB analysis. The
% scripts are created in each target directory.
% INPUT:
% in_dir_creation = Output from the create_dir function
% narrow_path = local path where to create the analysis.
% t_ini_run = start time of the run MJD
% t_end_run = end time of the MJD
ext_nb=in_dir_creation.ext_nb;
ext_dopp=in_dir_creation.ext_dopp;

in_dir_creation.sources_ephe;
pulsars_name=in_dir_creation.pulsars_name;
% Loop on the selected targets
for i=1:1:length(pulsars_name)
    
    %Further checks on the frequency intervals of every target
    freq_int=floor(in_dir_creation.ext_dopp(i,1));
    if ext_nb(i,1)-freq_int<0
        ext_nb(i,1)=freq_int+1e-5;
    end
    if ext_nb(i,2)-freq_int>1
        ext_nb(i,2)=freq_int+1-1e-5;
    end
    
    sour.name=char(pulsars_name{i});
    dir_name=[narrow_path,sour.name];
    dir_name=['.'];
    
    
    % Write the script that will be used for the resampling part
    fp_recos=fopen(fullfile(narrow_path,sour.name,['recos_script_',sour.name,'.m']),'wt');
    fprintf(fp_recos,'ext1=[%.4f,%.4f];\n',ext_dopp(i,1),ext_dopp(i,2));
    fprintf(fp_recos,'ext1=num2str(ext1);\n');
    
    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
        strIFO_long=['',strIFO,'_',sour.name,'_',num2str(ext_dopp(i,1)),'to',num2str(ext_dopp(i,2)),'_sblfile.sbl'];
        string_out_file=fullfile(narrow_path,sour.name,strIFO,strIFO_long);
        fprintf(fp_recos,'sourstr=''%s'';\n',sour.name);
        fprintf(fp_recos,'files=''%s'';\n',string_out_file);
        fprintf(fp_recos,'ant_sour=''%s'';\n',fullfile(dir_name,strIFO,[sour.name,'',strIFO,'O.mat']));
        fprintf(fp_recos,'wide_pss_band_recos_strob8ph_part1(''%s'',''%s'',ant_sour,ext1,sourstr,files,num2str(1.0));\n',[fullfile(dir_name,strIFO),filesep],sour.name);
    end
    
    %h = matlab.desktop.editor.openDocument(fullfile(narrow_path,sour.name,['recos_script_',sour.name,'.m']));
    %h.smartIndentContents
    %h.save
    %h.close
    
    fclose(fp_recos);
    
    % Write the script that will be used for the analysis part
    fp_reduce=fopen(fullfile(narrow_path,sour.name,['reduce_script_',sour.name,'.m']),'wt');
    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
        fprintf(fp_reduce,'selpath=''%s'';\n',[fullfile(dir_name,strIFO,'sdindex'),filesep]);
        fprintf(fp_reduce,'timepath=''%s'';\n',[fullfile(dir_name,strIFO),filesep,sour.name,sour.name,'_','timevar.mat']);
        fprintf(fp_reduce,'inmat=''%s'';\n',[fullfile(dir_name,strIFO),filesep,sour.name,sour.name,'data_part1.mat']);
        fprintf(fp_reduce,'inseg=''%s'';%%Insert here the file of files segments \n',segments_file_strings{i_IFO});
        fprintf(fp_reduce,'second_time=num2str(%d,15); %% Isert a new reference time \n',round(t_ini_run));
        fprintf(fp_reduce,'cut_array=num2str([%d %d],15); %% Insert data to extract in MJD\n',floor(t_ini_run)+1,floor(t_end_run)-1);
        DF=ext_nb(i,2)-ext_nb(i,1);
        DDF_int=ceil(0.5*abs((ext_nb(i,4)-ext_nb(i,3))*((t_end_run-t_ini_run)*86400)^2));
        fprintf(fp_reduce,'reduce_pss_band_recos_strob8ph_part2_v2(second_time,selpath,timepath,''%s'',inmat,inseg,num2str(0),num2str(%s),num2str(-%s),num2str(%s),cut_array,num2str(0),num2str(0));\n',[sour.name,'_'],num2str(DF),num2str(DDF_int),num2str(DDF_int));
    end
    
    %h = matlab.desktop.editor.openDocument(fullfile(narrow_path,sour.name,['reduce_script_',sour.name,'.m']));
    %h.smartIndentContents
    %h.save
    %h.close
    
    
    fclose(fp_reduce);
    
    % Write the script that will be used for the analysis part
    fp_reduce=fopen(fullfile(narrow_path,sour.name,'reduce_followI.m'),'wt');
    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
        fprintf(fp_reduce,'selpath=''%s'';\n',[fullfile(dir_name,strIFO,'sdindex'),filesep]);
        fprintf(fp_reduce,'timepath=''%s'';\n',[fullfile(dir_name,strIFO),filesep,sour.name,sour.name,'_','timevar.mat']);
        fprintf(fp_reduce,'inmat=''%s'';\n',[fullfile(dir_name,strIFO),filesep,sour.name,sour.name,'data_part1.mat']);
        fprintf(fp_reduce,'inseg=''%s'';%%Insert here the file of files segments \n',segments_file_strings{i_IFO});
        fprintf(fp_reduce,'second_time=num2str(%d,15); %% Isert a new reference time \n',round(t_ini_run));
        fprintf(fp_reduce,'cut_array=num2str([%d %d],15); %% Insert data to extract in MJD\n',floor(t_ini_run)+1,floor(t_end_run)-1);
        DF=ext_nb(i,2)-ext_nb(i,1);
        DDF_int=ceil(0.5*abs((ext_nb(i,4)-ext_nb(i,3))*((t_end_run-t_ini_run)*86400)^2));
        fprintf(fp_reduce,'reduce_pss_band_recos_strob8ph_part2_v2(second_time,selpath,timepath,''%s'',inmat,inseg,num2str(0),num2str(%s),num2str(n_sd),num2str(n_sd),cut_array,num2str(0),num2str(0));\n',[sour.name,'_'],num2str(DF));
    end
    
    %h = matlab.desktop.editor.openDocument(fullfile(narrow_path,sour.name,['reduce_script_',sour.name,'.m']));
    %h.smartIndentContents
    %h.save
    %h.close
    
    
    fclose(fp_reduce);
    
    %----------------------------- NEW BLOCK FOR THE UL PART, TO TEST
    fp_reduce=fopen(fullfile(narrow_path,sour.name,'reduce_UL.m'),'wt');
    fprintf(fp_reduce,'cd reduced \n');
    fprintf(fp_reduce,'dir_reduced=dir(''*_0_deca_vector_results*''); \n');
    fprintf(fp_reduce,'load(dir_reduced.name,''info'',''r_fra''); \n');
    fprintf(fp_reduce,'cd .. \n');
    fprintf(fp_reduce,'cd deca \n');
    fprintf(fp_reduce,'dir_deca=dir(''*_0_deca_vector_results.mat''); \n');
    fprintf(fp_reduce,'load(dir_deca.name,''fra''); \n');
    fprintf(fp_reduce,'cd .. \n');
    fprintf(fp_reduce,'sdbins=%d;\n',floor(DDF_int));
    
    fprintf(fp_reduce,'for indx_inj=1:1:100 \n');
    fprintf(fp_reduce,'waves.binfsid=info.binfsid;\n');
    fprintf(fp_reduce,'waves.step=floor(1e-4/info.binfsid)*info.binfsid;\n');
    fprintf(fp_reduce,'waves.Npk=length(r_fra);\n');
    fprintf(fp_reduce,'waves.fstart=fra(1)+rand*waves.step;\n');
    fprintf(fp_reduce,'waves.sdindex=round(rand*2*sdbins-sdbins);\n');
    fprintf(fp_reduce,'waves.sd=info.df0new+waves.sdindex*waves.binfsid^2;\n');
    fprintf(fp_reduce,'waves.sdd=0;\n');
    fprintf(fp_reduce,'waves.eta=rand*2-1;\n');
    fprintf(fp_reduce,'waves.psi=(rand*90-45)*pi/180;\n');
    fprintf(fp_reduce,'injected_waves{indx_inj}=waves; \n');
    fprintf(fp_reduce,'end \n');
    fprintf(fp_reduce,'save(''injections.mat'',''injected_waves'');\n');
    
    fprintf(fp_reduce,'for indx_inj=1:1:100 \n');

    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
        fprintf(fp_reduce,'waves=injected_waves{indx_inj}; \n');
        fprintf(fp_reduce,'selpath=''%s'';\n',[fullfile(dir_name,strIFO,'sdindex'),filesep]);
        fprintf(fp_reduce,'timepath=''%s'';\n',[fullfile(dir_name,strIFO),filesep,sour.name,sour.name,'_','timevar.mat']);
        fprintf(fp_reduce,'inmat=''%s'';\n',[fullfile(dir_name,strIFO),filesep,sour.name,sour.name,'data_part1.mat']);
        fprintf(fp_reduce,'inseg=''%s'';%%Insert here the file of files segments \n',segments_file_strings{i_IFO});
        fprintf(fp_reduce,'second_time=num2str(%d,15); %% Isert a new reference time \n',round(t_ini_run));
        fprintf(fp_reduce,'cut_array=num2str([%d %d],15); %% Insert data to extract in MJD\n',floor(t_ini_run)+1,floor(t_end_run)-1);
        DF=ext_nb(i,2)-ext_nb(i,1);
        fprintf(fp_reduce,'reduce_for_upper(second_time,selpath,timepath,[''inj_'',num2str(indx_inj),''_''],inmat,inseg,num2str(0),num2str(%s),num2str(0),num2str(0),cut_array,waves,num2str(0));\n',num2str(DF));
        
    end
    
    
    
    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
        
        DF=ext_nb(i,2)-ext_nb(i,1);
        exdown=in_dir_creation.sources_ephe{i}.f0-0.5*DF;
        exup=in_dir_creation.sources_ephe{i}.f0+0.5*DF;
        
        if exdown-freq_int<0
            exdown=freq_int+1e-5;
        end
        if exup-freq_int>1
            exup=freq_int+1-1e-5;
        end
        
        fprintf(fp_reduce,['temp',strIFO,'=''%s'';\n'],[fullfile(dir_name,strIFO,'sdindex'),filesep,num2str(exdown,'%.4f'),'_',num2str(exup,'%.4f'),'_',sour.name,'_','days_',num2str(floor(t_ini_run)+1,'%d'),'-',num2str(floor(t_end_run)-1,'%d'),'forupper_templates.mat']);
        fprintf(fp_reduce,['pre',strIFO,'=''%s'';\n'],[fullfile(dir_name,strIFO,'sdindex'),filesep,'inj_']);
        fprintf(fp_reduce,['post',strIFO,'=''%s'';\n'],['_',sour.name,'_','days','_',num2str(floor(t_ini_run)+1,'%d'),'-',num2str(floor(t_end_run)-1,'%d'),'data_part2_sd_index=0.mat']);
        fprintf(fp_reduce,['cell_TEMP{%d}=','temp',strIFO,';\n'],i_IFO);
    end
    string_to_load=['deca',filesep,sour.name,'_0_deca_vector_results.mat'];
    fprintf(fp_reduce,'load(''%s'',''rel_weights'');\n',string_to_load);

    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
        fprintf(fp_reduce,['inmat',strIFO,'=[pre',strIFO,',num2str(indx_inj),post',strIFO,'];\n']);
        fprintf(fp_reduce,['cell_INMAT{%d}=','inmat',strIFO,';\n'],i_IFO);
    end
    fprintf(fp_reduce,'path_name=[''%s'',num2str(indx_inj),''_''];\n',[dir_name,filesep,'deca',filesep,sour.name,'_inj_']);
    fprintf(fp_reduce,'deca_vector_weight_UL(cell_INMAT,cell_TEMP,path_name,rel_weights);\n');
    
    fprintf(fp_reduce,'prein=''%s'';\n',[dir_name,filesep,'deca',filesep,sour.name,'_inj_']);
    fprintf(fp_reduce,'postin=''_deca_vector_results.mat'';\n');
    fprintf(fp_reduce,'name=[prein,num2str(indx_inj),postin];\n');
    fprintf(fp_reduce,'fprintf(''Reading the file: %%s \\n'',name);\n');
    fprintf(fp_reduce,'reduce_post(name,1e-4,''%s'');\n',[dir_name,filesep,'reduced',filesep]);
    
    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
        fprintf(fp_reduce,'delete(''%s'');\n',[dir_name,filesep,strIFO,filesep,'sdindex',filesep,'inj_*']);
    end
    
    fprintf(fp_reduce,'delete(''deca/*_inj_*_deca_vector_results.mat'');\n');

    fprintf(fp_reduce,'end\n');
    
    fprintf(fp_reduce,'load(''candidates_FAP_1mille.mat'');\n');
    fprintf(fp_reduce,'Sthr=candidates{2}.Sthr;\n');
    fprintf(fp_reduce,'filename=''composed_file.mat'';\n');
    
    fprintf(fp_reduce,'fileA=''%s''; \n',[dir_name,filesep,'deca',filesep,sour.name,'_0_deca_vector_results_deca_vector_templates.mat']);
    fprintf(fp_reduce,'prefilesd=''%s'';\n',[dir_name,filesep,'deca',filesep,sour.name,'_']);
    fprintf(fp_reduce,'postfilesd=''_deca_vector_results.mat'';\n');
    fprintf(fp_reduce,'prefile=''%s'';\n',[dir_name,filesep,'reduced',filesep,'reduced_',sour.name,'_inj_']);
    fprintf(fp_reduce,'postfile=''_deca_vector_results.mat'';\n');
    fprintf(fp_reduce,'dt=1;\n');
    fprintf(fp_reduce,'perc=0.95;\n');
    fprintf(fp_reduce,'[upper_study,real_fra]=upper_limit_final_form(''injections.mat'',filename,100,1e-7,1e-8,fileA,prefile,postfile,prefilesd,postfilesd,dt,perc,Sthr);\n');
    fprintf(fp_reduce,'save(''upper_limists_FAP1e-3.mat'',''real_fra'',''upper_study'');\n');

    fclose(fp_reduce);

   %----------------------------------------------------------
    %Write the script that will be used for the creation of the joint
    %analysis
    fp_deca=fopen(fullfile(narrow_path,sour.name,['deca_script_',sour.name,'.m']),'wt');
        
    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
         
        DF=ext_nb(i,2)-ext_nb(i,1);
        exdown=in_dir_creation.sources_ephe{i}.f0-0.5*DF;
        exup=in_dir_creation.sources_ephe{i}.f0+0.5*DF;
        
        if exdown-freq_int<0
            exdown=freq_int+1e-5;
        end
        if exup-freq_int>1
            exup=freq_int+1-1e-5;
        end

        fprintf(fp_deca,['temp',strIFO,'=''%s'';\n'],[fullfile(dir_name,strIFO,'sdindex'),filesep,num2str(exdown,'%.4f'),'_',num2str(exup,'%.4f'),'_',sour.name,'_','days_',num2str(floor(t_ini_run)+1,'%d'),'-',num2str(floor(t_end_run)-1,'%d'),'_templates.mat']);
        fprintf(fp_deca,['pre',strIFO,'=''%s'';\n'],[fullfile(dir_name,strIFO,'sdindex'),filesep,sour.name,'_',sour.name,'_','days','_',num2str(floor(t_ini_run)+1,'%d'),'-',num2str(floor(t_end_run)-1,'%d'),'data_part2_sd_index=']);
        fprintf(fp_deca,['post',strIFO,'=''.mat'';\n']);
        fprintf(fp_deca,['cell_TEMP{%d}=','temp',strIFO,';\n'],i_IFO);
    end
    
    fprintf(fp_deca,'for i=-%d:1:%d \n',DDF_int,DDF_int);
    for i_IFO=1:1:length(IFOS)
        strIFO=IFOS(i_IFO);
        fprintf(fp_deca,['inmat',strIFO,'=[pre',strIFO,',num2str(i),post',strIFO,'];\n']);
        fprintf(fp_deca,['cell_INMAT{%d}=','inmat',strIFO,';\n'],i_IFO);
    end
    fprintf(fp_deca,'path_name=[''%s_'',num2str(i),''_''];\n',[dir_name,filesep,'deca',filesep,sour.name]);
    fprintf(fp_deca,'deca_vector_weight(cell_INMAT,cell_TEMP,path_name);\n');
    fprintf(fp_deca,'end\n');
    
    %h = matlab.desktop.editor.openDocument(fullfile(narrow_path,sour.name,['deca_script_',sour.name,'.m']));
    %h.smartIndentContents
    %h.save
    %h.close
    
    fclose(fp_deca);
    
    % Write the scripts that will select the local maxima of the detection
    % statistic
    fp_pr=fopen(fullfile(narrow_path,sour.name,['post_reduce_script_',sour.name,'.m']),'wt');
    fprintf(fp_pr,'prein=''%s_'';\n',[dir_name,filesep,'deca',filesep,sour.name]);
    fprintf(fp_pr,'postin=''_deca_vector_results.mat'';\n');
    fprintf(fp_pr,'for i=-%d:1:%d \n',DDF_int,DDF_int);
    fprintf(fp_pr,'name=[prein,num2str(i),postin];\n');
    fprintf(fp_pr,'fprintf(''Reading the file: %%s \\n'',name);\n');
    fprintf(fp_pr,'reduce_post(name,1e-4,''%s'');\n',[dir_name,filesep,'reduced',filesep]);
    fprintf(fp_pr,'end\n');
    
   % h = matlab.desktop.editor.openDocument(fullfile(narrow_path,sour.name,['post_reduce_script_',sour.name,'.m']));
   % h.smartIndentContents
   % h.save
   % h.close
    fclose(fp_pr);
    
    
    % Create the script that will create the final collaction of the
    % narrow-band detection statistics
    fp_comp=fopen(fullfile(narrow_path,sour.name,['compose_script_',sour.name,'.m']),'wt');
    fprintf(fp_comp,'prefile=''%s'';\n',[dir_name,filesep,'reduced',filesep,'reduced_',sour.name,'_']);
    fprintf(fp_comp,'postfile=''_deca_vector_results.mat'';\n');
    fprintf(fp_comp,'minind=-%d;\n',DDF_int);
    fprintf(fp_comp,'for i=minind:1:%d\n',DDF_int);
    fprintf(fp_comp,'name=[prefile,num2str(i),postfile];\n');
    fprintf(fp_comp,'load(name);\n');
    fprintf(fp_comp,'if exist(''Sfft'',''var'')\n');
    fprintf(fp_comp,'Sfft_full(i-minind+1,:)=Sfft;\n');
    fprintf(fp_comp,'Sfftshifted_full(i-minind+1,:)=Sfftshifted;\n');
    fprintf(fp_comp,'fra_full(i-minind+1,:)=fra;\n');
    fprintf(fp_comp,'sd_full(i-minind+1,:)=ones(1,length(Sfft))*info.df0new;\n');
    fprintf(fp_comp,'count_sd_full(i-minind+1,:)=ones(1,length(Sfft))*count_sd;\n');
    fprintf(fp_comp,'hpfft(i-minind+1,:)=hvectors.hplusfft;\n');
    fprintf(fp_comp,'hcfft(i-minind+1,:)=hvectors.hcrossfft;\n');
    fprintf(fp_comp,'hpfftshifted(i-minind+1,:)=hvectors.hplusfftshifted;\n');
    fprintf(fp_comp,'hcfftshifted(i-minind+1,:)=hvectors.hcrossfftshifted;\n');
    fprintf(fp_comp,'else\n');
    fprintf(fp_comp,'Sfft_full(i-minind+1,:)=r_Sfft;\n');
    fprintf(fp_comp,'fra_full(i-minind+1,:)=r_fra;\n');
    fprintf(fp_comp,'sd_full(i-minind+1,:)=ones(1,length(r_Sfft))*info.df0new;\n');
    fprintf(fp_comp,'count_sd_full(i-minind+1,:)=ones(1,length(r_Sfft))*count_sd;\n');
    fprintf(fp_comp,'hpfft(i-minind+1,:)=r_hvectors.hplusfft;\n');
    fprintf(fp_comp,'hcfft(i-minind+1,:)=r_hvectors.hcrossfft;\n');
    
    fprintf(fp_comp,'end\n');
    fprintf(fp_comp,'end\n');
    fprintf(fp_comp,'dimen=size(Sfft_full);\n');
    fprintf(fp_comp,'if exist(''Sfft'',''var'')\n');
    fprintf(fp_comp,'Sfft_lin=reshape(Sfft_full,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'Sfftshifted_lin=reshape(Sfftshifted_full,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'sd_lin=reshape(sd_full,1,dimen(1)*dimen(2));\n');
    
    fprintf(fp_comp,'fra_lin=reshape(fra_full,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'hpfft_lin=reshape(hpfft,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'hpfftshifted_lin=reshape(hpfftshifted,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'count_sd_lin=reshape(count_sd_full,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'hcfftshifted_lin=reshape(hcfftshifted,1,dimen(1)*dimen(2));\n');
    
    fprintf(fp_comp,'hcfftshifted_lin=reshape(hcfftshifted,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'else\n');
    fprintf(fp_comp,'Sfft_lin=reshape(Sfft_full,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'sd_lin=reshape(sd_full,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'fra_lin=reshape(fra_full,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'hpfft_lin=reshape(hpfft,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'hcfft_lin=reshape(hcfft,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'count_sd_lin=reshape(count_sd_full,1,dimen(1)*dimen(2));\n');
    fprintf(fp_comp,'end\n');
    fprintf(fp_comp,'if exist(''Sfft'',''var'')\n');
    fprintf(fp_comp,'[ap,ii]=max(Sfft_full);\n');
    fprintf(fp_comp,'[ap,ij]=max(Sfftshifted_full);\n');
    
    fprintf(fp_comp,'if lenght(ii)~=1\n');
    fprintf(fp_comp,'for i=1:1:length(ii)\n');
    fprintf(fp_comp,'r_Sfft(i)=Sfft_full(ii(i),i);\n');
    fprintf(fp_comp,'r_Sfftshifted(i)=Sfftshifted_full(ij(i),i);\n');
    fprintf(fp_comp,'r_fra(i)=fra_full(ii(i),i);\n');
    fprintf(fp_comp,'r_sd(i)=sd_full(ii(i),i);\n');
    fprintf(fp_comp,'r_count_sd(i)=count_sd_full(ii(i),i);\n');
    fprintf(fp_comp,'r_hvectors.hplusfft(i)=hpfft(ii(i),i);\n');
    fprintf(fp_comp,'r_hvectors.hcrossfft(i)=hcfft(ii(i),i);\n');
    fprintf(fp_comp,'r_hvectors.hplusfftshifted(i)=hpfftshifted(ij(i),i);\n');
    
    fprintf(fp_comp,'r_hvectors.hcrossfftshifted(i)=hcfftshifted(ij(i),i);\n');
    
    fprintf(fp_comp,'end\n');
    fprintf(fp_comp,'else\n');
    fprintf(fp_comp,'r_Sfft=Sfft_full;\n');
    fprintf(fp_comp,'r_Sfftshifted=Sfftshifted_full;\n');
    fprintf(fp_comp,'r_fra=fra_full;\n');
    fprintf(fp_comp,'r_sd=sd_full;\n');
    fprintf(fp_comp,'r_count_sd=count_sd_full;\n');
    fprintf(fp_comp,'r_hvectors.hplusfft=hpfft;\n');
    fprintf(fp_comp,'r_hvectors.hcrossfft=hcfft;\n');
    fprintf(fp_comp,'r_hvectors.hplusfftshifted=hpfftshifted;\n');
    fprintf(fp_comp,'r_hvectors.hcrossfftshifted=hcfftshifted;\n');
    fprintf(fp_comp,'end\n');
    fprintf(fp_comp,'else\n');
    fprintf(fp_comp,'[ap,ii]=max(Sfft_full);\n');
    fprintf(fp_comp,'if length(ii)~=1\n');
    fprintf(fp_comp,'for i=1:1:length(ii)\n');
    fprintf(fp_comp,'r_Sfft(i)=Sfft_full(ii(i),i);\n');
    fprintf(fp_comp,'r_fra(i)=fra_full(ii(i),i);\n');
    fprintf(fp_comp,'r_sd(i)=sd_full(ii(i),i);\n');
    fprintf(fp_comp,'r_count_sd(i)=count_sd_full(ii(i),i);\n');
    fprintf(fp_comp,'r_hvectors.hplusfft(i)=hpfft(ii(i),i);\n');
    fprintf(fp_comp,'r_hvectors.hcrossfft(i)=hcfft(ii(i),i);\n');
    fprintf(fp_comp,'end\n');
    fprintf(fp_comp,'else\n');
    fprintf(fp_comp,'r_Sfft=Sfft_full;\n');
    
    fprintf(fp_comp,'r_fra=fra_full;\n');
    fprintf(fp_comp,'r_sd=sd_full;\n');
    fprintf(fp_comp,'r_count_sd=count_sd_full;\n');
    fprintf(fp_comp,'r_hvectors.hplusfft=hpfft;\n');
    fprintf(fp_comp,'r_hvectors.hcrossfft=hcfft;\n');
    fprintf(fp_comp,'end\n');
    fprintf(fp_comp,'end\n');
    fprintf(fp_comp,'save(''composed_file.mat'');\n');
    
    
    %h = matlab.desktop.editor.openDocument(fullfile(narrow_path,sour.name,['compose_script_',sour.name,'.m']));
    %h.smartIndentContents
    %h.save
    %h.close
    
    fclose(fp_comp);
    
end


end
