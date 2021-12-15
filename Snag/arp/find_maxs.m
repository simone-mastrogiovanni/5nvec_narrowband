function [m,i,j]=find_maxs(matr)
%FIND_MAXS  finds the maxima of a matrix
%
%   matr   input matrix
%
%   m      maximum
%   i,j    indices

% Version 2.0 - September 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


[ni,nj]=size(matr);
app=zeros(ceil(ni*nj/4),3);
ii=0;

if ni == 1 | nj == 1
    matr=matr(:);
    for i = 2:ni*nj-1
        m=matr(i);
        if m >= matr(i-1)
            if m > matr(i+1)
                ii=ii+1;
                app(ii,1)=m;
                app(ii,2)=i;
            end
        end
    end
    
    if matr(1) > matr(2)
        ii=ii+1;
        app(ii,1)=matr(1);
        app(ii,2)=1;
    end
    
    if matr(ni*nj) > matr(ni*nj-1)
        ii=ii+1;
        app(ii,1)=matr(ni*nj);
        app(ii,2)=ni*nj;
    end
    
    app=app(1:ii,1:3);
    m=app(:,1);
    [m,jj]=sort(m);
    jj=jj(ii:-1:1);
    m=m(ii:-1:1);
    if ni == 1
        i=m*0+1;
        j=app(jj,2);
    end
    if nj == 1
        j=m*0+1;
        i=app(jj,2);
    end
    
    return
end

for i = 2:ni-1
    for j = 2:nj-1
        m=matr(i,j);
        if m >= matr(i-1,j)
            if m > matr(i+1,j)
                if m >= matr(i,j-1)
                    if m > matr(i,j+1)
                        if m >= matr(i-1,j-1)
                            if m > matr(i+1,j+1)
                                if m >= matr(i-1,j+1)
                                    if m > matr(i+1,j-1)
                                        ii=ii+1;
                                        app(ii,1)=m;
                                        app(ii,2)=i;
                                        app(ii,3)=j;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

if nj > 1
	for i = 2:ni-1
        m=matr(i,1);
        if m >= matr(i-1,1)
            if m > matr(i+1,1)
                if m >= matr(i-1,2)
                    if m > matr(i,2)
                        if m > matr(i+1,2)
                            ii=ii+1;
                            app(ii,1)=m;
                            app(ii,2)=i;
                            app(ii,3)=1;
                        end
                    end
                end
            end
        end
        m=matr(i,nj);
        if m >= matr(i-1,nj)
            if m > matr(i+1,nj)
                if m >= matr(i-1,nj-1)
                    if m > matr(i,nj-1)
                        if m > matr(i+1,nj-1)
                            ii=ii+1;
                            app(ii,1)=m;
                            app(ii,2)=i;
                            app(ii,3)=nj;
                        end
                    end
                end
            end
        end
	end
end

if ni > 1
	for j = 2:nj-1
        m=matr(1,j);
        if m >= matr(1,j-1)
            if m > matr(1,j+1)
                if m >= matr(2,j-1)
                    if m > matr(2,j)
                        if m > matr(2,j+1)
                            ii=ii+1;
                            app(ii,1)=m;
                            app(ii,2)=1;
                            app(ii,3)=j;
                        end
                    end
                end
            end
        end
        m=matr(ni,j);
        if m >= matr(ni,j-1)
            if m > matr(ni,j+1)
                if m >= matr(ni-1,j-1)
                    if m > matr(ni-1,j)
                        if m > matr(ni-1,j+1)
                            ii=ii+1;
                            app(ii,1)=m;
                            app(ii,2)=ni;
                            app(ii,3)=j;
                        end
                    end
                end
            end
        end
	end
end
        
app=app(1:ii,1:3);

m=app(:,1);
i=app(:,2);
j=app(:,3);

[m,jj]=sort(m);
jj=jj(ii:-1:1);
m=m(ii:-1:1);
i=i(jj);
j=j(jj);