function videoData = loadProcessedVideoData(varargin)
    if nargin == 0 || isempty(varargin{1})
        videoList = uigetfile({'*.uint8'},'multiselect','on');
    else
        videoList = varargin{:};
    end
    videoData = getData(videoList);
    videoData = squeeze(videoData);
end