function g=sds2gd(file,k,cont)
%SDS2GD  creates a gd with the data of an sds file
%
%   file    input file
%   k       number of the channel

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('file','var')
    file=selfile(' ');
end

sds_=sds_open(file);
nch=sds_.nch;

if ~exist('cont','var')
    cont=-1;
end
tinit=check_mjd(sds_.t0,cont);

if ~exist('k')
    if nch > 1
        answ=inputdlg({'Channel sequence number ?'}, ...
            'Channel',1,{'1'});
        k=eval(answ{1});
    else
        k=1;
    end
end

A=fread(sds_.fid,[sds_.nch,sds_.len],'float');

g=gd(A(k,:));

g=edit_gd(g,'ini',tinit,'dx',sds_.dt,'capt',sds_.capt);
