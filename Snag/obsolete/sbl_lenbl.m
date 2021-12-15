function blen=sbl_lenbl(sbl_)
%SBL_LENBL  computes the block length

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

blen=16;

for i = 1:sbl_.nch
    typ=sbl_.ch(i).type;
    
    switch typ
        case 1
            hbl=16;
            blen1=hbl+sbl_.ch(i).lenx*sbl_.ch(i).leny;
        case 2
            hbl=16;
            blen1=hbl+sbl_.ch(i).lenx*sbl_.ch(i).leny*2;
        case 3
            hbl=16;
            blen1=hbl+sbl_.ch(i).lenx*sbl_.ch(i).leny*4;
        case 4
            hbl=16;
            blen1=hbl+sbl_.ch(i).lenx*ch(i).leny*4;
        case 5
            hbl=16;
            blen1=hbl+ch(i).lenx*sbl_.ch(i).leny*8;
        case 6
            hbl=16;
            blen1=hbl+sbl_.ch(i).lenx*sbl_.ch(i).leny*8;
        case 7
            hbl=16;
            blen1=hbl+sbl_.ch(i).lenx*sbl_.ch(i).leny*16;
        otherwise
            str=sprintf(' *** Case %d not implemented',typ);
            error(str)
            sbl_.eof=3;
            return
    end
    blen=blen+blen1;
end
