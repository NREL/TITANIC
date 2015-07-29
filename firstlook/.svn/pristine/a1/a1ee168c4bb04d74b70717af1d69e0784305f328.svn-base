function [u_p,v_p,w_p,T_p] = SubSonicTurbulenceTimeseries(u,v,w,T,t,...
    DETRENDING_ORDER)

% reshape the inputs
u = reshape(u,[],1);
v = reshape(v,[],1);
w = reshape(w,[],1);
T = reshape(T,[],1);
t = reshape(t,[],1);

% remove trends in rotated data
u_p = u - findtrend(t,u,DETRENDING_ORDER);
v_p = v - findtrend(t,v,DETRENDING_ORDER);
w_p = w - findtrend(t,w,DETRENDING_ORDER);
T_p = T - findtrend(t,T,DETRENDING_ORDER);

function ytrend = findtrend(x,y,DETRENDING_ORDER)
p = polyfit(x,y,DETRENDING_ORDER);
ytrend = polyval(p,x);