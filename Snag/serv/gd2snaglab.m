function gd2snaglab(gin,file)
%GD2SNAGLAB writes a gd in a SnagLab-SD file 
%
%    gd2snaglab(gin,file)
%
%  gin     gd input
%  file    output file

% Version 2.0 - February 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=fopen(file,'w');

fprintf(fid,'#SD\r\n')
fprintf(fid,' %s \r\n',capt_gd(gin));
fprintf(fid,' %d %g %g \r\n',n_gd(gin),ini_gd(gin),dx_gd(gin));

n=0;
y=y_gd(gin);

while n < n_gd(gin)
    n=n+1;
    fprintf(fid,'%g ',y(n));
    if floor(n/10)*10 == n
        fprintf(fid,'\r\n');
    end
end

fclose(fid);