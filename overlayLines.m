function ax = overlayLines(ax, Lines)
hold(ax,'on');
for i=1:numel(Lines)
    line(ax,Lines(i).XData, Lines(i).YData,'Color','r');
end
hold(ax,'off');
end