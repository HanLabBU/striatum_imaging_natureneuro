function R = processROIsLaser(metadata)
    load((sprintf('processedData/rois-laser/rois_tdtlabeled_%s.mat',metadata.suffix)));
    [~, data] = load_processed_laser_uint8(metadata);
    R = processRoisNew(R,data);
end