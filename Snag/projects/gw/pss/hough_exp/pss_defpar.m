function p=pss_defpar
%PSS_DEFPAR   set default parameters for various situations

p=pss_par('init');

str={'Normal' 'Only signal' 'Only noise' 'High sensitivity' 'Test uniform map' 'Test point map'};

[sel,ok]=listdlg('PromptString','Mode Selection',...
   'SelectionMode','single',...
   'ListString',str);
   
switch str{sel}
case 'Only signal'
   p.tfmap.thr=100;
   p.source.snr=1000;
case 'Only noise'
   p.source.snr=0;
case 'High sensitivity'
   p.tfmap.thr=3;
case 'Test uniform map'
    p.source.snr=-1;
case 'Test point map'
    p.source.snr=-2;
end

p=pss_par(p);