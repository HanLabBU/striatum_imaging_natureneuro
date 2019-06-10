function sm = serrMn(x,dim)
    if isempty(x)
        sm = [];
        return
    end
    if nargin > 1 && dim == 2
        x = x';
    end
    
    numnans = sum(isnan(x),1);
    sm = nanstd(x,[],1)./sqrt(repmat(size(x,1),1,size(x,2))-numnans);
end