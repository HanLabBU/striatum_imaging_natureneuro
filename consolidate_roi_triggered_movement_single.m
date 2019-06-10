function [b, labels] = consolidate_roi_triggered_movement_single(roi)

radius = 50;

%now construct bar graph, establishing radius. Should b3e 0.5 ssecond
%increments, right side inclusive
taxis = (-radius:radius)*0.0469;
inds{1} = find(taxis == 0);
inds{2} = find(taxis > 0 & taxis <= .5);
inds{3} = find(taxis > 0.5 & taxis <= 1);
inds{4} = find(taxis > 1 & taxis <= 1.5);
inds{5} = find(taxis > 1.5 & taxis <= 2);


% concatenate labels for msns, as we will concatenate rois
labels.pos = roi.pos.labels;
labels.neg = roi.neg.labels;
b.pos = cell(0);
b.neg = cell(0);

% for each time bin
for i=1:length(inds)
    % store time indices and all rois for this time bin
    b.pos{i} = roi.pos.vals(inds{i},:);
    b.neg{i} = roi.neg.vals(inds{i},:);

end

%% construct table
% for each cell time
fnames = fieldnames(b);
for f=1:numel(fnames)
    % for each cell, divide all values by the mean value in frame 1, and
    % subtract 1
    b.(fnames{f}) = cellfun(@(x) nanmean(x,1),b.(fnames{f}),'UniformOutput',false);
    b.(fnames{f})= cellfun(@(x) x/abs(nanmean(b.(fnames{f}){1}))-1,b.(fnames{f}),'uniformoutput',false);
end


end