function allMouseData = loadMouse(suffixList)
    allMouseData = struct('suffix', suffixList);
    for mouse=1:length(suffixList)
        suffix = suffixList{mouse};
        load(['preMouseData_' suffix '.mat']);
        load(['activationStatePreInf_' suffix '.mat']);
        load(['dynamic_indices_' suffix '.mat']);
        goodCHI = intersect(dynamicIndices, preMouseData.cholIndices);
        goodFSI = intersect(dynamicIndices, preMouseData.fsiIndices);
        goodMSN = setdiff(setdiff(dynamicIndices, goodCHI), goodFSI);
        
        load(['broad_indices_' suffix '.mat']);
        
        broadCHI = intersect(broadIndices, preMouseData.cholIndices);
        broadFSI = intersect(broadIndices, preMouseData.fsiIndices);
        broadMSN = setdiff(setdiff(broadIndices, broadCHI), broadFSI);

        load(['conj_indices_' suffix '.mat']);
        
        conjChol = intersect(conjIndices, preMouseData.cholIndices);
        conjFSI = intersect(conjIndices, preMouseData.fsiIndices);
        conjMSN = setdiff(setdiff(conjIndices, conjChol), conjFSI);

        preIndices = find(preMouseData.tvals < 600 & preMouseData.tvals > 5);
        allMouseData(mouse).preIndices = preIndices;
        speed = preMouseData.dydt(preIndices);
        dydt = preMouseData.dyInterp(preIndices);
        dxdt = preMouseData.dxInterp(preIndices);
        allMouseData(mouse).dydt = dydt;
        allMouseData(mouse).dxdt = dxdt;

        allMouseData(mouse).speed = speed;
        allMouseData(mouse).phi = preMouseData.phi(preIndices);
        allMouseData(mouse).rot = preMouseData.rot(preIndices);
        allMouseData(mouse).taxis = preMouseData.tvals(preIndices);
        allMouseData(mouse).activationStateCHI = activationState(preIndices,goodCHI);
        allMouseData(mouse).activationStateMSN = activationState(preIndices, goodMSN);
        allMouseData(mouse).activationStateFSI = activationState(preIndices, goodFSI);
     
        allMouseData(mouse).isCHI = length(preMouseData.cholIndices) > 0;
        allMouseData(mouse).isFSI = length(preMouseData.fsiIndices) > 0;

        allMouseData(mouse).tracesCHI = preMouseData.dff(preIndices, goodCHI);
        allMouseData(mouse).fCHI = preMouseData.f(preIndices, goodCHI);
        
        allMouseData(mouse).tracesMSN = preMouseData.dff(preIndices, goodMSN);
        allMouseData(mouse).fMSN = preMouseData.f(preIndices, goodMSN);
        
        allMouseData(mouse).tracesFSI = preMouseData.dff(preIndices, goodFSI);
        allMouseData(mouse).fFSI = preMouseData.f(preIndices, goodFSI);
        
        allMouseData(mouse).broadTracesCHI = (preMouseData.dff(preIndices, broadCHI));
        allMouseData(mouse).broadfCHI = preMouseData.f(preIndices, broadCHI);
        
        allMouseData(mouse).broadTracesMSN = (preMouseData.dff(preIndices, broadMSN));
        allMouseData(mouse).broadfMSN = preMouseData.f(preIndices, broadMSN);
        
        allMouseData(mouse).broadTracesFSI = (preMouseData.dff(preIndices, broadFSI));
        allMouseData(mouse).broadfFSI = preMouseData.f(preIndices, broadFSI);

        load(['activationStateBroad_' suffix '.mat']);
        
        allMouseData(mouse).actStateBroadCHI = activationState(preIndices, broadCHI);
        allMouseData(mouse).actStateBroadMSN = activationState(preIndices, broadMSN);
        allMouseData(mouse).actStateBroadFSI = activationState(preIndices, broadFSI);
        
        allMouseData(mouse).conjTracesCHI = preMouseData.dff(preIndices, conjChol);
        allMouseData(mouse).conjTracesMSN = preMouseData.dff(preIndices, conjMSN);
        allMouseData(mouse).conjTracesFSI = preMouseData.dff(preIndices, conjFSI);

        
        allMouseData(mouse).dt = preMouseData.dt;
        allMouseData(mouse).centroidsCHI = preMouseData.centroids(goodCHI,:);
        allMouseData(mouse).centroidsMSN = preMouseData.centroids(goodMSN,:);
        allMouseData(mouse).centroidsFSI = preMouseData.centroids(goodFSI,:);
        
        allMouseData(mouse).centroidsBroadCHI = preMouseData.centroids(broadCHI,:);
        allMouseData(mouse).centroidsBroadMSN = preMouseData.centroids(broadMSN,:);
        allMouseData(mouse).centroidsBroadFSI = preMouseData.centroids(broadFSI,:);
        allMouseData(mouse).boundary = preMouseData.boundary;
    end
end