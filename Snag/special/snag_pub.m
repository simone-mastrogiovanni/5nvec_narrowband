function dir=snag_pub(mfile,typ,outputdir_or_options)
%SNAG_PUB publishes an mfile
%
%   dir=snag_pub(mfile,typ,outputdir_or_options)
%
%    mfile      the m-file to publish
%    typ        format ('doc','html','latex','ppt','xml')
%    outputdir_or_options  in case of options, the structure with elements:
%        .format
%        .outputDir   (should end with '\'; default tmp)
%        .showCode    true or false
%        .imageFormat
%
%    dir              output directory

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

options.outputDir=tempdir;
if exist('typ','var')
    options.format=typ;
else
    typ='html';
end

if exist('outputdir_or_options')
    if ischar(outputdir_or_options)
        options.outputDir=outputdir_or_options;
    else
        options=outputdir_or_options;
    end
end

dir=options.outputDir;

publish(mfile,options);

% winopen([dir mfile '.' typ])