function mouseData = loadAndFormatPreInfusion2(suffix)
load(['roi_pre_' suffix '.mat'])
% load mouse data
load(['movement_data_' suffix '.mat']);
load(['timestamps_seconds_' suffix '.mat']);
startind= find(t == 0,1,'last');
stepSize = .0469;
[~, ~, dxdy, rotation] = getMovement(data);
origTime = cumsum(info.Dt);
[preRois, cholIndices] = loadPreRoiData(suffix);
fsiIndices = find([R.isPVI]);
firstTenMinutes = find(origTime < 600);
dt = stepSize;
rawtraces = zeros(size([preRois.Trace]));
rawtraces = rawtraces(startind:end,:);
% smTraces = zeros(size([preRois.Trace]));
for i=1:numel(preRois)
    rawtraces(:,i) = preRois(i).Trace(startind:end);
%     smTraces(:,i) = preRois(i).TraceType.small;
end


origTime = origTime(firstTenMinutes);
rawtraces = rawtraces(firstTenMinutes,:);
% smTraces = smTraces(firstTenMinutes,:);

dy = dxdy(firstTenMinutes,2);
dx = dxdy(firstTenMinutes,1);

%get rid of indices with ridiculous velocity values
% bigInds = (dy > 10) | (dx > 10);
% dy(bigInds) = nan;
% dx(bigInds) = nan;
% rotation(bigInds) = nan;
% assert(all(isnan(rotation) | abs(rotation) < 2*pi),'big rotation values');
mouseData.cholIndices = cholIndices;
mouseData.fsiIndices = fsiIndices;
%load movement data
mouseData.dt = stepSize;
mouseData.tvals = [0:stepSize:12792*stepSize]';

prelim_speed = sqrt(dy.^2+dx.^2);
dy(abs(prelim_speed) > 100) = nan;
dx(abs(prelim_speed) > 100) = nan;

% interpolate and get binaryActivityTrace
dyInterp = interpolateStriatum(origTime(~isnan(dy)), dy(~isnan(dy)), mouseData.tvals);
dxInterp = interpolateStriatum(origTime(~isnan(dx)), dx(~isnan(dx)), mouseData.tvals);

movementInterp = sqrt(dyInterp.^2+dxInterp.^2);
rel_direction_interp = atan2(dyInterp, dxInterp);

%redo the rotation here %https://stackoverflow.com/questions/2708476/rotation-interpolation, Paul
%Colby answer
rotation(abs(rotation) > 15) = nan;
rotation = rotation(firstTenMinutes).*info.Dt(firstTenMinutes);

if any(abs(rotation) > pi)
   disp(sum(abs(rotation) > pi));
end
   disp(sum(abs(diff(rotation)) > pi));

rot_x = cos(rotation);
rot_y = sin(rotation);
rot_x_interp = interpolateStriatum(origTime(~isnan(rot_x)), rot_x(~isnan(rot_x)), mouseData.tvals);
rot_y_interp = interpolateStriatum(origTime(~isnan(rot_y)), rot_y(~isnan(rot_y)), mouseData.tvals);

rotationInterp = atan2(rot_y_interp, rot_x_interp)/stepSize;


% keep this step? Is this giving us more information? Don't think it's
% right
% phiInterp = wrapTo2Pi(rel_direction_interp+[pi/2; rotationInterp(1:end-1)]);
phiInterp = rel_direction_interp;

rawtraces = interpolateStriatum(origTime,rawtraces,mouseData.tvals);
% smTraces = interpolateStriatum(origTime, smTraces, mouseData.tvals);
% make sure that baseline fluorescence value is okay
% mouseData.tracesRaw = rawtraces./repmat(mean(rawtraces),size(rawtraces,1),1);
mouseData.f = rawtraces;
% mouseData.sm = smTraces;
mouseData.dff = bsxfun(@rdivide, bsxfun(@minus,rawtraces, nanmean(rawtraces)), nanmean(rawtraces));

mouseData.dyInterp = dyInterp;
mouseData.dxInterp = dxInterp;

mouseData.phi = phiInterp/stepSize;
mouseData.rot = rotationInterp;

mouseData.dydt = movementInterp;

mouseData.dydt(1:100) = nan(100,1);
mouseData.dyInterp(1:100) = nan(100,1);
mouseData.dxInterp(1:100) = nan(100,1);
mouseData.phi(1:100) = nan(100,1);
mouseData.rot(1:100) = nan(100,1);

mouseData.centroids = cat(1, preRois.Centroid);
mouseData.boundary = cat(1, preRois.boundaryTrace);
fprintf('done with %s\n',suffix);
end

function [preRois, cholIndices] = loadPreRoiData(suffix)
    load(['roi_pre_' suffix '.mat'])
    cholIndices = find([R.isChI]);
    preRois = R;
    
end