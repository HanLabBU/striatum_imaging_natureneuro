% this function takes a samples x roi binary activation state matrix and a
% binary indicator vector that specifies the indices at which the laser was
% activated. returns a struct containing the mean probability of being
% active during each laser epoch
function act = compare_zerocrossings(rotation, laserIndicator)

% get active and inactive segments
segs.active = activeSegmentsSE(~~laserIndicator(:));
segs.active = segs.active{1};
segs.inactive = activeSegmentsSE(~laserIndicator(:));
segs.inactive = segs.inactive{1};

act.active = nan(size(segs.active,1),1);
act.inactive = nan(size(segs.inactive,1),1);

% zerocrossings = find_zerocrossings(rotation);
zerocrossings = find_zerocrossings_threshold(rotation);

% in each segment, get average activity of average for each MSN
for s = 1:size(segs.active,1)
    act.active(s) = nanmean(zerocrossings(segs.active(s,1):segs.active(s,2)));
end

for s = 1:size(segs.inactive,1)
   act.inactive(s) = nanmean(zerocrossings(segs.inactive(s,1):segs.inactive(s,2))); 
end
assert(~any(isnan(act.active)),'nan values in laser activity');
assert(~any(isnan(act.inactive)),'nan values in laser activity');
end