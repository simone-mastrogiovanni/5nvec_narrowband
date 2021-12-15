function [fid,w_struct]=open_snf_write(w_struct,varargin)
%OPEN_SNF_WRITE  open a snf file for writing for ds and mds objects
%
%         [fid,w_struct]=open_snf_write(w_struct,varargin)
%
%   w_struct          write structure; the fields needed in input are:
%           .file     the file name
%           .obj      (= ds or mds) in the case of single ds input
%           .capt     caption (for mds)
%
%   varargin          any number of dss; if there is only one ds, the function
%                     opens a ds object file or an mds object file, depending
%                     on the value of w_struct.obj
%   fid               file identification number

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nch=length(varargin);
obj='mds';

if nch == 1
   obj=w_struct.obj;
end

w_struct.nform='x';
w_struct.complex=0;
w_struct.capt='automatically initialized file';

w_struct.obj=obj;

if obj == 'mds'
   w_struct.mds.nch=nch;
   w_struct.mds.lheadi=1;
   w_struct.mds.lheadd=1;
   w_struct.mds.headi.name{1}='recnum';
   w_struct.mds.headd.name{1}='rectim';
   w_struct.mds.headi.capt{1}='record number';
   w_struct.mds.headd.capt{1}='record time (mjd)';
   w_struct.mds.name=cell(nch,1);
   w_struct.mds.nform=cell(nch,1);
   w_struct.mds.units=cell(nch,1);
   w_struct.mds.len=zeros(nch,1);
   w_struct.mds.dt=zeros(nch,1);
   for i = 1:nch
      w_struct.mds.name{i}=inputname(1+i);
      w_struct.mds.nform{i}='float';
      w_struct.mds.wform{i}='float32';
      w_struct.mds.units{i}='mjd';
      w_struct.mds.len(i)=len_ds(varargin{i});
      w_struct.mds.dt(i)=dt_ds(varargin{i});
   end
   [fid,w_struct]=write_snf_header(w_struct);
   w_struct.trec=tini1_ds(varargin{1});
else
end

w_struct.trec=tini1_ds(varargin{1});