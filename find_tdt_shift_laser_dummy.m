function find_tdt_shift_laser_dummy(metadata)
    load(sprintf('processedData/max-stats-laser/max_frames_%s.mat',metadata.suffix));
    load(sprintf('processedData/max-stats-laser/max_tdt_%s.mat',metadata.suffix));
    figure;
    plot_with_contrast_adjust(maxTDT,0, 30000);
    title('TDT image');
    figure;
    [totalXShift, totalYShift]= findPrePostShiftDummy(maxFrame-minFrame, maxTDT);
    zoom out, xlim([0.5 1024.5]); ylim([0.5 1024.5]);
    print(gcf,sprintf('figures/tdt_alignment_overlay_%s.pdf',metadata.suffix),'-dpdf','-bestfit');
    save(sprintf('processedData/max-stats-laser/tdt_shift_%s.mat',...
        metadata.suffix),'totalXShift','totalYShift');
end