function mouseData = loadAndFormatPreInfusion3(metadata)
suffix = metadata.suffix;
% load all mouse data
load(['processedData/rois-laser/rois_w_traces_' suffix '.mat'])
load(['processedData/movementDataLaser/movement_data_' suffix '.mat']);
load(['processedData/timestampslaser/timestamps_seconds_' suffix '.mat']);
load(['processedData/movementDataLaser/laser_data_' suffix '.mat']);


t = t-t(1); % subtract first time point from fluorescence values extracted from timestampslaser

startind= find(t == 0,1,'last'); % find out when the tiffs began to be recorded
stepSize = .0469; % set the dt to be the stepsize
[~, ~, dxdy, rotation] = getMovementLaser3(data); % decode movement from movement data
origTime = cumsum(info.Dt); % get taxis from movement files
cholIndices = find([R.isCHI]); % get cholinergic indices
fsiIndices = find([R.isFSI]); % get FSI indices
fluorinds = startind:length(t); % set the fluorescence indices that we are to use
t = t(fluorinds);

len = min(length(t),size(dxdy,1));
mvmttimeinds = 1:len; % movement time indices are first index to min length
% t = t(1:len);
fluorinds = fluorinds(1:len); % if mvmt time inds shorter, truncate fluorescence indices

rawtraces = zeros(size([R.Trace])); % initialize matrix to store raw traces
rawtraces = rawtraces(fluorinds,:); % truncate rawtraces
for i=1:numel(R)
    rawtraces(:,i) = R(i).Trace(fluorinds);
end

origTime = origTime(mvmttimeinds); % truncate original time axis


assert(length(origTime) == size(rawtraces,1),'Time series are of different lengths');

dy = dxdy(mvmttimeinds,2); % truncate these values to correspond to new length restriction
dx = dxdy(mvmttimeinds,1);
rotation = rotation(mvmttimeinds); %moved this up here. check in other script to make sure that it doesn't affect anything!!!
dt = info.Dt(mvmttimeinds);
rotation(abs(rotation) > 15) = nan;
rotation = rotation.*dt;
if any(rotation > pi)
    disp(rotation(rotation > pi));
end
mouseData.cholIndices = cholIndices;
mouseData.fsiIndices = fsiIndices;

%load movement data
mouseData.dt = stepSize;
mouseData.tvals = [0:stepSize:t(end)]'; % get new t values

% get laser values using new t values
mouseData.laserIndices = convert_laser_2_binary(laser.frameOn,laser.frameOff,origTime,mouseData.tvals);

assert(length(origTime) == length(dy) && length(origTime) == length(dx),'time vector doesnt match movement vector');



prelim_speed = sqrt(dy.^2+dx.^2);
dy(abs(prelim_speed) > 100) = nan;
dx(abs(prelim_speed) > 100) = nan;

% interpolate and get binaryActivityTrace
dyInterp = interpolateStriatum(origTime(~isnan(dy)), dy(~isnan(dy)), mouseData.tvals);
dxInterp = interpolateStriatum(origTime(~isnan(dx)), dx(~isnan(dx)), mouseData.tvals);

movementInterp = sqrt(dyInterp.^2+dxInterp.^2);
rel_direction_interp = atan2(dyInterp, dxInterp);

%https://stackoverflow.com/questions/2708476/rotation-interpolation, Paul
%Colby answer helped
rot_x = cos(rotation);
rot_y = sin(rotation);
rot_x_interp = interpolateStriatum(origTime(~isnan(rot_x)), rot_x(~isnan(rot_x)), mouseData.tvals);
rot_y_interp = interpolateStriatum(origTime(~isnan(rot_y)), rot_y(~isnan(rot_y)), mouseData.tvals);

rotationInterp = atan2(rot_y_interp, rot_x_interp)/stepSize;

    
phiInterp = rel_direction_interp;

rawtraces = interpolateStriatum(origTime,rawtraces,mouseData.tvals);

mouseData.f = rawtraces;
mouseData.dff = bsxfun(@rdivide, bsxfun(@minus,rawtraces, nanmean(rawtraces)), nanmean(rawtraces));

mouseData.dyInterp = dyInterp;
mouseData.dxInterp = dxInterp;

mouseData.phi = phiInterp;
mouseData.rot = rotationInterp;

mouseData.dydt = movementInterp;

mouseData.dydt(1:100) = nan(100,1);
mouseData.dyInterp(1:100) = nan(100,1);
mouseData.dxInterp(1:100) = nan(100,1);
mouseData.phi(1:100) = nan(100,1);
mouseData.rot(1:100) = nan(100,1);

mouseData.centroids = cat(1, R.Centroid);
mouseData.boundary = cat(1, R.BoundaryTrace);

end
