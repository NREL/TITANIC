% function rho_air = get_rho_air(P,T,RH)
%
% This function calculates the density of air given the
% pressure, temperature and humidity. If the humidity is
% zero, it's effect will be ignored.
% The function requires the following inputs;
%
% - P           Atmospheric total pressure [Pa]
% - T           local temperature [K]
%
% the following input is optional
% - RH          local relative humidity e_w / e_w,saturation [%]
%
% The following are asssumed to be constants;
% - R_air       Air gas constant, 287 [J/(kg.K)]
% - R_H20       Water gas constant

function rho_air = get_rho_air(varargin)

P = cell2mat(varargin(1));
T = cell2mat(varargin(2));

% define our model constants
R_air = 287;
R_H2O = 461;

if T <=0
      disp('*** Please give temperature in K! ***')
      return
end

% now deal with the data
if nargin == 2|3
      disp('...calculating density of dry air')
      % get the density of dry air from Eqn of State
      rho_dry = P ./ (R_air * T);          % we'll use this as our control / check value
      rho_air = rho_dry;                  % this is valid until corrected for moisture
      if length(P) > 1  | length(T)  > 1 
            % supress results display
      else
            % display the result to screen
            disp(['- dry air density is ' num2str(rho_dry,4) '.'])
      end
end
if nargin == 3  % given RH
      RH = cell2mat(varargin(3));
      disp('...calculating density of moist air')

      % get the saturation vapour pressure at this temperature; for
      % sub-zero temperatures, we'll assume it's measured over water
      % (checked with Chris Fox at Rotronics UK)
      e_w =get_H2O_vap_press(T,RH);

      % now calculate the density of the mixture;
      rho_moist = (P./(R_air *T)) .* (1-(e_w./P) *(1-(R_air/R_H2O)));

      % calaulate the specific humidity too
      q = (R_air / R_H2O) * e_w ./ (P -e_w*(1-(R_air/R_H2O)));

      if length(P) > 1  | length(T)  > 1  | length(RH) > 1
            % supress results display
      else

            % display the result to screen;
            disp(['- moist air density is ' num2str(rho_moist,4) ' kg/m^3.'])
            disp(['- vapour pressure is ' num2str(e_w,4) ' Pa.'])
            disp(['- specific humidity is ' num2str(q,4) ' kg/kg.'])
            disp(['- decrease in density is ' num2str(100*(1-(rho_moist/rho_dry)),4) '%.'])

            % quality check
            if rho_moist < rho_dry
                  rho_air = rho_moist;
            else
                  disp('...possibly an error in the calculation; please make sure RH < 100%');
                  disp('...returning density of dry air.')
                  rho_air = rho_dry;
            end
      end
end
if nargin ~= 2 & nargin ~= 3
      disp('...to calculate density, need at least 2 inputs, P,T and can use RH as well')
end
% function ends