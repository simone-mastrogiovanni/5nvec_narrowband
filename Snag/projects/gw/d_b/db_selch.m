function [chn,chs,dt,dlen,sp,vers,minvers,frame4par]=db_selch(ntype,file)
%DB_SELCH  channel selection for frames and R87 files
%
%        [chn,chs,dt,dlen,sp,vers,minvers,frame4par]=db_selch(ntype,file)
%
%        ntype   type of data format
%        file    file with path
%
%        chn     channel number (0 if not available)
%        chs     channel name (or data spectrum)
%        dt      sampling time
%        dlen    length of data chunk
%        sp      spectrum vector (for simulation)
%        vers    Data Frame Format Version
%        minvers Data Frame Format Minor Version 
%
% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
%    Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

chn=0;chs='not available';sp=0;
vers=0;
minvers=0;
frame4par=0;
snag_local_symbols;

switch ntype
case 1
   [chn,dt,dlen]=sds_selch(file);
case 2
    [chs,dt,dlen,vers,minvers,frame4par]=fmnl_selch(file); 
% case 3 (old: access by framelib)
%    [adc,chs]=frexsnag_ac(file);
%    
%    [a,t,f,t0,t0s,c,u,more] = frextrsnag1(file,chs,1,1);
%    dlen=length(a);
%    %dt=(t(11)-t(1))/10;
%    dt=more(6);
%    clear a t f t0 t0s c u more;
%    %pack;
case 3
   r_struct.file=file;
   r_struct.select={'0'};

   [fid,r_struct]=open_snf_read(r_struct)
   str=r_struct.mds.name;
   
   [iadc iok]=listdlg('PromptString','Select a channel:',...
   	'SelectionMode','single',...
   	'ListString',str);

	chs=str{iadc};
   dt=r_struct.mds.dt(iadc);
   dlen=r_struct.mds.len(iadc);
case 4
   [fid,reclen,initime,samptim]=open_r87(file);
   header=read_r87(fid,reclen);
   
   str1=sprintf('Field 1 : channels 101 - %d',100+header.nc1);
   str2=sprintf('Field 2 : channels 201 - %d',200+header.nc2);
   str3=sprintf('Field 3 : channels 301 - %d',300+header.nc3);
   if header.nc1 < 1
      str1=' ';
   end
   if header.nc2 < 1
      str2=' ';
   end
	if header.nc3 < 1
      str3=' ';
   end
   prom=sprintf(' %s \n %s \n %s',str1,str2,str3);
   schn=inputdlg(prom,'Channel choice');
   chn=eval(schn{1});
   [header,data]=read_r87_ch(fid,reclen,chn);
   dlen=length(data);
   dt=header.st;
   fclose(fid);
case 5
   str={'IFO_DMRO' 'IFO_Mike' 'SUS_EE_Coil_V' 'IFO_MCR'...
	   'IFO_SAT' 'IFO_EAT' 'IFO_Lock' 'IFO_Seis_1' 'PSL_MC_V' 'IFO_DCDM'};

	[iadc iok]=listdlg('PromptString','Select an ADC:',...
   	'SelectionMode','single',...
   	'ListString',str);

	chs=str{iadc};

	com=['load ' file];eval(com);
   rate=strcat('rate_',chs);
   dt=1/eval(rate);
   com=['length(' chs ')'];dlen=eval(com);
case 100
   chn=0;
   snag_local_symbols;
   %direc=specdir;
   
   %cddir=['cd ' direc];
   %eval(cddir);

   [fnam,pnam]=uigetfile([specdir '*.*'],'Spectrum File Selection');

   chs=strcat(pnam,fnam);

   loa=['load ' chs];
   eval(loa);
   
   eval(specname)
   eval(['g=' specname ';'])
   dlen=n_gd(g)/2;
   dt=1/(n_gd(g)*dx_gd(g));
   sp=y_gd(g);
end
