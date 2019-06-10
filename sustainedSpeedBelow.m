function segments = sustainedSpeedBelow(speed, cutoffPct, minInds)
    isBelow = speed < cutoffPct;
    segments = activeSegments(isBelow(:));
    segments = segments{1};
    sufficientLength = find(diff(segments,[],2)+1 > minInds);
    segments = segments(sufficientLength,:);
end