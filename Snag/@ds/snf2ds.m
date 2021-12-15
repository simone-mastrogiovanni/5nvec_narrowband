function [d,ring]=snf2ds(d,ring,fid,r_struct)
%SNF2DS  generates a data-stream from an snf file
%
%      [d,ring]=snf2ds(d,ring,fid,r_struct)
%
% This is a ds server.
% It must be initialized by inifr2ds, or equivalently, that creates a ds and an rg.
% The first arguments is a ds, the second an rg (tipically with double the length 
%  of a frame).
%
%
% Operation:
%
% if d.lcw == 0 -> initializes
% if d.lcw ~= d.lcr exits
% if d.lcw < d.lcr  error
% if d.lcw > d.lcr  warning
%
% 
%  Interlaced operation:
% 
% chunk 1 y1   0 1 1 1 | 1
% chunk 2 y2   1 1 1 2 |
% chunk 3 y1   1 2 2 2 | 2  No new data
% chunk 4 y2   2 2 2 3 |
% chunk 5 y1   2 3 3 3 | 3  No new data
% chunk 6 y2   3 3 3 4 |
%
% In the case of interlaced operations, the data are shifted of len/4:
% the first len/4 data are set to 0;
% this because to not overlook the beginning data.


% Version 1.0 - May 1999 - March 2000
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=d.len;
len2=len/2;
len4=len/4;

if d.lcw == 0
   d.cont=0;
   d.capt=r_struct.file;
   [fid,r_struct]=open_snf_read(r_struct);
end

reclen=r_struct.reclen;

totin=totin_rg(ring);
totout=totout_rg(ring);
nc1=d.nc1;
nc2=d.nc2;

if d.type == 2
else
    if d.type == 1
    end
end

if d.type == 2
   if nc1 <= nc2  % beginning and/or odd chunks: produce a d.y1
      if nc1 == 0
%	      while (totin-totout) < len  % if there are few ring data, get more
   	      d.cont=d.cont+1;
      	   [r_struct,v]=read_snf_ds(fid,r_struct);
         	nv=length(v);
         	switch r_struct.obj
         	case 'ds'
            	dt=r_struct.ds.dt;
         	case 'mds'
            	dt=r_struct.mds.dt;
         	end

      	   ring=write_rg(ring,v,t0+dt*(nv-1));
      	   totin=totin_rg(ring);
      	   d.dt=dt;
            ring=setdx_rg(ring,dt);
         end
         
         [ring,v]=read_rg(ring,len);        % take the data from ring
         
         d.y1(1:len4)=d.y1(1:len4)*0;
         d.y1(len4+1:5*len4)=v;
      end
         
      d.lcw=d.lcw+1;
      d.nc1=d.nc1+1;
      
   	lcw=sprintf('%d',d.lcw);
     	disp(strcat('ds chunk -> ',lcw,' - y1'));
   else                            % even chunks :  produces d.y2
      while (totin-totout) < len   % if there are few ring data, get more
   	   d.cont=d.cont+1;
         [r_struct,v]=read_snf_ds(fid,r_struct);
        	nv=length(v);
        	switch r_struct.obj
        	case 'ds'
           	dt=r_struct.ds.dt;
        	case 'mds'
           	dt=r_struct.mds.dt;
         end
           
			ring=write_rg(ring,v,t0+dt*(nv-1));
     	   totin=totin_rg(ring);
         d.dt=dt;
         ring=setdx_rg(ring,dt);
      end
      
      [ring,v]=read_rg(ring,len);        % take the data from ring
      
      d.y2(1:3*len4)=d.y1(len2+1:5*len4);
      d.y2(3*len4+1:len)=v(1:len4);
      d.y1(1:len4)=d.y2(len2+1:3*len4);
      d.y1(len4+1:5*len4)=v;
      
      d.lcw=d.lcw+1;          
      d.nc2=d.nc2+1;
     
      lcw=sprintf('%d',d.lcw);
      disp(strcat('ds chunk -> ',lcw,' - y2'));
   end
else  % d.type = 1  or  0
   while (totin-totout) < len
      d.cont=d.cont+1;
      [r_struct,v]=read_snf_ds(fid,r_struct);
     	nv=length(v);
      switch r_struct.obj
     	case 'ds'
        	dt=r_struct.ds.dt;
      case 'mds'
         dt=r_struct.mds.dt;
      end
         
      ring=write_rg(ring,v,t0+dt*(nv-1));
      totin=totin_rg(ring);
      d.dt=dt;
      ring=setdx_rg(ring,dt);
   end
  
   if d.type == 1
      d.y2=d.y1;
   end
   
   [ring,v]=read_rg(ring,len);
   d.y1(1:len)=v;
   
   d.lcw=d.lcw+1;
   d.nc1=d.lcw;
   lcw=sprintf('%d',d.lcw);
   disp(strcat('ds chunk -> ',lcw,' - y1'));
end
