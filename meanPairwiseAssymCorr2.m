function [corrdata, zvals] = meanPairwiseAssymCorr2(mouseno) %are msns more correlated with each other or with cholinergics?
    mouseData = loadMouse(mouseno);
    corrdata = struct('msnmsn',[],'msnchi',[],'msnfsi',[], 'chichi',[],'fsifsi',[]);
    for m=1:numel(mouseData)
        currMouse = mouseData(m);
        suffix = currMouse.suffix;
        %curr msn traces
        currMSNAct = cat(2,currMouse.activationStateMSN, currMouse.actStateBroadMSN);
        currMSNTrace = cat(2,currMouse.tracesMSN, currMouse.broadTracesMSN);
        currMSNCentroids = cat(1,currMouse.centroidsMSN,currMouse.centroidsBroadMSN);
        currMSN = risingPhase(currMSNTrace, currMSNAct);
        
        load([suffix '_msn_rp2.mat']);
        currCHIAct = cat(2,currMouse.activationStateCHI, currMouse.actStateBroadCHI);
        currCHITrace = cat(2, currMouse.tracesCHI, currMouse.broadTracesCHI);
        currCHICentroids = cat(1, currMouse.centroidsCHI, currMouse.centroidsBroadCHI);
        currCHI = risingPhase(currCHITrace, currCHIAct);
        try
            load([suffix '_chi_rp2.mat']);
        catch
            shufflesCHI = cell(0);
        end
        
        
        currFSIAct = cat(2, currMouse.activationStateFSI, currMouse.actStateBroadFSI);
        currFSITrace = cat(2, currMouse.tracesFSI, currMouse.broadTracesFSI);
        currFSICentroids = cat(1, currMouse.centroidsFSI, currMouse.centroidsBroadFSI);
        currFSI = risingPhase(currFSITrace, currFSIAct);
        
        try
            load([suffix '_fsi_rp2.mat']);
        catch
            shufflesFSI = cell(0);
        end
        
        
        [rho, zv] = assymCorr5(currMSN,currMSN,shufflesMSN,shufflesMSN);
        corrdata.msnmsn.rho = rho;
        corrdata.msnmsn.zvals = zv;
        D = pdist2(currMSNCentroids, currMSNCentroids);
        d = pairwiseDistances(currMSNCentroids);
        corrdata.msnmsn.d = D;
        corrdata.msnmsn.d2 = d;
        fprintf('done with msns!\n');
        if ~isempty(currCHI)
            [rho, zv] = assymCorr5(currCHI, currCHI, shufflesCHI, shufflesCHI);
            corrdata.chichi.rho = rho;
            corrdata.chichi.zvals = zv;
            corrdata.chichi.d = pdist2(currCHICentroids, currCHICentroids);
            corrdata.chichi.d2 = pairwiseDistances(currCHICentroids);
            
            [rho1, zvals1] = assymCorr5(currMSN, currCHI, shufflesMSN, shufflesCHI);
            [rho2, zvals2] = assymCorr5(currCHI, currMSN, shufflesCHI, shufflesMSN);
            corrdata.msnchi.rho = rho1;
            corrdata.msnchi.zvals = zvals1;
            corrdata.msnchi.d = pdist2(currMSNCentroids, currCHICentroids);
            corrdata.msnchi.d2 = pairwiseDistances(currMSNCentroids, currCHICentroids);
            
            corrdata.chimsn.rho = rho2;
            corrdata.chimsn.zvals = zvals2;
            corrdata.chimsn.d = pdist2(currCHICentroids, currMSNCentroids);
            corrdata.chimsn.d2 = pairwiseDistances(currCHICentroids, currMSNCentroids);
            
        end
        if ~isempty(currFSI)
            [rho, zv] = assymCorr5(currFSI, currFSI, shufflesFSI, shufflesFSI);
            corrdata.fsifsi.rho = rho;
            corrdata.fsifsi.zvals = zv;
            corrdata.fsifsi.d = pdist2(currFSICentroids, currFSICentroids);
            corrdata.fsifsi.d2 = pairwiseDistances(currFSICentroids);
            
            [rho1, zvals1] = assymCorr5(currMSN, currFSI, shufflesMSN, shufflesFSI);
            [rho2, zvals2] = assymCorr5(currFSI, currMSN, shufflesFSI, shufflesMSN);
            corrdata.msnfsi.rho = rho1;
            corrdata.msnfsi.zvals = zvals1;
            corrdata.msnfsi.d = pdist2(currMSNCentroids, currFSICentroids);
            corrdata.msnfsi.d2 = pairwiseDistances(currMSNCentroids, currFSICentroids);
            corrdata.fsimsn.rho = rho2;
            corrdata.fsimsn.zvals = zvals2;
            corrdata.fsimsn.d = pdist2(currFSICentroids, currMSNCentroids);
            corrdata.fsimsn.d2 = pairwiseDistances(currFSICentroids, currMSNCentroids);
        end
        fprintf('done with %s\n',suffix);
        save(['corrdata/' suffix '_pairwiseasymmcorr_rp2.mat'],'corrdata','-v7.3');
    end
end
