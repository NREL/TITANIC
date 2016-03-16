

function sigma_TH = SubWindSDev(u,v,vel)

u = reshape(u,[],1);
v = reshape(v,[],1);
vel = reshape(vel,[],1);

Ux = mean(u./vel);
Uy = mean(v./vel);
if numel(vel) == 1
    epsilon = 0;
    sigma_TH = 0;
else
    epsilon = (1-((Ux)^2+(Uy)^2))^(1/2);
    sigma_TH = asind(epsilon)*(1+0.1547*epsilon^3);
end