% function epsilon = SubDissipationRateDirect(nu, U, u_p, v_p, w_p, t)
%
% Calculate direct dissipation of turbulence after Oncley et al. in 
% "Surface-Layer Fluxes, Profiles and Tuebulence Measurements 
% over Uniform Terrain under Near-Neutral Conditions",
% J. of the Atmospheric Sciences, 53(7) 1996 
% using eqn 26 in that paper.

function epsilon = SubDissipationRateDirect(nu, U, u_p, v_p, w_p, t)

RHS = 1+ mean(u_p.^2)/U.^2 + ...
    2.*((mean(v_p.^2)+mean(w_p.^2))/U.^2);

epsilon = (15 * nu /U.^2) *mean((diff(u_p)./diff(t)).^2) * (1/RHS);

