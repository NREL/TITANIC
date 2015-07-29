% function [u,v] = SubWindComponents(U,theta)
%
% Convert a wind speed and direction into meteorological u and v
% components, following the example given at
% http://mst.nerc.ac.uk/wind_vect_convs.html
%
% u is the component towards east (i.e. +ve values indicate westerlies)
% v is the component towards north (i.e. +ve values indicate southerlies)

function [u,v] = SubWindComponents(U,theta)

% get the component of the wind towards east
u(1,:) = - abs(U).* sin((pi./180).*theta);

% get the component of the wind towards north
v(1,:) = - abs(U).* cos((pi./180).*theta);