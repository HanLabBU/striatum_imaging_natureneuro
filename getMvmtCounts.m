function counts = getMvmtCounts(mouseno)

suffix = mouseSuffix(mouseno);
for m=1:numel(suffix)
    mousedata = loadMouse(suffix(m));
    counts(m).isCHI = mousedata.isCHI;
    % get movement onset
    peaks = findPeaksManual(mousedata.speed, mousedata.dt);
    counts(m).onset = length(peaks);
    % get peak velocity events
    peaks = findVelocityPeaks(mousedata.speed, 55);
    counts(m).vmax = length(peaks);
    % get movement offset events
    peaks = findValleysManual(mousedata.speed, mousedata.dt);
    counts(m).offset = length(peaks);
    
    mousedata = addSpeedInfo(mousedata,1,5);
    counts(m).hispd = size(mousedata.hiSpdSustainSegs,1);
    counts(m).lospd = size(mousedata.loSpdSustainSegs,1);
end

end