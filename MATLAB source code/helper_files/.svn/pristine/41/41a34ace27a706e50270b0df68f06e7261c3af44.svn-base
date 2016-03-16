% function mu = dynvisc(T)
%
% This function evaluates dynamic viscosity of air at a given temperature.
% This is calculated using Sutherland's 3 term viscosity formulation.
% The impact of pressure is assumed to be minimal.
%
% inputs: temperature in K
% output: viscosity in kg/(m.s)

function mu = dynvisc(T)

% define the reference values we will use
mu_0 = 1.785E-5;
T_0 =293.2;
S_0 = 110;

% check that input temperature is given in kelvin;
if T <=0
    disp('*** Please give temperature in K! ***')
else
    mu = mu_0 .* (T / T_0) .^ (3/2) .* ((T_0 + S_0)./(T + S_0));
end
