function a = allRising(mousedata)

f.msn = cat(2,mousedata.tracesMSN, mousedata.broadTracesMSN);
f.chi = cat(2,mousedata.tracesCHI, mousedata.broadTracesCHI);
f.fsi = cat(2,mousedata.tracesFSI, mousedata.broadTracesFSI);

a.msn = risingPhase(f.msn, cat(2,mousedata.activationStateMSN, mousedata.actStateBroadMSN));
a.chi = risingPhase(f.chi, cat(2,mousedata.activationStateCHI, mousedata.actStateBroadCHI));
a.fsi = risingPhase(f.fsi, cat(2,mousedata.activationStateFSI, mousedata.actStateBroadFSI));
end