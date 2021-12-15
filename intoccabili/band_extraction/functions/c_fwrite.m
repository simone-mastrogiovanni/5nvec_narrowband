function c_fwrite(fid,vec,typ)
%C_FWRITE  writes complex data in natural form (r1,i1,r2,i2,...)
%
%  fid
%  vec    complex vector
%  typ    'float',...

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

lv=length(vec);
% if lv > 16384
%     vec1(1:2*16384)=0;
% else
%     vec1(1:2*lv)=0;
% end
	
i=0;
while lv > 0
	if lv > 16384
        lv1=16384;
	else
        lv1=lv;
    end
    vec1=zeros(1,2*lv1); % correzione 23-8-2011
	
	vec1(1:2:2*lv1)=real(vec(i+1:i+lv1));
	vec1(2:2:2*lv1)=imag(vec(i+1:i+lv1));
	
	fwrite(fid,vec1,typ);
    lv=lv-lv1;
    i=i+lv1;
end