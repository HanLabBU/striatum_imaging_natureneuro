function plot_example_traces(mouseno)
suffix = mouseSuffix(mouseno);
for m=1:numel(suffix)
    mouseData = loadMouse({suffix{m}});
    figure
    height = 1;
    plot(mouseData.taxis, rescale(mouseData.speed)+height,'k');
    hold on;
    text(mouseData.taxis(end)+1, height, 'Speed');
    height = height+1;
    plot(mouseData.taxis, [0; rescale(diff(mouseData.speed))]+height,'k');
    text(mouseData.taxis(end)+1, height, 'Delta speed');
    height = height + 1;
    plot(mouseData.taxis, rescale(mouseData.rot)+height,'k');
    text(mouseData.taxis(end)+1, height, 'Rotation');
    height = height + 1;
    tracesMSN = cat(2,mouseData.tracesMSN, mouseData.broadTracesMSN);
    tracesCHI = cat(2,mouseData.tracesCHI, mouseData.broadTracesCHI);
    tracesFSI = cat(2, mouseData.tracesFSI, mouseData.broadTracesFSI);

    for i=1:size(tracesMSN,2)
        plot(mouseData.taxis, tracesMSN(:,i)/10+height,'b');
        height = height+1;
    end

    for i=1:size(tracesCHI,2)
        plot(mouseData.taxis, tracesCHI(:,i)/10+height,'r');
        height = height+1;
    end    

    for i=1:size(tracesFSI,2)
        plot(mouseData.taxis, tracesFSI(:,i)/10+height,'g');
        height = height+1;
    end
    hold off
    title(suffix{m})
    savePDF(gcf,sprintf('figures/%s/example_traces/example_traces_%s.pdf',date,suffix{m}));
    hold on
    pos = 1;
    for i=1:3:height
       ylim([i-1 i+3]) 
        savePDF(gcf,sprintf('figures/%s/example_traces/example_traces_%s_%d.pdf',date,suffix{m},pos));
        pos = pos+1;
    end
    close all
end
end