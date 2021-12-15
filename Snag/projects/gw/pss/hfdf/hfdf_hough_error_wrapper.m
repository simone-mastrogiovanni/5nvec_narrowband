function [ierr,hfdf,job_info,checkE]=hfdf_hough_error_wrapper(peaks,basic_info,job_info,hm_job)

isecbelterr=1;
ierr=0;

while isecbelterr > 0
    try
        [hfdf,job_info,checkE]=hfdf_hough(peaks,basic_info,job_info,hm_job,isecbelterr);
    catch
%         fprintf('isecbelterr %d \n',isecbelterr)
        isecbelterr=isecbelterr+1;
        ierr=ierr+1;
        continue
    end
    isecbelterr=0;
end
