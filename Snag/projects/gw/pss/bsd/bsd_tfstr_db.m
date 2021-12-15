function out=bsd_tfstr_db(list,what,par)
% access bsd db for synthetic results on tfstr
%
%        out=bsd_tfstr_db(list,what,par)
%
%    list    file list with path
%    what    items
%              'basic'  basic parameters
%              'hdens'  t-f h densities
%              'wn'     wiener filters
%              'peaks'  peak table data
%              'skyp'   skypoints parameters
%              'pers'   persistence
%              'tfhist' t-f histograms
%    par     parameter structure
%              tim  [min max] times
%              fr   [min max] frequencies


% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=struct();

if ~exist('par','var')
    par=struct();
end
if ~isfield(par,'tim')
    par.tim=[0 1.0e6];
end
if ~isfield(par,'fr')
    par.fr=[0 1.0e6];
end

fidlist=fopen(list,'r');
nfiles=0;
nofiles=0;

while (feof(fidlist) ~= 1)
    str=fgetl(fidlist);
    str1=str(1);
    if strcmp(str1,'*')
        nofiles=nofiles+1;
        fprintf('  %s  NOT CONSIDERED \n',str);
        continue
    else
        nfiles=nfiles+1;
        file{nfiles}=str;
        fprintf('  %s \n',str);
    end
end
nfiles,nofiles

switch what
    case 'basic'
        out.inifr=zeros(1,nfiles);
        out.lfft=zeros(1,nfiles);
        out.dfr=zeros(1,nfiles);
        out.DT=zeros(1,nfiles);
        ii=0;
        for i = 1:nfiles
            [pathstr,name,ext]=fileparts(file{i});
            load(file{i});
            eval(['tfstr=tfstr_gd(' name ');'])
            name
            if tfstr.t0 > par.tim(1) & tfstr.t0 < par.tim(2)
                ii=ii+1;
                out.inifr(ii)=tfstr.inifr;
                out.lfft(ii)=tfstr.lfft;
                out.dfr(ii)=tfstr.dfr;
                out.DT(ii)=tfstr.DT;
            end 
            eval(['clear ' name])
        end
        out.inifr=out.inifr(1:ii);
        out.lfft=out.lfft(1:ii);
        out.dfr=out.dfr(1:ii);
        out.DT=out.DT(1:ii);
        out.peaktype=tfstr.peaktype;
        out.ant=tfstr.ant;
        out.t0=tfstr.t0;
        out.bandw=tfstr.bandw;
        out.gdlen=tfstr.gdlen;
    case 'hdens'
        out.inifr=zeros(1,nfiles);
        out.lfft=zeros(1,nfiles);
        out.dfr=zeros(1,nfiles);
        out.DT=zeros(1,nfiles);
        ii=0;
        for i = 1:nfiles
            [pathstr,name,ext]=fileparts(file{i});
            load(file{i});
            eval(['tfstr=tfstr_gd(' name ');'])
            name
            if tfstr.t0 > par.tim(1) & tfstr.t0 < par.tim(2)
                ii=ii+1;
                out.inifr(ii)=tfstr.inifr;
                out.lfft(ii)=tfstr.lfft;
                out.dfr(ii)=tfstr.dfr;
                out.DT(ii)=tfstr.DT;
            end 
            eval(['clear ' name])
        end
        out.inifr=out.inifr(1:ii);
        out.lfft=out.lfft(1:ii);
        out.dfr=out.dfr(1:ii);
        out.DT=out.DT(1:ii);
        out.peaktype=tfstr.peaktype;
        out.ant=tfstr.ant;
        out.t0=tfstr.t0;
        out.bandw=tfstr.bandw;
        out.gdlen=tfstr.gdlen;
    case 'wn'
    case 'peaks'
    case 'skyp'
    case 'pers'
    case 'tfhist'
end