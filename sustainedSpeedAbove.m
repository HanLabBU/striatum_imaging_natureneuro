function segments = sustainedSpeedAbove(speed, cutoffPct, minInds)
     isAbove = speed > cutoffPct;
    segments = activeSegments(isAbove(:));
    segments = segments{1};
    sufficientLength = find(diff(segments,[],2)+1 > minInds);
    segments = segments(sufficientLength,:);
end