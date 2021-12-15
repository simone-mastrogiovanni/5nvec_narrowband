function out=blank_trim(in)
%BLANK_TRIM  trims blanks and nulls from both sides of a string

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

din=double(in);
i1=0;c1=0;
i2=0;

for i = 1:length(din)
    if din(i) ~= 0 & din(i) ~= 32
        c1=1;
        i2=i;
    end
    if c1 == 0
        i1=i;
    end
end

out=char(din(i1+1:i2));