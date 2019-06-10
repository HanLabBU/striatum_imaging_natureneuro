function a = allRisingLaser(mousedata)

f.msn = cat(2,mousedata.tracesMSN, mousedata.broadTracesMSN, mousedata.tracesLaserMSN);
f.chi = cat(2,mousedata.tracesCHI, mousedata.broadTracesCHI, mousedata.tracesLaserCHI);
f.fsi = cat(2,mousedata.tracesFSI, mousedata.broadTracesFSI, mousedata.tracesLaserFSI);

a.msn = risingPhase(f.msn, cat(2,mousedata.activationStateMSN, mousedata.actStateBroadMSN, mousedata.actStateLaserMSN));
a.chi = risingPhase(f.chi, cat(2,mousedata.activationStateCHI, mousedata.actStateBroadCHI, mousedata.actStateLaserCHI));
a.fsi = risingPhase(f.fsi, cat(2,mousedata.activationStateFSI, mousedata.actStateBroadFSI, mousedata.actStateLaserFSI));
end