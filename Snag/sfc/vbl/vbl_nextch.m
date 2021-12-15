function vbl_=vbl_nextch(vbl_)
%VBL_NEXTCH reads the next channel header

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if vbl_.ch0.next < 0
    vbl_=vbl_headchr(vbl_);
else
    if vbl_.ch0.next > 0
        status=fseek(vbl_.fid,vbl_.ch0.next,'bof');
        vbl_=vbl_headchr(vbl_);
    else
        vbl_.eob=1;
    end
end
