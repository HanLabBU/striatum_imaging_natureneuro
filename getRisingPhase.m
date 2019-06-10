function rp = getRisingPhase(mouseData,celltype)
switch celltype
    case 'fsi'
        acttraces = cat(2,mouseData.activationStateFSI, mouseData.actStateBroadFSI);
        traces = cat(2,mouseData.tracesFSI, mouseData.broadTracesFSI);
    case 'chi'
        acttraces = cat(2,mouseData.activationStateCHI, mouseData.actStateBroadCHI);
        traces = cat(2,mouseData.tracesCHI, mouseData.broadTracesCHI);
    case 'msn'
        acttraces = cat(2,mouseData.activationStateMSN, mouseData.actStateBroadMSN);
        traces = cat(2,mouseData.tracesMSN, mouseData.broadTracesMSN);
    otherwise
        rp = nan;
        return
end

rp = risingPhase(traces, acttraces);

end