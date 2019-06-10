function hiSegAmps = peakAmpsInSeg(amps, segments, hiSegments)
    numRois = numel(amps);
    hiSegAmps = cell(numRois, 1);
    for roi=1:numRois
        currAmps = amps{roi};
        currSegments = segments{roi};
        [index] = isInHiMvmtRegion(currSegments, hiSegments);
        hiSegAmps{roi} = currAmps(index);
    end
end

function [index] = isInHiMvmtRegion(segments, hiSegments)
    hiSegmentStarts = hiSegments(:,1);
    hiSegmentEnds = hiSegments(:,2);
    index = [];
    for seg=1:size(segments,1)
        currSegStart = segments(seg,1);
        if any(currSegStart >= hiSegmentStarts & currSegStart <= hiSegmentEnds)
            index = cat(1,index,seg);
        end
    end
end