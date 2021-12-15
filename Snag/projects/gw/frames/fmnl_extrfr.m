function data=fmnl_extrfr(vartoc)

%Select a Structure

indstruct=[vartoc.nstattype vartoc.nadc vartoc.nproc vartoc.nsim...
      vartoc.nser vartoc.nsumm vartoc.ntrig vartoc.nsimevent];
structname={'FrStatData' 'FrAdcData' 'FrProcData' 'FrSimData' 'FrSerData' 'Frsummary'...
      'FrTrigData' 'FrSimEvent'};
nozeroinf=find(indstruct);

[sel,ok]=listdlg('PromptString',{'Select a Structure from List:' ''},...
   'Name','Data Structure Explorer',... 
   'selectionmode','single',...
   'ListSize',[230,200],...
   'Liststring',structname(nozeroinf));

chk=structname{nozeroinf(sel)};

switch chk
case 'FrStatData'
   
case 'FrAdcData'
   data=fmnl_extrfradc(vartoc.fid,vartoc.nframe,vartoc.posfradc,vartoc.nadc);
   data.t0=vartoc.gtimes(1)+vartoc.gtimen(1)*1e-9; %
   data.fid=vartoc.fid;
case 'FrProcData'
case 'FrSimData'
case 'FrSerData'
   data=fmnl_extrfrser(vartoc.fid,vartoc.nframe,vartoc.posfrser,vartoc.nser);
   data.t0=vartoc.gtimes(1)+vartoc.gtimen(1)*1e-9; %
   data.fid=vartoc.fid;
case 'Frsummary'
case 'FrTrigData'
case 'FrSimEvent'
end

   
   

