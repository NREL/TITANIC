function [Mean,Instant] = SubFlowFromUxUyUz(u,v,w,STYPE,BOOM_NORTH)
% -------------
% VELOCITY DATA
% -------------
% get the mean horizontal speed, i.e. distance over time
Mean.HorizSpeed = (nanmean(u)^2+nanmean(v)^2).^(0.5);

% get the total speed
Mean.TotalSpeed = (nanmean(u)^2+nanmean(v)^2+nanmean(w)^2).^(0.5);

% get the cup-equivalent speed, which is the total run through the domain
Instant.CupEqHorizSpeed = (u.^2+v.^2).^(0.5);
Mean.CupEqHorizSpeed = nanmean(Instant.CupEqHorizSpeed);
Mean.CupEqHorizTi = 100* nanstd(Instant.CupEqHorizSpeed)/Mean.CupEqHorizSpeed;

% ------------
% INFLOW ANGLE
% ------------
Instant.InflowAngle = atand(w./Instant.CupEqHorizSpeed);
Mean.InflowAngle = atand(nanmean(w)/Mean.HorizSpeed);

% ---------------
% FLOW DIRECTIONS
% ---------------

% flow directions vary by sonic type. See
% http://www.eol.ucar.edu/instrumentation/sounding/isfs/isff-support-center
% /how-tos/wind-direction-quick-reference for details...

DperR = 180/pi;
RperD = pi/180;
switch STYPE
    case {'CSAT3';'ATIK'}
        % Campbell CSAT3 Sonic.
        % +Usonic represents wind into the array from the un-obstructed
        % direction, parallel to the support boom. 
        % +Vsonic is wind from the West to the East (relative to the sonic, if the open side is North)
        % +Wsonic is from the ground up.
        % See image on page 2 of http://www.campbellsci.com/documents/product-brochures/b_csat3.pdf
        Usonic = nanmean(u);
        Vsonic = nanmean(v);
        % get the azimuth
        Vaz = SubWindWrapDir(BOOM_NORTH + 180 -90);        
        
        % get the meteorological direction
        % Dirmet is the direction with respect to true north,
        % (0=north,90=east,180=south,270=west) that the wind is coming
        % from.
        % A positive Umet component represents wind blowing to the East.
        % +Vmet is wind to the North. This is right handed with respect to
        % an upward +Wmet.
        Instant.theta_m = SubWindWrapDir((atan2(-u,-v) * DperR) + Vaz);
        Mean.theta_m = SubWindWrapDir((atan2(-Usonic,-Vsonic) * DperR) + Vaz);
        
        % get the angle relative to the sonic block. 0 is the unobstructed direction
        Instant.theta_s = SubWindWrapDir(Instant.theta_m + BOOM_NORTH);
        Mean.theta_s = SubWindWrapDir(Mean.theta_m + BOOM_NORTH);
        % we should probably check later for dat coming from 150-210
        
        % Horizontal Wind Rotation from Sonic to Meteorological coordinates
        Mean.met_u =  Usonic * cos(Vaz*RperD) + Vsonic * sin(Vaz*RperD);
        Mean.met_v = -Usonic * sin(Vaz*RperD) + Vsonic * cos(Vaz*RperD);
    case {'GENERIC'}
        % Data of unknown origin. Assume that output
        % data follows the meteorological convention.

end
