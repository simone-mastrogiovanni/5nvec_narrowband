str={'Access by file' 'Access by time'};

[atype iok]=listdlg('PromptString','Select an access type:',...
   'Name','Data access type',...
   'ListSize',[160 100],...
   'SelectionMode','single',...
   'ListString',str);

switch atype
case 1
   D_B.access='by file';
   dataString=[...
			'[ntype,file]=db_fildatsel;' ...
			'D_B.data.type=ntype;' ...
   		    'D_B.data.file=file;' ...
			'[chn,chs,dt,dlen,sp]=db_selch(ntype,file);' ...
			'D_B.data.chname=chs;' ...
			'D_B.data.chnumber=chn;' ...
			'D_B.data.dt=dt;' ...
			'D_B.data.dlen=dlen;' ...
			'D_B.data.sp=sp;' ...
         'if ntype == 100; D_B.data.file=chs; end;'];
   eval(dataString);
case 2
   D_B.access='by time';
   dataString=[...
         'disp(''Only for Frame Matlab Native Library'');' ...
         'ntype=2;' ...
         '[D_B,r_struct]=d_b_timeaccess(D_B);' ...
         'file=r_struct.cont.file;' ...
			'D_B.data.type=ntype;' ...
   		'D_B.data.file=file;' ...
			'[chn,chs,dt,dlen,sp]=db_selch(ntype,file);' ...
			'D_B.data.chname=chs;' ...
			'D_B.data.chnumber=chn;' ...
			'D_B.data.dt=dt;' ...
			'D_B.data.dlen=dlen;' ...
			'D_B.data.sp=sp;' ...
         'if ntype == 100; D_B.data.file=chs; end;'];
   eval(dataString);
end
