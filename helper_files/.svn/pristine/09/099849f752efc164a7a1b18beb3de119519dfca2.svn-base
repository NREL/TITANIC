% function [u,Ti] = IEC61400_turbulence(u,lh)
%
% function to calculate wind turbulence according to IEC 61400-1 (1999)
%
% written by Andy Clifton, October 2010.

function [u,Ti] = IEC61400_turbulence(u,class)

switch lower(class)
    case {'a'}
        I15 = 0.16;
    case {'b'}
        I15 = 0.14;
end

% get the turbulence
sigmau = I15.*(0.75.*u+5.6);
Ti = 100.* sigmau./u;