function [flAll, roi] = dff_vs_velocity(mouseno)
    vel_bins = [0 10 20 30 40 50 60 70];
    suffix = mouseSuffix(mouseno);
    allMouseData = loadMouse(suffix);

    for m=1:numel(allMouseData)
        mouseData = allMouseData(m);
        msntr = cat(2,mouseData.tracesMSN, mouseData.broadTracesMSN);
        chitr = cat(2,mouseData.tracesCHI, mouseData.broadTracesCHI);
        fsitr = cat(2,mouseData.tracesFSI, mouseData.broadTracesFSI);
        speed = mouseData.speed;
        
        for i=1:(length(vel_bins)-1)
            inds = find(speed < vel_bins(i+1) & speed >= vel_bins(i));
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
    
    tlab = mean([vel_bins(2:end);vel_bins(1:end-1)],1);
    figure
    errorbar(1:length(tlab), mean([roi.msn],2),serrMn([roi.msn],2));
    hold on;
    errorbar(1:length(tlab), mean([roi.fsi],2),serrMn([roi.fsi],2));
    errorbar(1:length(tlab), mean([roi.chi],2),serrMn([roi.chi],2));
    ylabel('Mean \DeltaF/F');
    xlim([0 8])
    ax = gca;
    ax.XTickLabel = {'','0-10','10-20','20-30','30-40','40-50','50-60','60-70'};%,'70-80','80-90','90-100'};
    xlabel('Speed [cm/s]');
    title('Fluorescence vs speed, roi averaged');
    legend('MSN','FSI','CHI','Location','NorthWest');
end