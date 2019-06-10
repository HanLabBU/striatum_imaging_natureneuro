function [rout, zout] = meanPairVal(rho, zval)
    sz = size(rho,1);
    rout = nan(sz*(sz+1)/2 - sz,1);
    if nargin > 1
        zout = nan(sz*(sz+1)/2 - sz,size(zval,3));
    else
        zout = [];
    end
    currind = 1;
    for i=1:size(rho,2)
        for j=(i+1):size(rho,1)
            rout(currind) = mean([rho(i,j),rho(j,i)]);
            if nargin > 1
                zout(currind,:) = squeeze(mean(cat(1,zval(i,j,:),zval(j,i,:))));
            end
            currind = currind+1;
        end
    end
    zout = squeeze(zout);
end