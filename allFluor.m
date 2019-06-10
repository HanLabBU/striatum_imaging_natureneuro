function f = allFluor(mousedata)
f.msn = cat(2,mousedata.tracesMSN, mousedata.broadTracesMSN);
f.chi = cat(2,mousedata.tracesCHI, mousedata.broadTracesCHI);
f.fsi = cat(2,mousedata.tracesFSI, mousedata.broadTracesFSI);
end