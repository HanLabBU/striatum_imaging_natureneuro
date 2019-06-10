% code adopted from mark bucklin
function trace = makeTrace(RP, data)
        nObj = numel(RP);
        sz = size(data);
        nFrames = sz(ndims(data));
        firstFrame = data(:,:,1);
        % RESHAPE VIDEO DATA FRAMES TO COLUMNS
        data = reshape(data, [numel(firstFrame), nFrames]);
        trace = nan(nFrames,nObj);
        for kRoi = 1:nObj
                pixIdx = RP(kRoi).PixelIdxList(:);
            trace(:,kRoi) = mean(data(pixIdx,:), 1)';
        end
end