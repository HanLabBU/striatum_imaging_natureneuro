function props = find_prop_close(clusterinds, centroids)
    cutoff = 100/1.3;

    %find new indices
    [~, ind] = neighbors_in_radius(centroids,cutoff); %get neighbors in radius of 100 pixels
    clusterinds_int = find(clusterinds); % convert indices to
    
    % get proportion for each that is of certain type
    proportion_of_type = cellfun(@(x) length(intersect(clusterinds_int,x))/length(x),ind);
    
    props.in = proportion_of_type(~~clusterinds);
    props.out = proportion_of_type(~clusterinds);
    
    
    
    
end