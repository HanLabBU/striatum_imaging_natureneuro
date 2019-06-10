function f = allFluorLaser(mousedata)
f.msn = cat(2,mousedata.tracesMSN, mousedata.broadTracesMSN, mousedata.tracesLaserMSN);
f.chi = cat(2,mousedata.tracesCHI, mousedata.broadTracesCHI, mousedata.tracesLaserCHI);
f.fsi = cat(2,mousedata.tracesFSI, mousedata.broadTracesFSI, mousedata.tracesLaserFSI);
end