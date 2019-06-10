% this function takes a samples x roi binary activation state matrix and a
% binary indicator vector that specifies the indices at which the laser was
% activated. returns a struct containing the mean probability of being
% active during each laser epoch
function act = compare_laser_synchrony2(actStateMatrix, laserIndicator)

% get active and inactive segments
segs.active = activeSegmentsSE(~~laserIndicator);
segs.active = segs.active{1};
segs.inactive = activeSegmentsSE(~laserIndicator);
segs.inactive = segs.inactive{1};

c = nchoosek(1:size(actStateMatrix,2),2);

act.active = nan(size(segs.active,1),size(c,1));
act.inactive = nan(size(segs.inactive,1),size(c,1));


% in each segment, get average activity of average for each MSN
fields = fieldnames(segs);
for f=1:numel(fields)
    for s = 1:size(segs.(fields{f}),1)
        curr_sample = actStateMatrix(segs.(fields{f})(s,1):segs.(fields{f})(s,2),c(:,1)) & ...
            actStateMatrix(segs.(fields{f})(s,1):segs.(fields{f})(s,2),c(:,2));
        act.(fields{f})(s,:) = mean(curr_sample,1);
    end
end
assert(~any(isnan(act.active(:))) && ~any(isnan(act.inactive(:))),'nan values in laser activity');
end