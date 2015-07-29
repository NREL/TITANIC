% function Cp = get_Cp_air(P,T)
% function Cp = get_Cp_air(P,T,RH)
%
% this function calculates the specific heat capacity of air at constant
% pressure.
%
% inputs are
% P         local ambient pressure [Pa]
% T         local temperature [k]
%
% optional input
% RH        local relative humidity [%] (1-100)
%
% output is Cp for dry or mixed air. This function is vectorized.
%
% function written by Andy Clifton, November 2004

function Cp = get_Cp_air(P,T,varargin)

% Take standard value of Cp(dry) as independent of
% temperature.
Cpd = 1005;

switch nargin
      case 2      % only have  P and T as inputs
            Cp = Cpd * ones(size(T));
      case 3      % also have relative humidity available
            RH = cell2mat(varargin(3));
            e_w = get_H2O_vap_press(T,RH);
            q_w = 0.622* e_w ./(P-0.378*e_w);
            Cp = Cpd *(1+0.84*q_w);
end