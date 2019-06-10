% this function takes a samples x roi binary activation state matrix and a
% binary indicator vector that specifies the indices at which the laser was
% activated. returns a struct containing the mean probability of being
% active during each laser epoch
function [act] = compare_laser_synchrony_pre_post(actStateMatrix, laserIndicator)

% get active and inactive segments
segs.active = activeSegmentsSE(~~laserIndicator);
segs.active = segs.active{1};
segs.inactive = activeSegmentsSE(~laserIndicator);
segs.inactive = segs.inactive{1};

c = nchoosek(1:size(actStateMatrix,2),2);


act.post = nan(size(segs.active,1),size(c,1));
act.pre = nan(size(segs.inactive,1),size(c,1));
% in each segment, get average activity of average for each MSN
for s = 1:min(size(segs.active,1))
    
    curr_sample_post = actStateMatrix(segs.active(s,1):segs.active(s,2),c(:,1)) & ...
        actStateMatrix(segs.active(s,1):segs.active(s,2),c(:,2));
    
    act.post(s,:) = mean(curr_sample_post,1);
end

for s=1:size(segs.inactive,1)
   
    curr_sample_pre = actStateMatrix(segs.inactive(s,1):segs.inactive(s,2),c(:,1)) & ...
        actStateMatrix(segs.inactive(s,1):segs.inactive(s,2),c(:,2));
     act.pre(s,:) = mean(curr_sample_pre,1);
end

assert(~any(isnan(act.pre(:))) && ~any(isnan(act.post(:))),'nan values in laser activity');
end