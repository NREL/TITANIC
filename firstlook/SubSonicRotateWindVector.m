function [u_rot,v_rot,w_rot,T_rot] = SubSonicRotateWindVector(u,v,w,Temp,...
    ROTATION_METHOD)


%% organise the data
u = reshape(u,[],1);
v = reshape(v,[],1);
w = reshape(w,[],1);
vel_raw = [u v w];
T_raw = reshape(Temp,[],1);

%% %%%%%%%
% ROTATION
%%%%%%%%%%

switch ROTATION_METHOD
    case 'none'
        % then we don't rotate
        vel_fixed = vel_raw;        
    case 'pitchnyaw'
        % start with yaw correction
        denom = sqrt(mean(u).^2 + mean(v).^2);
        uelement = mean(u) ./ denom;
        velement = mean(v) ./ denom;
        % get the yaw matrix
        A_yaw =[uelement velement 0;...
            -velement uelement 0;...
            0 0 1];
        % apply this and give it a new name
        vel_rot = A_yaw * vel_raw';
        vel_rot = vel_rot';
        
        % now try pitch correction
        denom = sqrt(mean(vel_rot(:,1)).^2 + mean(vel_rot(:,3)).^2);
        uelement = mean(vel_rot(:,1)) ./ denom;
        welement = mean(vel_rot(:,3)) ./ denom;
        % get the pitch matrix
        A_pitch =[uelement 0 welement;...
            0 1 0;...
            -welement 0 uelement];
        % apply this and give it a new name
        vel_rp = A_pitch * vel_rot';
        vel_fixed = vel_rp';        
end

% temperature data are never corrected
T_rot = T_raw;

% get instant values
u_rot = vel_fixed(:,1);
v_rot = vel_fixed(:,2);
w_rot = vel_fixed(:,3);
