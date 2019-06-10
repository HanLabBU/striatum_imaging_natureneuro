function [flAll, roi] = dff_vs_rotation(mouseno)
    rotation_bins = [0 1 2 3 4 5];% 80 90 100];
    suffix = mouseSuffix(mouseno);
    allMouseData = loadMouse(suffix);

    for m=1:numel(allMouseData)
        mouseData = allMouseData(m);
        msntr = cat(2,mouseData.tracesMSN, mouseData.broadTracesMSN);
        chitr = cat(2,mouseData.tracesCHI, mouseData.broadTracesCHI);
        fsitr = cat(2,mouseData.tracesFSI, mouseData.broadTracesFSI);

        for i=1:(length(rotation_bins)-1)
            inds = find(abs(mouseData.rot) < rotation_bins(i+1) & abs(mouseData.rot) >= rotation_bins(i));
            fl(i).msn = nanmean(msntr(inds,:),1);
            if ~isempty(chitr)
                fl(i).chi = nanmean(chitr(inds,:),1);
            else
                fl(i).chi = [];
            end
            if ~isempty(fsitr)
                fl(i).fsi = nanmean(fsitr(inds,:),1);
            else
                fl(i).fsi = [];
            end
        end
        flAll(m).fl = fl;
        fprintf('Done with %d\n',m);
    end
    roi.msn = [];
    roi.chi = [];
    roi.fsi = [];
    for i=1:numel(allMouseData)
        roi.msn = cat(2,roi.msn,cat(1,flAll(i).fl.msn));
        roi.chi = cat(2,roi.chi,cat(1,flAll(i).fl.chi));
        roi.fsi = cat(2,roi.fsi,cat(1,flAll(i).fl.fsi));
    end
    
    %plot
    
    tlab = mean([rotation_bins(2:end);rotation_bins(1:end-1)],1);
    figure
    errorbar(1:length(tlab), mean([roi.msn],2),serrMn([roi.msn],2));
    hold on;
    errorbar(1:length(tlab), mean([roi.fsi],2),serrMn([roi.fsi],2));
    errorbar(1:length(tlab), mean([roi.chi],2),serrMn([roi.chi],2));
    ylabel('Mean \DeltaF/F');
    xlim([0 6])
    ax = gca;
    ax.XTickLabel = {'','0-1','1-2','2-3','3-4','4-5'};%,'70-80','80-90','90-100'};
    xlabel('Rotation [radians/s]');
    title('Fluorescence vs rotation, roi averaged');
    legend('MSN','FSI','CHI','Location','NorthWest');
end