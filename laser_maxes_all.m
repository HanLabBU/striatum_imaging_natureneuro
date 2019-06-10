function laser_maxes_all(metadata)
    fi = load_processed_laser_uint8(metadata);
    get_laser_maxes(metadata.suffix,fi);
end