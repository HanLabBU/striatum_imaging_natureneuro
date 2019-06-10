function Z = pairwiseDistances(centroidsA, centroidsB)
    if nargin < 2
        centroidsB = centroidsA;
    end
    Z = cell(size(centroidsA,1),size(centroidsB,1));
    for i=1:size(centroidsA,1)
        for j=1:size(centroidsB,1)
            Z{i,j} = centroidsA(i,:)-centroidsB(j,:);
        end
    end
end