function [vec tim0 cont sds_]=read_sds_vec(sds_,n,texp)
% READ_SDS_VEC  simple read of single channel sds files
%                   uses vec_from_sds
%
%     n       length of the chunk
%     texp    expected t

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if sds_.fid < 0
    sds_.eof=4;
    disp('fid error')
    return
end

if sds_.eof == 3
    return
end

[vec,sds_,tim0,holes,n_nan]=vec_from_sds(sds_,1,n);
if n_nan > 0
    vec(1:n)=0;
end

cont=0;
if abs(tim0-texp) > 1e-7
    cont=1;
end