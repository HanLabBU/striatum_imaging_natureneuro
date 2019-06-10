function rasterPlot(taxis, activityMatrix, markSize)
    if nargin < 3
        markSize = 2;
    end
    for roi = 1:size(activityMatrix,2)
        activePoints = taxis(logical(activityMatrix(:,roi)));
        plot(activePoints,roi*ones(size(activePoints)),'.k','MarkerSize',markSize);
        hold on;
    end
    hold off;
    ylim([0 size(activityMatrix,2)])
end