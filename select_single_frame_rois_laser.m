    function R = select_single_frame_rois_laser(metadata)
    load(sprintf('processedData/max-stats-laser/max_frames_%s.mat',metadata.suffix));
    R = selectSingleFrameRoisNew(maxFrame-minFrame);
    save(sprintf('processedData/rois-laser/rois_raw_%s.mat',metadata.suffix),'R');
end