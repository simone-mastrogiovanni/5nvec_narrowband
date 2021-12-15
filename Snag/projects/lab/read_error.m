function rerr=read_error(vec)
% READ_ERROR evaluates the sensitivity error on a set of measures
%
%       rerr=read_error(vec)

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

a=abs(vec);
am=log10(max(a))

pow1=10;

for i = -pow1:am
    rerr1=10^i;
    e=max(abs(round(a/rerr1)*rerr1-a));
    if e < 0.0001*rerr1
        rerr=rerr1/2;
    end 
end
