% function epsilon = SubDissipationRateStructureFunction(U_ref,daqfreq,u_p)
%
% Calculate the dissipation rate using the structure function.
% Structure function lags are limited to the range 0.5 to 5 Hz.
%
% This function is based on a process described in Stull, p. 


function [epsilon_out,lag_out,cv2_out,cv2m_out,DVV_out,...
	cT2_out,cT2m_out,DTT_out] = ...
	SubDissipationRateStructureFunction(U_ref,daqfreq,u_p,T_p)

%%
u_p = reshape(u_p,1,[]);
T_p = reshape(T_p,1,[]);

% first calculate the structure function
n = numel(u_p);
lag = U_ref*(1/daqfreq)*(0:(numel(u_p)-1));

% Loop through lags corresponding to the range of 0.5 to 5 hz
DVV = NaN.*lag;
DTT = DVV;
L =ceil(1/(5/daqfreq)):ceil(1/(0.5/daqfreq));
for li = 1:numel(L)
    uplagged = [u_p NaN*ones(1,L(li)-1)];
	Tplagged = [T_p NaN*ones(1,L(li)-1)];
    u_p_zero = [NaN*ones(1,L(li)-1) u_p];
	T_p_zero = [NaN*ones(1,L(li)-1) T_p];
    DVV(L(li)) = nanmean((uplagged - u_p_zero).^2);
	DTT(L(li)) = nanmean((Tplagged - T_p_zero).^2);
end

%% structure function parameter for velocity
cv2 = (DVV./(lag.^(2/3)));
cv2m = median(cv2(~isnan(cv2)));

%% dissipation rate
epsilon = (cv2m/2)^(3/2);

%% structure function parameter for temperature
cT2 = (DTT./(lag.^(2/3)));
cT2m = median(cT2(~isnan(cT2)));

%% data to export
lag_out = lag(L);
cv2_out = cv2(L);
cv2m_out = cv2m;
DVV_out = DVV(L);
cT2_out = cT2(L);
cT2m_out = cT2m;
DTT_out = DTT(L);
epsilon_out = epsilon;