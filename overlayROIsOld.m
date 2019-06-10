function ax = overlayROIsOld(ax, R)
for i=1:numel(R)
    
    if ~isprop(R(i),'isChI') || ~isprop(R(i),'isPVI') || (~R(i).isChI && ~R(i).isPVI)
        plot(ax,R(i).BoundaryTrace.x,R(i).BoundaryTrace.y,'r');
        hold(ax,'on');
    else
        plot(ax,R(i).BoundaryTrace.x,R(i).BoundaryTrace.y,'g');
        hold on
    end
end
hold(ax,'off');
end