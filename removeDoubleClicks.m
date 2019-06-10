function R = removeDoubleClicks(R,cutoff)
if nargin < 2
    cutoff = 0.3;
end

for r=numel(R):-1:1
   currpixidx = R(r).PixelIdxList;
   for i=1:(r-1)
      temppixidx = R(i).PixelIdxList;
      if length(intersect(currpixidx,temppixidx))/length(currpixidx) > cutoff
          disp('removing roi');
          disp(R(r).isFSI || R(r).isCHI)
          R(r) = [];
          break
      end
   end
    
end

end