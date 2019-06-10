function [index] = isInRegion(segmentsAll, segments)
    segmentStarts = segments(:,1);
    segmentEnds = segments(:,2);
    index = [];
    for seg=1:size(segmentsAll,1)
        currSegStart = segmentsAll(seg,1);
        if any(currSegStart >= segmentStarts & currSegStart <= segmentEnds)
            index = cat(1,index,seg);
        end
    end
end