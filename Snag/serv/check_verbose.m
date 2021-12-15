function verb=check_verbose(struct,verb)
%CHECK_VERBOSE   checks the presence of struct.verbose
%
% If struct.verbose doesn't exist, takes the given value,
%  otherwise verb=struct.verbose

if isfield(struct,'verbose')
   verb=struct.verbose;
end
