function stat=crea_logxstat(logx_str)
%CREA_LOGXSTAT  creates the stat word for LogX format

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

stat=0;

switch logx_str.sign
    case 1
        stat=stat+1;
    case 0
        stat=stat+2;
end

switch logx_str.linlog
    case 2
        stat=stat+4;
    case 1
        stat=stat+64;
end

switch logx_str.dimen
    case 32
        stat=stat+5*8;
    case 16
        stat=stat+4*8;
    case 8
        stat=stat+3*8;
    case 4
        stat=stat+2*8;
    case 2
        stat=stat+8;
end
        
        
        
        