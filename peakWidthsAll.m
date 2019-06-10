function [pw] = peakWidthsAll(mouseNum, pctileLo, pctileHi)
    suffixList = mouseSuffix(mouseNum);
    allMouseData = loadMouse(suffixList);
    allMouseData = addSpeedInfo(allMouseData, pctileLo, pctileHi);
    numSessions = numel(suffixList);
    
    ps = struct('msn',[],...
                'chi',[],...
                'fsi',[],...
                'msnlo',[],...
                 'msnhi',[],...
                 'fsilo',[],...
                 'fsihi',[],...
                 'chilo',[],...
                 'chihi',[]...
    );
    pw = ps;
    for mouse=1:numSessions
        currMouse = allMouseData(mouse);
        
        %% Mean duration of active region for cholinergics and MSNs
        traces = allFluor(currMouse);
        active = allActive(currMouse);
        [ps(mouse).chi, ~, segmentsCHI] = peakFormRedux(traces.chi,active.chi);
        [ps(mouse).msn, ~, segmentsMSN] = peakFormRedux(traces.msn,active.msn);
        [ps(mouse).fsi, ~, segmentsFSI] = peakFormRedux(traces.fsi,active.fsi);
        
        loSegments = currMouse.loSpdSustainSegs;
        ps(mouse).chilo = getSegmentsInRegion(ps(mouse).chi, segmentsCHI, loSegments);
        ps(mouse).msnlo = getSegmentsInRegion(ps(mouse).msn, segmentsMSN, loSegments);
        ps(mouse).fsilo = getSegmentsInRegion(ps(mouse).fsi, segmentsFSI, loSegments);
        
        hiSegments = currMouse.hiSpdSustainSegs;
        ps(mouse).chihi = getSegmentsInRegion(ps(mouse).chi, segmentsCHI, hiSegments);
        ps(mouse).msnhi = getSegmentsInRegion(ps(mouse).msn, segmentsMSN, hiSegments);
        ps(mouse).fsihi = getSegmentsInRegion(ps(mouse).fsi, segmentsFSI, hiSegments);
        
        fnames = fieldnames(ps);
        for f=1:numel(fnames)
            pw(mouse).(fnames{f}) = peakWidthFromShape(ps(mouse).(fnames{f}),currMouse.dt);
        end
        
    end
end