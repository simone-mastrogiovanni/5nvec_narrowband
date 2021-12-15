function out=bit_extract(in,mi,ma)
%BIT_EXTRACT  extracts bits from an integer value in
%
%   in    input number or array (it will be rounded)
%   mi    minimal index (min 1)
%   ma    max index

in=round(in);
in1=floor(in./2^(mi-1));  % left shift
in2=floor(in1./2^(ma-mi+1))*2^(ma-mi+1);
out=in1-in2;