function A=read_cand_2012(list,head,verb,fr,bet,lam,sd,amp,cr)
% read_cand_2012  reads candidate text files
%
%   works both with txt and mat files
%
%   A=read_cand_2012(list,head,fr,bet,lam,sd,amp,cr)
%
%   list   file with list of files; to create list, dir /s/b > list.txt
%   head   header (ex.: "AdaptivehoughVSR4")
%   verb   verbosity
%   fr     (frmin frmax)
%   bet    (betmin betmax)
%   lam    (min max)
%   sd     (min max)
%   amp    (min max)
%   cr     (min max)
%
%  matrix A : frequency [Hz] lambda [deg]  beta [deg]   
%             spindown [Hz/s] Amplitude  CR DDl DDb

% Version 2.0 - July 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome


if ~exist('verb','var')
    verb=0;
end

if ~exist('fr','var')
    fr=0;
end

if ~exist('bet','var')
    bet=0;
end

if ~exist('lam','var')
    lam=0;
end

if ~exist('sd','var')
    sd=0;
end

if ~exist('amp','var')
    amp=0;
end

if ~exist('cr','var')
    cr=0;
end

if length(fr) < 2
    fr(1)=-1;fr(2)=1e6;
end

if length(bet) < 2
    bet(1)=-91;bet(2)=91;
end

if length(lam) < 2
    lam(1)=-1e6;lam(2)=1e6;
end

if length(sd) < 2
    sd(1)=-1e6;sd(2)=1e6;
end

if length(amp) < 2
    amp(1)=-1;amp(2)=1e6;
end

if length(cr) < 2
    cr(1)=-1;cr(2)=1e6;
end

fidlist=fopen(list,'r');
nfiles=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',file{nfiles});
    if verb > 0
        disp(str);
    end
end
fclose(fidlist);

A=[];
nbtot=0;

for kfil = 1:nfiles
    str=file{kfil};
    [pathstr, name, ext] = fileparts(str);
    ii=strfind(str,head);
    if isempty(ii) 
        continue
    end
    idx = strfind(str,'_FR');
    str1=str(idx+3:length(str));
    idx1 = strfind(str1,'_');
    idx2 = strfind(str1,'.txt');
    frmin=str2num(str1(1:idx1(1)-1));
    frmax=str2num(str1(idx1(1)+1:idx1(2)-1));
    bemin=str2num(str1(idx1(2)+3:idx1(3)-1));
    bemax=str2num(str1(idx1(3)+1:idx2-1));
    if fr(2) < frmin
        continue
    end
    if fr(1) > frmax
        continue
    end
    if bet(2) < bemin
        continue
    end
    if bet(1) > bemax
        continue
    end
    B=load(str);
    if strcmp(ext,'.mat')
        B=B.A;
    end
    
    i=find(B(:,1) >= fr(1) & B(:,1) <= fr(2));
    B=B(i,:);
    i=find(B(:,2) >= lam(1) & B(:,2) <= lam(2));
    B=B(i,:);
    i=find(B(:,3) >= bet(1) & B(:,3) <= bet(2));
    B=B(i,:);
    i=find(B(:,4) >= sd(1) & B(:,4) <= sd(2));
    B=B(i,:);
    i=find(B(:,5) >= amp(1) & B(:,5) <= amp(2));
    B=B(i,:);
    i=find(B(:,6) >= cr(1) & B(:,6) <= cr(2));
    B=B(i,:);
    
    [nb1 nb2]=size(B);
    nbtot=nbtot+nb1;
    if floor(kfil/100)*100 == kfil
        disp(sprintf(' %d files out of %d ; %d data',kfil,nfiles,nbtot));
    end
    
    A=[A; B];
end

A=sortrows(A);