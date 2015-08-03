function defArgs = setOptArgs(a,defArgs)
% set non-specified optional parameters to default values

% a         : arguments passed with varargin
% defArgs   : on input default arguments
%             on output default argument overwritten by the specified ones (if not empty)
% adapted from Omid Khanmohamadi on matlabcentral

a     = a(:);
len_a = length(a);
ind   = false(len_a,1);
for ctr = 1:len_a
    if isequal(a{ctr},[]), ind(ctr) = true; end
end
[defArgs{~ind}] = a{~ind};