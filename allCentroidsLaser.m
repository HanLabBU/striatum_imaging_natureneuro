function c = allCentroidsLaser(allMouseData)
    c.fsi = cat(1, allMouseData.centroidsFSI, allMouseData.centroidsBroadFSI, allMouseData.centroidsLaserFSI);
    c.msn = cat(1, allMouseData.centroidsMSN, allMouseData.centroidsBroadMSN, allMouseData.centroidsLaserMSN);
    c.chi = cat(1, allMouseData.centroidsCHI, allMouseData.centroidsBroadCHI, allMouseData.centroidsLaserCHI);
end