function [d,r,fid,reclen,g,r_struct]=fr_open(ntype,file,chs,dslen1,dstype,rglen,dt0,sp,frame4par)
%FR_OPEN  creates a ds and an rg, opens an R87 file, creates a gd for matlab files
%
%        [d,r,fid,reclen,g,r_struct]=fr_open(ntype,file,chs,dslen,dstype,rglen,dt0,sp,frame4par)
%
%        ntype      type of data format
%        file       file with path
%        chs        channel (for matlab data)
%        dslen      ds length
%        dstype     ds type
%        rglen      rg length
%        dt0        sampling time (for simulation)
%        sp         spectrum double array (for simulation)
%        frame4par  Structure with channel parameters from Frame Version 4
%
%        d          ds object
%        r          rg object
%        fid        for R87 file
%        reclen     record length for R87 file
%        g          gd object for matlab file
%        r_struct   read structure

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=0;g=gd(1);r=rg(2);reclen=1;

dslen=reset_dslen(dslen1,ntype,sp);
r_struct=0;

switch ntype
case 1
   r_struct.file=file;
   r_struct.select={chs};
   
   [fid,r_struct]=open_snf_read(r_struct);
   [d,r]=inifr2ds(dslen,dstype,rglen);
case 2
   vers=fmnl_chkver(file);
   r_struct.vers=vers;
   
   if vers >= 4
      
   [fid,message]=fopen(file,'r',frame4par.machtype);
       
    if fid == -1
      disp(message);
    end

    r_struct.machtype=frame4par.machtype;
    r_struct.nframe=frame4par.nframe;
    r_struct.t0=frame4par.t0;
    r_struct.dt=frame4par.dt;
    r_struct.distch=frame4par.distch;
    r_struct.compress=frame4par.compress;
    r_struct.typ=frame4par.typ;
    r_struct.nbtype=frame4par.nbtype;
    r_struct.type=frame4par.type;
    r_struct.ndata=frame4par.ndata;
    r_struct.cont.file=file;
        
   if strcmp(r_struct.type,'uchar') == 1
   disp('No Process Available For Char Data Type');
   keyboard
   return
   end     
   
   else
      
   struct_num=fmnl_dict(file);
   r_struct=fmnl_open(file,0);
   r_struct.vers=vers;
   r_struct.struct_num=struct_num;
   fid=r_struct.cont.fid;
   
   end

   [d,r]=inifr2ds(dslen,dstype,rglen);

 case 3
   [d,r]=inifr2ds(dslen,dstype,rglen);
 case 4
   [d,r]=inifr2ds(dslen,dstype,rglen);
   [fid,reclen,initime,samptim]=open_r87(file);
case 5
   com=['load ' file];eval(com);
   rate=strcat('rate_',chs);
   dt=1/eval(rate);
   d=ds(dslen);d=edit_ds(d,'dt',dt,'type',dstype);
   creagd=strcat('g=gd(',chs,');');
   eval(creagd);g=edit_gd(g,'dx',dt);n_gd(g)
case 100
   d=ds(dslen);
   d=edit_ds(d,'dt',dt0,'type',dstype);
   r=zeros(1,3*(dslen/2));
end

r_struct
