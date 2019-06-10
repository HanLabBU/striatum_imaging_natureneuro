function [fi, data] = load_processed_laser_uint8(metadata)
    
    prefix = sprintf('/hdd1/raw_data_laser/%s/VidFiles/',metadata.suffix);
    finames = dir([prefix '*.uint8']);
    if isempty(finames)
        prefix = sprintf('/hdd2/raw_data_laser/%s/VidFiles/',metadata.suffix);
        finames = dir([prefix '*.uint8']);
    end
        
    fi = {finames.name};
    fi = sort_tiff_files(fi);
    for f=1:numel(fi)
       fi{f} = [prefix fi{f}]; 
    end
    if nargout > 1
        data = loadProcessedVideoData(fi);
    end
end