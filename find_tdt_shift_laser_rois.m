function find_tdt_shift_laser_rois(metadata)
    load(sprintf('processedData/rois-laser/rois_raw_%s.mat',metadata.suffix));
    load(sprintf('processedData/max-stats-laser/max_frames_%s.mat',metadata.suffix));
    load(sprintf('processedData/max-stats-laser/max_tdt_%s.mat',metadata.suffix));
    [totalXShift, totalYShift]= findPrePostShift(R, maxFrame-minFrame, maxTDT);
    zoom out
    print(gcf,sprintf('figures/tdt_alignment_overlay_%s.pdf',metadata.suffix),'-dpdf','-bestfit');
    save(sprintf('processedData/max-stats-laser/tdt_shift_%s.mat',...
        metadata.suffix),'totalXShift','totalYShift');
end