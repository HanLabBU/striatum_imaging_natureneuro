% this function takes a samples x roi binary activation state matrix and a
% binary indicator vector that specifies the indices at which the laser was
% activated. returns a struct containing the mean probability of being
% active during each laser epoch
function act = compare_laser_synchrony5(actStateMatrix, laserIndicator,ninds)

% get active and inactive segments
segs.active = activeSegmentsSE(~~laserIndicator);
segs.active = segs.active{1};
segs.inactive = activeSegmentsSE(~laserIndicator);
segs.inactive = segs.inactive{1};

c = nchoosek(1:size(actStateMatrix,2),2);

baseline = 100;
fin = 100;

act.active = nan(size(segs.active,1),ninds+baseline+fin,size(c,1));
act.inactive = nan(size(segs.inactive,1),ninds+baseline+fin,size(c,1));


% in each segment, get average activity of average for each MSN
fields = fieldnames(segs);
for f=1:numel(fields)
    for s = 1:size(segs.(fields{f}),1)
        seg_start = segs.(fields{f})(s,1)-baseline;
        seg_end = segs.(fields{f})(s,1)+ninds+fin-1;
        
        if seg_start <= 0 || seg_end > size(actStateMatrix,1)
            act.(fields{f})(s,:,:) = nan;
        else
            curr_sample = actStateMatrix(seg_start:seg_end,c(:,1)) & ...
                actStateMatrix(seg_start:seg_end,c(:,2));
            act.(fields{f})(s,:,:) = curr_sample;
        
        end
    end
end
end