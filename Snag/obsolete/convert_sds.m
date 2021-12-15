function convert_sds(path,file)

disp(' ')
disp(' *** If doesn''t appear "Starting..." immediately, stop the function :')
disp('      the file is not an old sds !')
disp(' ')
disp(' *** The subfolder "a" must exist !')

sdsold_=sds_open_old([path file]);
if sdsold_.prot ~= 1
    disp(' *** File not in old sds format')
    return
else
    disp(' Starting...')
end
sds_=sdsold_;
 fil=[path 'a\' file]
sds_=sds_openw(fil,sds_);

% for i = 1:sds_.len*sds_.nch
%     w=fread(sdsold_.fid,1,'float');
%     fwrite(sds_.fid,w,'float');
% end

n=sds_.len*sds_.nch;
w=fread(sdsold_.fid,n,'float');
fwrite(sds_.fid,w,'float');