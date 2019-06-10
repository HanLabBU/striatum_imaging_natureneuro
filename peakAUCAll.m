function [auc] = peakAUCAll(mouseNum, pctileLo, pctileHi)
    suffixList = mouseSuffix(mouseNum);
   
    numSessions = numel(suffixList);
    auc = struct('msn',[],...
                 'chi',[],...
                 'fsi',[],...
                 'msnlo',[],...
                 'msnhi',[],...
                 'fsilo',[],...
                 'fsihi',[],...
                 'chilo',[],...
                 'chihi',[]...
    );
    for mouse=1:numSessions
         currMouse = loadMouse(suffixList(mouse));
        currMouse = addSpeedInfo(currMouse, pctileLo, pctileHi);
            dt = currMouse.dt;

        tracesCHI = movingaverage_new(currMouse.tracesCHI,10);
        tracesMSN = movingaverage_new(currMouse.tracesMSN,10);
        tracesFSI = movingaverage_new(currMouse.tracesFSI,10);
        
        tracesCHI = cat(2,tracesCHI, currMouse.broadTracesCHI);
        tracesMSN = cat(2,tracesMSN, currMouse.broadTracesMSN);
        tracesFSI = cat(2,tracesFSI, currMouse.broadTracesFSI);
        actStates = allActive(currMouse);
        
        %% Mean duration of active region for cholinergics and MSNs
        [peakShapesCHI, ~, peakSegmentsCHI] = peakFormRedux(tracesCHI, actStates.chi);
        [peakShapesFSI, ~, peakSegmentsFSI] = peakFormRedux(tracesFSI, actStates.fsi);
        [peakShapesMSN, ~, peakSegmentsMSN] = peakFormRedux(tracesMSN, actStates.msn);
        
        %get auc for all of them
        aucCHI = aucFromShape(peakShapesCHI,dt);
        aucMSN = aucFromShape(peakShapesMSN,dt);
        aucFSI = aucFromShape(peakShapesFSI,dt);
        
        auc(mouse).chi = aucCHI;
        auc(mouse).msn = aucMSN;
        auc(mouse).fsi = aucFSI;
        
        %get auc for hi and lo
        loSegments = currMouse.loSpdSustainSegs;
        peakShapesCHILo = getSegmentsInRegion(peakShapesCHI, peakSegmentsCHI, loSegments);
        peakShapesMSNLo = getSegmentsInRegion(peakShapesMSN, peakSegmentsMSN, loSegments);
        peakShapesFSILo = getSegmentsInRegion(peakShapesFSI, peakSegmentsFSI, loSegments);
        
        hiSegments = currMouse.hiSpdSustainSegs;
        peakShapesCHIHi = getSegmentsInRegion(peakShapesCHI, peakSegmentsCHI, hiSegments);
        peakShapesMSNHi = getSegmentsInRegion(peakShapesMSN, peakSegmentsMSN, hiSegments);
        peakShapesFSIHi = getSegmentsInRegion(peakShapesFSI, peakSegmentsFSI, hiSegments);
        
        auc(mouse).chilo = aucFromShape(peakShapesCHILo, dt);
        auc(mouse).chihi = aucFromShape(peakShapesCHIHi, dt);
        
        auc(mouse).fsilo = aucFromShape(peakShapesFSILo, dt);
        auc(mouse).fsihi = aucFromShape(peakShapesFSIHi, dt);
        
        auc(mouse).msnlo = aucFromShape(peakShapesMSNLo, dt);
        auc(mouse).msnhi = aucFromShape(peakShapesMSNHi, dt);
    end
end
