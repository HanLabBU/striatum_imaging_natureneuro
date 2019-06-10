function makeFigure1(mouseno)

suffix = mouseSuffix(mouseno);
mouseData = loadMouse(suffix);
for m=1:numel(suffix)
    allMouseData = mouseData(m);
    totalFSIs = size(allMouseData.tracesFSI,2) + size(allMouseData.broadTracesFSI,2);
    totalCHIs = size(allMouseData.tracesCHI,2) + size(allMouseData.broadTracesCHI,2);
    totalMSNs = size(allMouseData.tracesMSN,2) + size(allMouseData.broadTracesMSN,2);

    rp = allRising(allMouseData);
    
    actStateMSN = cat(2,rp.msn,rp.chi,rp.fsi);
    rng(1)
    p = randperm(size(actStateMSN,2));
    
    addMotionFigures(allMouseData, actStateMSN,p, suffix{m});
    
    
    fluor = cat(2, allMouseData.tracesMSN, allMouseData.broadTracesMSN,...
        allMouseData.tracesCHI, allMouseData.broadTracesCHI,...
        allMouseData.tracesFSI, allMouseData.broadTracesFSI);

    
    figure; plot(allMouseData.taxis, sum(fluor,2),'k');
    xlabel('time [s]');
    ylabel('\DeltaF/F (summed)');
    savePDF(gcf,sprintf('figures/%s/figure_2B_%s.pdf',date,suffix{m}))

    
    figure
    imagesc(allMouseData.taxis, 1:size(fluor,2), fluor(:,p)'); colorbar
    colormap(parula)
    xlabel('Time [s]');
    axis xy
    ylabel('ROI #');
    caxis([0 1]);
    z = colorbar;
    ylabel(z,'\DeltaF/F');
    fig15 = ['figures/' date '/fc_rasterplot_msn_' num2str(size(fluor,2)) '_neurons_' suffix{m} '.pdf'];
    savePDF(gcf,fig15);
    
    
    %%next is movement triggered activity
    figure;
    mot = dyTriggeredFluorescence(suffix{m},50,0);
    %first with cholinergic mouse
    dt = .0469;
    imagesc(dt*(-50:50),1:size(mot.msn,2),sortByMax(mot.msn)'); z = colorbar; ylabel(z,'\DeltaF/F');
    colormap(parula)
    caxis ([-.05 0.3])
    ylabel('ROI #');
    xlabel('Time relative to movement start [s]')
    title('Movement triggered fluorescence, MSN')
    fig5 = ['figures/' date '/mvmttrigact_msn_' suffix{m} '.pdf'];
    savePDF(gcf, fig5);

    figure;
    dt = .0469;
    if totalCHIs > 0
        imagesc(dt*(-50:50),1:size(mot.chi,2),sortByMax(mot.chi)'); colorbar
        colormap(jet)
        ylabel('ROI #');
        xlabel('Time relative to movement start [s]')
        title('Movement triggered fluorescence, ChI')
        fig6 = ['figures/' date '/mvmttrigact_chi_' suffix{m} '.pdf'];
        savePDF(gcf, fig6);
    else
        imagesc(dt*(-50:50),1:size(mot.fsi,2),sortByMax(mot.fsi)'); colorbar
        colormap(parula)
        ylabel('ROI #');
        xlabel('Time relative to movement start [s]')
        title('Movement triggered fluorescence, FSI')
        fig6 = ['figures/' date '/mvmttrigact_fsi_' suffix{m} '.pdf'];
        savePDF(gcf, fig6);
    end
    figure
    plotMvmtTrigAct(mot,suffix{m})
    savePDF(gcf,['figures/' date '/mean_mvmttrigact_' suffix{m} '.pdf']);    

end
end

function addMotionFigures(allMouseData, actStateMSN,p, suffix)
    figure;
    rasterPlot(allMouseData.taxis,actStateMSN(:,p),3); % plots all active regions
    title(['Raster plot for MSNs, ' suffix])
    fig1 = ['figures/' date '/rasterplot_segment_' suffix '.pdf'];
    savePDF(gcf, fig1)
    
    figure;
    rasterPlot(allMouseData.taxis,[zeros(1,size(actStateMSN,2)); diff(actStateMSN(:,p),[],1) == 1],3);
    title(['Raster plot for MSNs, ' suffix])
    fig1 = ['figures/' date '/rasterplot_singlepoint_' suffix '.pdf'];
    savePDF(gcf, fig1)
    
    
    figure
    subplot(3,1,1)
    plot(allMouseData.taxis(2:end), allMouseData.rot(2:end),'k');
    ylabel('Rotation [radians/s]');
    subplot(3,1,2)
    plot(allMouseData.taxis(2:end), diff(allMouseData.speed),'k');
    ylabel('\DeltaSpeed');
    subplot(3,1,3)
    plot(allMouseData.taxis(2:end), allMouseData.speed(2:end),'k');
    ylabel('Speed [cm/s]');
    fig1 = ['figures/' date '/spd_rot_accel_' suffix '.pdf'];
    savePDF(gcf, fig1)
   
    % now create speed with movement onset and offset
    onset = findPeaksManual(allMouseData.speed, allMouseData.dt);
    rotonset = findRotPeaksManual(abs(allMouseData.rot),allMouseData.dt);
    offset = findValleysManual(allMouseData.speed, allMouseData.dt);
    
    figure
    plot(allMouseData.taxis(1:end), allMouseData.speed(1:end),'k');
    hold on;
    text(allMouseData.taxis(onset), 50*ones(size(onset)), '*','FontSize',10,'color','g');
    ylabel('Speed [cm/s]');
   xlabel('Time [s]');
   title('Movement onset events');
    savePDF(gcf,sprintf('figures/%s/mousespeed_movementonset_%s.pdf',date,suffix));
    
    figure
    plot(allMouseData.taxis(1:end), allMouseData.rot(1:end),'k');
    hold on;
    text(allMouseData.taxis(rotonset), 5*ones(size(rotonset)), '*','FontSize',10,'color','g');
    ylabel('Speed [cm/s]');
   xlabel('Time [s]');
   title('Movement onset events');
    savePDF(gcf,sprintf('figures/%s/mousespeed_rotationonset_%s.pdf',date,suffix));
    
    
    
    
    
   figure
    plot(allMouseData.taxis, allMouseData.speed(1:end),'k');
    hold on;
    text(allMouseData.taxis(offset), 50*ones(size(offset)), '*','FontSize',10,'color','r'); 
        ylabel('Speed [cm/s]');
xlabel('Time [s]');
title('Movement offset events');
    savePDF(gcf,sprintf('figures/%s/mousespeed_movementoffset_%s.pdf',date,suffix));

    
    traces = allFluor(allMouseData);
    traces.all = sum(cat(2,traces.msn, traces.chi, traces.fsi),2);
    allMouseData = addSpeedInfo(allMouseData,1,5);
    figure
    subplot(2,1,1)
    plot(allMouseData.taxis, allMouseData.speed,'k');
    hold on;    title('Hi speed time periods');
        ylabel('Speed [cm/s]');
    segs = allMouseData.hiSpdSustainSegs;
    for s=1:size(segs,1)
        tvals = allMouseData.taxis(segs(s,1):segs(s,2));
        yvals = 100*ones(size(tvals));
        a = area(tvals,yvals);
        a.LineStyle = 'none';
        a.FaceColor = 'g';
        a.FaceAlpha = 0.3;
    end
    subplot(2,1,2);
    plot(allMouseData.taxis, traces.all,'k');
    hold on;
    for s=1:size(segs,1)
        tvals = allMouseData.taxis(segs(s,1):segs(s,2));
        yvals = 1.1*(max(traces.all)-min(traces.all))*ones(size(tvals));
        a = area(tvals,yvals);
        a.LineStyle = 'none';
        a.FaceColor = 'g';
        a.FaceAlpha = 0.3;
        a.BaseLine.Visible = 'off';
        if s == 1
            a.BaseValue = min(traces.all);
        end
    end
    ylim([min(traces.all)-1 max(traces.all)+1])
    xlabel('Time [s]');
    ylabel('\DeltaF/F');
    savePDF(gcf,sprintf('figures/%s/mousespeed_hisustainedmovement_%s.pdf',date,suffix));
    
    
    
    
    figure
    subplot(2,1,1)
    plot(allMouseData.taxis, allMouseData.speed,'k');
    hold on;
    segs = allMouseData.loSpdSustainSegs;
    for s=1:size(segs,1)
        tvals = allMouseData.taxis(segs(s,1):segs(s,2));
        yvals = 100*ones(size(tvals));
        a = area(tvals,yvals);
        a.LineStyle = 'none';
        a.FaceColor = 'r';
        a.FaceAlpha = 0.3;
    end
    ylabel('Speed [cm/s]');
    title('Lo speed time periods');
    subplot(2,1,2);
    plot(allMouseData.taxis, traces.all,'k');
    hold on;
    for s=1:size(segs,1)
        tvals = allMouseData.taxis(segs(s,1):segs(s,2));
        yvals = 1.1*(max(traces.all)-min(traces.all))*ones(size(tvals));
        a = area(tvals,yvals);
        a.LineStyle = 'none';
        a.FaceColor = 'r';
        a.FaceAlpha = 0.3;
        if s == 1
            a.BaseValue = min(traces.all);
        end
        a.BaseLine.Visible = 'off';

    end
    ylim([min(traces.all)-1 max(traces.all)+1])
    xlabel('Time [s]');
    ylabel('\DeltaF/F (all ROIs)');
    savePDF(gcf,sprintf('figures/%s/mousespeed_losustainedmovement_%s.pdf',date,suffix));
    
end