str={'Running plot' 'Running power spectrum' 'Time-frequency power spectrum' ...
      'Running histograms' 'Event finder' 'Data resume`' ...
      'Extract data to a gd' 'Time-frequency innovation power spectrum' 'STFT'};

[ptype iok]=listdlg('PromptString','Select a processing:',...
   'Name','DataStream processing',...
   'ListSize',[300 300],...
   'SelectionMode','single',...
   'ListString',str);

switch ptype
case 1
   D_B.proc.type='rplot';
case 2
   D_B.proc.type='rpows';
case 3
   D_B.proc.type='tfpows';
case 4
   D_B.proc.type='rhist';
case 5
   D_B.proc.type='evenf';
case 6
   D_B.proc.type='summary';
case 7
   D_B.proc.type='toagd';
case 8
   D_B.proc.type='dtfpows';
case 9
    D_B.proc.type='stft';
end

