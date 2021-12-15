function g=gd_image(par,typ,nogd)
%GD_IMAGE  creates a gd2 or an array containing an image
%
%  par   image parameters: [[dx1 dx2]; [ ini1 ini2]; [n1 n2]; ...]
%        after the first 3 coupe of parameters there are the specific
%        image parameters
%
%  typ   a double matrix containing the image or a string 
%        describing an image. If is a matrix, its dimensions
%        replace n1,n2; types are:
%         'blank'
%         'circle' par: center [x,y], [inner radius, outer radius]
%         'rectangle' par: center [x,y], [side1, side2], [angle (deg), thickness]
%         'gaussnoise' par:[mean,stdev] 
%  nogd  if exist and is not 0, creates an array; it doesnt work if typ is
%        a double matrix

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if exist('nogd')
    if nogd ~= 0
        nogd=1;
    end
else
    nogd=0;
end

if isnumeric(typ)
    g=gd2(typ);
    [n1,n2]=size(typ);
    g=edit_gd2(g,'n',n1*n2,'m',n2,'ini',par(2,1),'ini2',par(2,2),...
        'dx',par(1,1),'dx2',par(1,2));
    return;
end

n1=par(3,1);
n2=par(3,2);
g=zeros(n1,n2);
capt='';

switch typ
    case 'circle'
        for i = 1:n1
            x=par(2,1)+(i-1)*par(1,1);
            for j = 1:n2
                y=par(2,2)+(j-1)*par(1,2);
                if ((x-par(4,1))^2+(y-par(4,2))^2 > par(5,1)^2) & ...
                        ((x-par(4,1))^2+(y-par(4,2))^2 < par(5,2)^2)
                    g(i,j)=g(i,j)+1;
                end
            end
        end
        capt='circle';
    case 'rectangle'
%         for i = 1:n1
%             x=par(2,1)+(i-1)*par(1,1);
%             for j = 1:n2
%                 y=par(2,2)+(j-1)*par(1,2);
%                 if ((x-par(4,1))^2+(y-par(4,2))^2 > par(5,1)) & ...
%                         ((x-par(4,1))^2+(y-par(4,2))^2 < par(5,2))
%                     g(i,j)=g(i,j)+1;
%                 end
%             end
%         end
%         capt='rectangle';
    case 'gaussnoise'
        set_random;
        g=randn(n1,n2)*par(4,2)+par(4,1);
        capt='gaussnoise';
end

if nogd ~= 0 
    return
end

g=gd2(g);
g=edit_gd2(g,'n',n1*n2,'m',n2,'ini',par(2,1),'ini2',par(2,2),...
    'dx',par(1,1),'dx2',par(1,2),'capt',capt);

        