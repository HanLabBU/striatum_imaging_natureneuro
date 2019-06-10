function allMouseData = loadMouseLaser(metadata)

        suffix = metadata.suffix;
        load(['preMouseData_' suffix '.mat']);
        load(['activation_state_dynamic_' suffix '.mat']);
        load(['dynamic_indices_' suffix '.mat']);
        dynamicCHI = intersect(dynamicIndices, preMouseData.cholIndices);
        dynamicFSI = intersect(dynamicIndices, preMouseData.fsiIndices);
        dynamicMSN = setdiff(setdiff(dynamicIndices, dynamicCHI), dynamicFSI);
        
        load(['broad_indices_' suffix '.mat']);
        
        broadCHI = intersect(broadIndices, preMouseData.cholIndices);
        broadFSI = intersect(broadIndices, preMouseData.fsiIndices);
        broadMSN = setdiff(setdiff(broadIndices, broadCHI), broadFSI);

        load(['conj_indices_' suffix '.mat']);
        
        conjCHI = intersect(conjIndices, preMouseData.cholIndices);
        conjFSI = intersect(conjIndices, preMouseData.fsiIndices);
        conjMSN = setdiff(setdiff(conjIndices, conjCHI), conjFSI);

        load(['laser_indices_' suffix '.mat']);
        
        laserCHI = intersect(laserIndices, preMouseData.cholIndices);
        laserFSI = intersect(laserIndices, preMouseData.fsiIndices);
        laserMSN = setdiff(setdiff(laserIndices, laserCHI), laserFSI);
        
        preIndices = find(preMouseData.tvals > 5);
        allMouseData.speed = preMouseData.dydt(preIndices);
        allMouseData.dydt = preMouseData.dyInterp(preIndices);
        allMouseData.dxdt = preMouseData.dxInterp(preIndices);
        allMouseData.phi = preMouseData.phi(preIndices);
        allMouseData.rot = preMouseData.rot(preIndices);
        allMouseData.taxis = preMouseData.tvals(preIndices);
        allMouseData.laserIndices = preMouseData.laserIndices(preIndices);
        
        allMouseData.isCHI = ~~metadata.isCHI;
        allMouseData.isFSI = ~metadata.isCHI;

        allMouseData.tracesCHI = preMouseData.dff(preIndices, dynamicCHI);        
        allMouseData.tracesMSN = preMouseData.dff(preIndices, dynamicMSN);
        allMouseData.tracesFSI = preMouseData.dff(preIndices, dynamicFSI);
        
        allMouseData.activationStateCHI = activation_state(preIndices, dynamicCHI);
        allMouseData.activationStateMSN = activation_state(preIndices, dynamicMSN);
        allMouseData.activationStateFSI = activation_state(preIndices, dynamicFSI);
        
        allMouseData.tracesLaserCHI = preMouseData.dff(preIndices, laserCHI);
        allMouseData.tracesLaserMSN = preMouseData.dff(preIndices, laserMSN);
        allMouseData.tracesLaserFSI = preMouseData.dff(preIndices, laserFSI);
        
        load(['activation_state_laser_' suffix '.mat']);
        
        allMouseData.actStateLaserCHI = activation_state(preIndices, laserCHI);
        allMouseData.actStateLaserMSN = activation_state(preIndices, laserMSN);
        allMouseData.actStateLaserFSI = activation_state(preIndices, laserFSI);        
        
        allMouseData.broadTracesCHI = (preMouseData.dff(preIndices, broadCHI)); 
        allMouseData.broadTracesMSN = (preMouseData.dff(preIndices, broadMSN));
        allMouseData.broadTracesFSI = (preMouseData.dff(preIndices, broadFSI));

        
        load(['activation_state_broad_' suffix '.mat']);
        
        allMouseData.actStateBroadCHI = activation_state(preIndices, broadCHI);
        allMouseData.actStateBroadMSN = activation_state(preIndices, broadMSN);
        allMouseData.actStateBroadFSI = activation_state(preIndices, broadFSI);
        
        allMouseData.conjTracesCHI = preMouseData.dff(preIndices, conjCHI);
        allMouseData.conjTracesMSN = preMouseData.dff(preIndices, conjMSN);
        allMouseData.conjTracesFSI = preMouseData.dff(preIndices, conjFSI);

        
        allMouseData.dt = preMouseData.dt;
        allMouseData.centroidsCHI = preMouseData.centroids(dynamicCHI,:);
        allMouseData.centroidsMSN = preMouseData.centroids(dynamicMSN,:);
        allMouseData.centroidsFSI = preMouseData.centroids(dynamicFSI,:);
        
        allMouseData.centroidsBroadCHI = preMouseData.centroids(broadCHI,:);
        allMouseData.centroidsBroadMSN = preMouseData.centroids(broadMSN,:);
        allMouseData.centroidsBroadFSI = preMouseData.centroids(broadFSI,:);
        % new lines
        allMouseData.centroidsLaserCHI = preMouseData.centroids(laserCHI,:);
        allMouseData.centroidsLaserMSN = preMouseData.centroids(laserMSN,:);
        allMouseData.centroidsLaserFSI = preMouseData.centroids(laserFSI,:);
        
        %
        allMouseData.boundary = preMouseData.boundary;
end