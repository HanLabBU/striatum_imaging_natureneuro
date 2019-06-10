function roiSegments = getSegmentsInRegion(peakShapes, peakSegments, desiredSegments)
    roiSegments = cell(numel(peakShapes),1);
    for roi=1:numel(peakShapes)
        desiredInds = isInRegion(peakSegments{roi}, desiredSegments);
        roiSegments{roi} = peakShapes{roi}(desiredInds);
    end
end