function singleFrameRoi = fixFrameNumbers(singleFrameRoi)
fnum = cat(1,singleFrameRoi.FrameIdx);
fset = cumsum(diff([1;fnum])<0);
fnum = fnum + fset * max(fnum(:));
for k=1:numel(singleFrameRoi)
	singleFrameRoi(k).FrameIdx = fnum(k);
end
end