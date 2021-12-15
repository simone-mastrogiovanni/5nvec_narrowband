function [data,r_struct]=fmnl_extrch(r_struct)

%FMNL_EXTRCH
%             This function reads data from the selected channel in the frame identified
%             by index r_struct.it
%
%             r_struct structure
%                      .it        -> Frame index    
%                      .machtype  -> Machine type (see 'fopen' for details)
%                      .ndata     -> Length of data vector
%                      .nframe    -> Numer of frames
%                      .t0        -> Starting time
%                      .dt        -> Sampling time
%                      .distch    -> Positions of selected channel through frames
%                      .compress  -> Compression type
%                      .type      -> Data type
%                      .vers      -> Frame Format Version

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


[fid,message]=fopen(r_struct.cont.file,'r',r_struct.machtype);
      
    if fid == -1
       disp(message);
    end
    
   it=r_struct.it;
   ndata=r_struct.ndata;
   typ=r_struct.typ;
   nbtype=r_struct.nbtype;
   compress=r_struct.compress;
   
   fseek(fid,r_struct.distch(it),'bof');
   pos1=ftell(fid)
   lenfradc=fread(fid,1,'uint32'); % Read FrVect Header length
   fseek(fid,lenfradc+4,'cof'); % Go to channel name
   cname=fmnl_read_string(fid);
   fseek(fid,8,'cof');
   nbytes=fread(fid,1,'uint32');
   if compress == 0 | compress == 256
   data=(1:ndata)';
   data=fread(fid,ndata,r_struct.type);
   else
   unclen=uint32(ndata*nbtype);
   comp=fread(fid,nbytes,'*uchar');
   complen=uint32(nbytes);
   data=(frdecomp(unclen,comp,complen,compress,ndata,typ,nbtype))';
   end
   pos2=ftell(fid)
   r_struct.ndim=fread(fid,1,'uint32');
   r_struct.nx=fread(fid,r_struct.ndim,'uint32');
   r_struct.dx=fread(fid,r_struct.ndim,'float64');
   r_struct.startx=fread(fid,r_struct.ndim,'float64');
   r_struct.unitx=fmnl_read_string(fid);
   r_struct.unity=fmnl_read_string(fid);
   r_struct.next=fread(fid,1,'uint32');