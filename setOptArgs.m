function defArgs = setOptArgs(a,defArgs)
% set non-specified optional parameters to default values
% This software is distributed under the MIT License (MIT): see copyright.txt 

%{
idea from Omid Khanmohamadi on matlabcentral

a         : arguments passed with varargin
defArgs   : on input default arguments
            on output default argument overwritten by the specified ones (if not empty)

example of use
    function rhopos=matfun(rho,varargin)
    defoptArgs	= {1e-12,'xxx'};                     	% default values for first and second optional arguments
    optArgs     = setOptArgs(varargin,defoptArgs) ;   	% merge specified and default values
    eps         = optArgs{1} ;                      	% resulting value for first argument
    caption   	= optArgs{2} ;                      	% resulting value for second argument
	....
%}

empty_a         = cellfun(@(x)isequal(x,[]),a);      	% indicate a that are not specified (empty)
[defArgs{~empty_a}] = a{~empty_a};                      % replace defaults by non-empty one