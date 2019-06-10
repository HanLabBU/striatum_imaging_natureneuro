function plotMousePSTH(mouseno)
mouseData = loadMouse(mouseno);

for m=1:numel(mouseData)
    currm = mouseData(m);

    %act traces
    traces = cat(2,currm.activationStateMSN,currm.actStateBroadMSN);
    tracesCHI = cat(2,currm.activationStateCHI, currm.actStateBroadCHI);
    tracesFSI = cat(2,currm.activationStateFSI, currm.actStateBroadFSI);
    
    traces = risingPhase(cat(2,currm.tracesMSN, currm.broadTracesMSN),traces);
    tracesCHI = risingPhase(cat(2,currm.tracesCHI, currm.broadTracesCHI),tracesCHI);
    tracesFSI = risingPhase(cat(2,currm.tracesFSI, currm.broadTracesFSI), tracesFSI);
    
    figure
    plot(currm.taxis, currm.speed);
    title(sprintf('Speed vs activation state, %s',currm.suffix));
    ylabel('Cm/sec');
    hold on;
    yyaxis right
    mplt = plot(currm.taxis, sum(traces,2),'r');
    if ~isempty(tracesCHI)
        aplt = plot(currm.taxis, sum(tracesCHI,2),'g');
        legend('Speed','MSN','CHI');
    elseif ~isempty(tracesFSI)
        aplt = plot(currm.taxis, sum(tracesFSI,2),'g');
        legend('Speed','MSN','FSI');
    else
        legend('Speed','MSN');
    end
    ylabel('Sum of rising phase');
    hold off
    
    savePDF(gcf,sprintf('figures/%s/speed_psth_%s.pdf',date,currm.suffix));
    
    figure
    plot(currm.taxis, currm.rot);
    title(sprintf('Rotation vs activation state, %s',currm.suffix));
    ylabel('Radians/sec')
    hold on;
    yyaxis right
    mplt = plot(currm.taxis, sum(traces,2),'r');
    if ~isempty(tracesCHI)
        aplt = plot(currm.taxis, sum(tracesCHI,2),'g');
        legend('Rotation','MSN','CHI');
    elseif ~isempty(tracesFSI)
        aplt = plot(currm.taxis, sum(tracesFSI,2),'g');
        legend('Rotation','MSN','FSI');
    else
        legend('Rotation','MSN');
    end
    ylabel('Sum of rising phase');
    hold off
    
    savePDF(gcf,sprintf('figures/%s/rot_psth_%s.pdf',date,currm.suffix));
    
end


end