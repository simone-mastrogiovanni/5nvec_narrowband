function vbl_closew(vbl_,blpoint,nblocks)
% VBL_CLOSEW closes a vbl file with the index of blocks
%
%    vbl_closew(vbl_,blpoint,nblocks)
%
%    vbl_      the vbl structure
%    blpoint   array of the block pointers
%    nblocks   number of blocks

fwrite(vbl_.fid,blpoint,'int64');
fwrite(vbl_.fid,nblocks,'int64');
fprintf(vbl_.fid,'[-INDEX]');

fclose(vbl_.fid);
