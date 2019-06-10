function [val, ind] = neighbors_in_radius(centroids,radius)
    D = squareform(pdist(centroids)); % get matrix of euclidean distances
    
    ind = cell(size(centroids,1),1); %initialize cell of outputs
    
    val  = cell(size(centroids,1),1); %same
    
    diag_inds = logical(eye(size(D)));
    
    D(diag_inds) = deal(nan); %make diagonal distances equal to nan
    
    for i=1:size(centroids,1)
       curr_row = D(i,:);
       ind{i} = find(curr_row <= radius); %for each row, find values less than radius
       val{i} = curr_row(ind{i}); %get distances for each index in the current row
    end
    
end