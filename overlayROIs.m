function ax = overlayROIs(ax, R)
for i=1:numel(R)
    
    if (~isfield(R,'isCHI') || ~isfield(R,'isFSI')) || (~R(i).isCHI && ~R(i).isFSI)
        plot(ax,R(i).BoundaryTrace.x,R(i).BoundaryTrace.y,'r');
        hold(ax,'on');
    else
        plot(ax,R(i).BoundaryTrace.x,R(i).BoundaryTrace.y,'g');
        hold on
    end
end
hold(ax,'off');
end