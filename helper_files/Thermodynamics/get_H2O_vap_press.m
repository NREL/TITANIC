% function e_w = get_H2O_vap_press(T,RH)
%
% this function returns the vapour pressure from a Rotronic Hygroclip at a
% given temperature.
%
% The function requires the following inputs;
% - T               Temperature [K]
% - RH              Relative humidity [%]
%
% Chris Fox at Rotronic AG says that the instrument is calibrated
% over water, and uses WMO formulations.
%
% According to http://cires.colorado.edu/~voemel/vp.html, WMO formulation is  
% (Goff, 1957): 
% Log10 pw =  10.79574 (1-273.16/T)                                 [2] 
%                     - 5.02800 Log10(T/273.16) 
%                     + 1.50475 10-4 (1 - 10(-8.2969*(T/273.16-1))) 
%                     + 0.42873 10-3 (10(+4.76955*(1-273.16/T)) - 1) 
%                     + 0.78614 
% with T in [K] and pw in [hPa]

function e_w = get_H2O_vap_press(T,RH)

% first calculate the saturation pressure
log_10_e_w_star = 10.79574 * (1 - ( 273.16 ./ T )) - 5.02800 * log10( T ./ 273.16 ) ...
    + 1.50475 * (10^-4) * (1 - 10 .^ ( -8.2969 * (( T ./ 273.16 ) - 1 )))...
    + 0.42873 * (10^-3) * (10 .^ ( +4.76955*( 1- ( 273.16 ./ T )) ) - 1 )...
    + 0.78614;
e_w_star = 10 .^ log_10_e_w_star;

% and now calculate the actual vapour pressure
e_w_hPa = e_w_star .* (RH/100);

% convert to SI units...
e_w = 100 * e_w_hPa;

% function ends