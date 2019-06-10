function plotMvmtTrigAct(peakMovement, label,subplt, sigInds)
    figure
    if nargin > 2 && subplt
        subplot(2,1,1)
    end
    if nargin < 4
        sigInds.msn = 1:size(peakMovement.msn,2);
        sigInds.chi = 1:size(peakMovement.chi,2);
        sigInds.fsi = 1:size(peakMovement.fsi,2);
    end
    radius = (size(peakMovement.msn, 1)-1)/2;
    taxis = [(-radius:radius)*.0469];
        
    hold on
    if size(peakMovement.chi,2) == 1
        bar2.mainLine = plot(taxis, peakMovement.chi,'r');
    elseif ~isempty(peakMovement.chi)
        bar2 = shadedErrorBar(taxis, nanmean(peakMovement.chi(:,sigInds.chi),2), serrMn(peakMovement.chi(:,sigInds.chi),2)','r',0);
    else
        bar2 = [];
    end
    if size(peakMovement.fsi,2) == 1
        bar3.mainLine = plot(taxis, peakMovement.fsi,'g');
    elseif ~isempty(peakMovement.fsi)
        bar3 = shadedErrorBar(taxis, nanmean(peakMovement.fsi(:,sigInds.fsi), 2), serrMn(peakMovement.fsi(:,sigInds.fsi),2)','g',0);
    else
        bar3 = [];
    end
    hold on;
    bar1 = shadedErrorBar(taxis, nanmean(peakMovement.msn(:,sigInds.msn),2), serrMn(peakMovement.msn(:,sigInds.msn),2)','b',0);
    lab = {'MSN'};
    mainLines = bar1.mainLine;
    if ~isempty(bar2)
        lab = cat(1,lab,{'CHI'});
        mainLines = cat(1,mainLines, bar2.mainLine);
    end
    if ~isempty(bar3)
        lab = cat(1,lab,{'FSI'});
        mainLines = cat(1,mainLines, bar3.mainLine);
    end
    legend(mainLines, lab);
    xlabel(label)
    ylabel('\DeltaF/F')
    xlim([taxis(1) taxis(end)]);
end