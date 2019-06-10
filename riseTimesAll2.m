function [rt] = riseTimesAll2(mouseNum, pctileLo, pctileHi)
    suffixList = mouseSuffix(mouseNum);
    allMouseData = loadMouse(suffixList);
    allMouseData = addSpeedInfo(allMouseData, pctileLo, pctileHi);
    numSessions = numel(suffixList);
    
    rt = struct('msn',[],...
                'chi',[],...
                'fsi',[],...
                'msnlo',[],...
                 'msnhi',[],...
                 'fsilo',[],...
                 'fsihi',[],...
                 'chilo',[],...
                 'chihi',[]...
    );
    ps = rt;
    for mouse=1:numSessions
        currMouse = allMouseData(mouse);
        
        %% Mean duration of active region for cholinergics and MSNs
        traces = allFluor(currMouse);
        active = allActive(currMouse);
        [~, segmentsCHI, ps(mouse).chi] = peakFormReduxRiseTimes(traces.chi,active.chi);
        [~, segmentsMSN, ps(mouse).msn] = peakFormReduxRiseTimes(traces.msn,active.msn);
        [~, segmentsFSI, ps(mouse).fsi] = peakFormReduxRiseTimes(traces.fsi,active.fsi);
        
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
            rt(mouse).(fnames{f}) = riseTimeFromShape(ps(mouse).(fnames{f}),currMouse.dt);
        end
        
    end
end