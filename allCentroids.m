function c = allCentroids(allMouseData)
    c.fsi = cat(1, allMouseData.centroidsFSI, allMouseData.centroidsBroadFSI);
    c.msn = cat(1, allMouseData.centroidsMSN, allMouseData.centroidsBroadMSN);
    c.chi = cat(1, allMouseData.centroidsCHI, allMouseData.centroidsBroadCHI);
end