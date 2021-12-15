function senserr=get_sens_error(arr,minerr)
% GET_SENS_ERROR  determines the sensitivity error in an array
%
%   arr      data array
%   minerr   min sensitivity error (in power of 10) (def -12)

if ~exist('minerr','var')
    minerr=-12;
end
arr=abs(arr);
[i1,i2,arr]=find(arr);
amax=max(arr);
amin=min(arr);

nmax=floor(log10(amax));

for i = nmax:-1:minerr
    dec=10^i;
    arr1=round(arr/dec)*dec;
    if sum(abs(arr-arr1)) < 1.e-12
        break
    end
end

senserr=dec;