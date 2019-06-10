
function aucCell = aucFromShape(peakShapes,dt)
    aucCell = cell(numel(peakShapes),1);
    for roi=1:numel(peakShapes)
        currShapes = peakShapes{roi};
        currAUCVals = zeros(numel(currShapes),1);
        for shapeNo=1:numel(currShapes)
            shape = currShapes{shapeNo};
            currAUCVals(shapeNo) = nansum(shape*dt);
        end
        aucCell{roi} = currAUCVals;
    end
end
