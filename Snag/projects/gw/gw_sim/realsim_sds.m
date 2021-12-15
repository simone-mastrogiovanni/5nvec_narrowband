function fileout=realsim_sds(sds_in,chn,sim_str,fdb_str,doptab)
%REALSIM_SDS  creates one simulated sds data files from a real data file
%
%  sds_in   first input data file (sds format)
%  chn      channel number of data to be added with simulation
%
%  sim_str  simulation structure
%       type     = 0 stationary, 1 non-stationary
%       nss      non-stationarity structure (if type=1)
%       ant      antenna structure (only for signal simulation)
%       sour     source structure (only for signal simulation)
%       lchunk   chunk length for simulation
%
%  fdb_str  files database structure
%       folder   database folder
%
% All the basic structures pertaining the PSS project are defined in the PSS_UG

% Version 2.0 - June 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=sim_str.lchunk;

sigsim=0;

sds_in_=sds_open(sds_in,0);
t0=sds_in_.t0;
dt=sds_in_.dt;
[path,file,ext]=fileparts(sds_in);
sds_=sds_in_;

if isfield(sim_str,'sour')
    sigsim=1
    sources=sim_str.sour;
    antenna=sim_str.ant;
    data.n=sim_str.lchunk;
    data.dt=sds_.dt;
    data.t0=t0;
    data.t=t0;
    data.type=1;
end

if sigsim == 0
    disp(' *** NO SIMULATED SOURCES ')
end

sds_.nch=1;
sds_.capt=[file ext ' with data simulation'];
sds_.ch{1}='hrec with simulated sources';

filename=[file '_realsim' ext];
fileout=[fdb_str.folder,filename];
sds_=sds_openw(fileout,sds_);

t=t0;

while 1 > 0
    [A,count]=fread(sds_in_.fid,sds_in_.nch*len,'float');
    nread=count/sds_in_.nch;  % disp(nread)
    
    if nread > 0
        dd=A(:,chn);
    else
        break
    end
   if sigsim > 0
       data.n=nread;
       [ps,sources,data]=ps_chunk(sources,antenna,data,doptab);%size(dd),size(ps)
       dd=dd+ps.';
   end
   fwrite(sds_.fid,dd,'float32');
end

fclose(sds_.fid);
