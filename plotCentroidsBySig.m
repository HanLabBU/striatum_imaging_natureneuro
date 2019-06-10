function plotCentroidsBySig(centroid,segID, colorwheel)
%set radius of ROIs
radius = 6;

ids = unique(segID);
no_ids = numel(ids);
% colorwheel = {[0 0 0],[1 .5 0],[1 0 0],[1 1 0]}; %(black, orange, red, yellow), corresponding to none, combo, rotation, speed
if nargin < 3
    colorwheel = {[.5 .5 .5],[0 0 1],[0 0 0],[1 0 0]}; %(grey blue black red), corresponding to none, combo, rotation, speed
end
figure
for n=1:no_ids
    scatter(centroid(segID == ids(n),1), centroid(segID == ids(n),2),...
        (radius-1)^2,'MarkerFaceColor',colorwheel{n},'MarkerEdgeColor',[.3 .3 .3]);
    hold on;
end
set(gca,'Visible','off')
end