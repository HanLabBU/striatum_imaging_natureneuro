function identify_tdt_laser(metadata)
    load(sprintf('processedData/max-stats-laser/max_frames_%s.mat',metadata.suffix));
    load(sprintf('processedData/max-stats-laser/max_tdt_%s.mat',metadata.suffix));
    load(sprintf('processedData/rois-laser/rois_raw_%s.mat',metadata.suffix));
    load(sprintf('processedData/max-stats-laser/tdt_shift_%s.mat',...
        metadata.suffix));
    [R, currFig, preFig] = selectTDTsFromROI(R, maxTDT, maxFrame-minFrame,[totalXShift,totalYShift],metadata.isCHI);
    zoom out
    print(gcf,sprintf('figures/tdt_overlay_%s.pdf',metadata.suffix),'-dpdf','-bestfit');
    save(sprintf('processedData/rois-laser/rois_tdtlabeled_%s.mat',metadata.suffix),'R');
end