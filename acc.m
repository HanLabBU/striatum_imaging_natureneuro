
% let B be a vector and A be a matrix. To what extent does A overlap with
% segments in B?
function s = acc(A,B)
   % get segments from B
    B(isnan(B)) = 0; 
    segsB = activeSegmentsSE(B);
    A(isnan(A)) = 0;
    Bsegs = segsB{1}; % get all segments in B
    if isempty(Bsegs)
        s = nan;
        return
    end

    BOnly = size(Bsegs,1); %get number of active regions for each column
    BAndA = zeros(size(Bsegs,1),size(A,2));
    for seg=1:size(Bsegs,1)
        BAndA(seg,:) = any(A(Bsegs(seg,1):Bsegs(seg,2),:),1);
    end
    s = nansum(BAndA,1)./BOnly;
end