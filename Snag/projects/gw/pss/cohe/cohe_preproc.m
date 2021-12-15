function [gcl g0 g45 wien]=cohe_preproc(gin,g0,g45,wstr,filesegs)
% [gcl g0 g45 wien]=cohe_preproc(gin,g0,g45,filesegs,wstr)
%
%   gin        input data gd
%   g0,g45     basic simulation gds (or 5-vect)
%   wstr       wiener filter structure
%   filesegs   permitted segments file 
%             1: search file, -1: search file unpermitted; 0 or absent, no

% Version 2.0 - July 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

y=y_gd(gin);
dt=dx_gd(gin);
cont=cont_gd(gin);
t0=cont.t0;
wien=y*0+1;

if exist('filesegs','var')
    wien=wien*0;
    ic=1;
    if isnumeric(filesegs)
        ic=filesegs;
        snag_local_symbols;
        direc=[snagdir 'projects\gw\pss\data'];
        filesegs=selfile(direc,'*','Which file ?');
    end
    seg=read_Ssegments(1,filesegs);
    [i1 i2]=size(seg);
    for i = 1:i2
        k1=round((seg(1,i)-t0)*86400/dt+1);
        k2=round((seg(2,i)-t0)*86400/dt+1);
        if k1 < 0
            k1=1;
        end
        if k2 < 0
            k2=0;
        end
        wien(k1:k2)=1;
    end
    if ic == -1
        wien=1-wien;
    end
    permtime=sum(wien)/length(wien);
    fprintf('Percentage of permitted time : %f \n',permtime);
    y=y.*wien;
end

wien=check_nonzero(y);
gcl=edit_gd(gin,'y',y);
g0=edit_gd(g0,'y',y.*wien);
g45=edit_gd(g45,'y',y.*wien);
ontime=sum(wien)/length(wien);
fprintf('Percentage of on time : %f \n',ontime);