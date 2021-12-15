function g=dds2gd(file,k,cont)
%DDS2GD  creates a gd with the data of an dds file
%
%   file    input file
%   k       number of the channel

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file','var')
    file=selfile(' ');
end

dds_=dds_open(file);
nch=dds_.nch;

if ~exist('cont','var')
    cont=-1;
end
tinit=check_mjd(dds_.t0,cont);

if ~exist('k')
    if nch > 1
        answ=inputdlg({'Channel sequence number ?'}, ...
            'Channel',1,{'1'});
        k=eval(answ{1});
    else
        k=1;
    end
end

A=fread(dds_.fid,[dds_.nch,dds_.len],'double');

g=gd(A(k,:));

g=edit_gd(g,'ini',tinit,'dx',dds_.dt,'capt',dds_.capt);
