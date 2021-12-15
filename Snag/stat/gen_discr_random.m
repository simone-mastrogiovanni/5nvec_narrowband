function r=gen_discr_random(in,p,n)
%GEN_RANDOM  generates n random numbers with discrete probabilities p
%            on the numbers in

% Version 2.0 - June 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=rand(1,n);
r=zeros(1,n);
N=length(in);

P=cumsum(p);

for i = 1:n
    bas=0;
    for j = 1:N
        if a(i) >= bas && a(i) < P(j);
            r(i)=j;
            break
        end
        bas=P(j);
    end
end

r=in(r);