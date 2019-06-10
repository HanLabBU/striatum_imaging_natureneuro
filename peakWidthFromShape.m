
function pwCell = peakWidthFromShape(peakShapes,dt)
    pwCell = cell(numel(peakShapes),1);
    for roi=1:numel(peakShapes)
        currShapes = peakShapes{roi};
        currPWVals = zeros(numel(currShapes),1);
        for shapeNo=1:numel(currShapes)
            shape = currShapes{shapeNo};
            currPWVals(shapeNo) = length(shape)*dt;
        end
        pwCell{roi} = currPWVals;
    end
end
