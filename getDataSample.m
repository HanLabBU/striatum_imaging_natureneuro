function dataSample = getDataSample(data,varargin)
% Returns a randomized sample of data-frames (previously getVidSample)
N = size(data,3);
if nargin > 1
	nSampleFrames = varargin{1};
else
	nSampleFrames = min(N, 100);
end
jitter = floor(N/nSampleFrames);
sampleFrameNumbers = round(linspace(1, N-jitter, nSampleFrames)')...
	+ round( jitter*rand(nSampleFrames,1));
dataSample = data(:,:,sampleFrameNumbers);
end