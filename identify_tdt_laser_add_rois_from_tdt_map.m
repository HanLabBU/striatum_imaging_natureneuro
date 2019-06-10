function identify_tdt_laser_add_rois_from_tdt_map(metadata)

   load(sprintf('processedData/max-stats-laser/max_frames_%s.mat',metadata.suffix));
    load(sprintf('processedData/max-stats-laser/max_tdt_%s.mat',metadata.suffix));
    load(sprintf('processedData/rois-laser/rois_raw_%s.mat',metadata.suffix));
    load(sprintf('processedData/max-stats-laser/tdt_shift_%s.mat',...
        metadata.suffix));
    R2 = selectSingleFrameRoisNew(imtranslate(maxTDT,[totalXShift, totalYShift]));
    R = cat(1,R(:),R2(:));
    [R, currFig, preFig] = selectTDTsFromROI(R,maxTDT, maxFrame-minFrame,[totalXShift,totalYShift],metadata.isCHI);
    zoom out
    print(gcf,sprintf('figures/tdt_overlay_%s.pdf',metadata.suffix),'-dpdf','-bestfit');
    save(sprintf('processedData/rois-laser/rois_tdtlabeled_tdt_%s.mat',metadata.suffix),'R');

end