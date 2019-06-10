function mousedata = loadAndFormatPreMouseDataSpeedOnly(metadata)
%load movement and laser data
load(sprintf('processedData/movementDataLaser/movement_data_%s.mat',metadata.suffix))
load(sprintf('processedData/movementDataLaser/laser_data_%s.mat',metadata.suffix));
% interpolate movement data
[~, ~, dxdy, rotation] = getMovementLaser3(data); % decode movement from movement data
taxis = cumsum(info.Dt);

dt = 0.0469;
taxis_interp = 0:dt:taxis(end);
% interpolate speed
dx = dxdy(:,1);
dy = dxdy(:,2);

prelim_speed = sqrt(dy.^2+dx.^2);
dy(abs(prelim_speed) > 100) = nan;
dx(abs(prelim_speed) > 100) = nan;

dx_interp = interpolateStriatum(taxis(~isnan(dx)),dx(~isnan(dx)), taxis_interp);
dy_interp = interpolateStriatum(taxis(~isnan(dy)),dy(~isnan(dy)), taxis_interp);

speed_interp = sqrt(dx_interp.^2+dy_interp.^2);
laser_indices_2 = convert_laser_2_binary(laser.frameOn,laser.frameOff,taxis,taxis_interp);
rotation(abs(rotation) > 15) = nan;
rotation = rotation.*info.Dt;
if any(abs(rotation) > pi)
    disp(sum(abs(rotation) > pi));
end
% %https://stackoverflow.com/questions/2708476/rotation-interpolation, Paul
%Colby answer
dxrot = cos(rotation);
dyrot = sin(rotation);
dxrot_interp = interpolateStriatum(taxis(~isnan(dxrot)), dxrot(~isnan(dxrot)), taxis_interp);
dyrot_interp = interpolateStriatum(taxis(~isnan(dyrot)), dyrot(~isnan(dyrot)), taxis_interp);
rotation_interp  = atan2(dyrot_interp, dxrot_interp)/dt;

inds = find(taxis_interp > 5);
if inds(1) <= 100
    fprintf('bad index');
end
mousedata.rotation = rotation_interp(inds);
mousedata.speed = speed_interp(inds);
mousedata.laser = laser_indices_2(inds);
mousedata.t = taxis_interp(inds); 
mousedata.dt = dt;
end
