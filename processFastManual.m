function varargout = processFastManual(varargin)
	% ------------------------------------------------------------------------------
	% PROCESSFAST
	% 7/30/2015
	% Mark Bucklin
	% ------------------------------------------------------------------------------
	%
	% DESCRIPTION:
	%  Just run it! Select the files you want to process and come back later. Use multi-page TIFF files as
	%  input. Either call with no input arguments, then select all files belonging to a dataset at once.
	%  Or call this function with the file-names as input (in a cell array will work). Output will be
	%  saved in several MAT files. 
	% 
	%	To begin, type:
	%
	%			>> processFast()
	%
	%	When finished, open the file beginning with "Processed_ROIs_..." and type:
	%
	%			>> show(R)
	%
	%
	%
	% USAGE:
	%   >> processFast()
	%   >> [allVidFiles] = processFast();
	%   >> [allVidFiles, R] = processFast();
	%   >> [allVidFiles, R, info] = processFast();
	%   >> [allVidFiles, R, info, uniqueFileName] = processFast();
	%   >> [allVidFiles, R, info, uniqueFileName] = processFast(tiffFileName);
	%   >> [allVidFiles, R, info, uniqueFileName] = processFast(cellArrayOfTiffFileNames);
	%
	%
	%
	% See also:
	%			REGIONOFINTEREST, READBINARYDATA, WRITEBINARYDATA, WRITETIFFFILE
	% ------------------------------------------------------------------------------
	% ------------------------------------------------------------------------------
	% ------------------------------------------------------------------------------

fprintf('process fast\n')


global HWAITBAR

% ------------------------------------------------------------------------------------------
% PROCESS FILENAME INPUT OR QUERY USER FOR MULTIPLE FILES
% ------------------------------------------------------------------------------------------
if nargin
	fname = varargin{1};
	switch class(fname)
		case 'char'
			fileName = cellstr(fname);
		case 'cell'
			fileName = cell(numel(fname),1);
			for n = 1:numel(fname)
				fileName{n} = which(fname{n});
			end
		case 'struct'
			fileName = {fname.name}';
			for n = 1:numel(fileName)
				fileName{n} = which(fileName{n});
			end
	end
	[fdir, ~] = fileparts(which(fileName{1}));
else
	[fname,fdir] = uigetfile('*.tif','MultiSelect','on');
	cd(fdir)
	switch class(fname)
		case 'char'
			fileName{1} = [fdir,fname];
		case 'cell'
			fileName = cell(numel(fname),1);
			for n = 1:numel(fname)
				fileName{n} = [fdir,fname{n}];
			end
	end
end


% ------------------------------------------------------------------------------------------
% GET INFO FROM EACH TIF FILE
% ------------------------------------------------------------------------------------------
nFiles = numel(fileName);
tifFile = struct(...
	'fileName',fileName(:),...
	'tiffTags',repmat({struct.empty(0,1)},nFiles,1),...
	'nFrames',repmat({0},nFiles,1),...
	'frameSize',repmat({[1024 1024]},nFiles,1));
HWAITBAR = waitbar(0, 'Aquiring Information from Each TIFF File');
for n = 1:nFiles
	HWAITBAR = waitbar(n/nFiles, HWAITBAR, 'Aquiring Information from Each TIFF File');
	tifFile(n).fileName = fileName{n};
	tifFile(n).tiffTags = imfinfo(fileName{n});
	tifFile(n).nFrames = numel(tifFile(n).tiffTags);
	tifFile(n).frameSize = [tifFile(n).tiffTags(1).Height tifFile(n).tiffTags(1).Width];
end
nTotalFrames = sum([tifFile(:).nFrames]);
fileFrameIdx.last = cumsum([tifFile(:).nFrames]);
fileFrameIdx.first = [0 fileFrameIdx.last(1:end-1)]+1;
[tifFile.firstIdx] = deal(fileFrameIdx.first);
[tifFile.lastIdx] = deal(fileFrameIdx.last);


% ------------------------------------------------------------------------------------------
% PROCESS FIRST FILE
% ------------------------------------------------------------------------------------------
[d8a, procstart, info] = processFirstVidFile(tifFile(1).fileName);
vidStats(1) = getVidStats(d8a);
vidProcSum(1) = procstart;
vfile = saveVidFile(d8a,info, tifFile(1));
allVidFiles{1} = vfile;



% ------------------------------------------------------------------------------------------
% PROCESS REST OF FILES
% ------------------------------------------------------------------------------------------
vidStats(numel(tifFile),1) = vidStats(1);
vidProcSum(numel(tifFile),1) = vidProcSum(1);
% allVidFiles{numel(tifFile),1} = []; Don't know why this line is here...
for kFile = 2:numel(tifFile)
	fname = tifFile(kFile).fileName;
	fprintf(' Processing: %s\n', fname);
	[f.d8a, procstart, f.info] = processVidFile(fname, procstart);
	vidStats(kFile) = getVidStats(f.d8a);
	vidProcSum(kFile) = procstart;
	vfile = saveVidFile(f.d8a, f.info, tifFile(kFile));
	allVidFiles{kFile,1} = vfile;
	info = cat(1,info, f.info);
end


% ------------------------------------------------------------------------------------------
% ONCE VIDEO HAS BEEN PROCESSED - CREATE FILENAMES AND SAVE VIDEO
% ------------------------------------------------------------------------------------------
try
	uniqueFileName = procstart.commonFileName;
	saveTime = now;
	processedVidFileName =  ...
		['Processed_VideoFiles_',...
		uniqueFileName,'_',...
		datestr(saveTime,'yyyy_mm_dd_HHMM'),...
		'.mat'];
	processedStatsFileName =  ...
		['Processed_VideoStatistics_',...
		uniqueFileName,'_',...
		datestr(saveTime,'yyyy_mm_dd_HHMM'),...
		'.mat'];
	processingSummaryFileName =  ...
		['Processing_Summary_',...
		uniqueFileName,'_',...
		datestr(saveTime,'yyyy_mm_dd_HHMM'),...
		'.mat'];
	roiFileName = ...
		['Manually_Processed_ROIs_',...
		uniqueFileName,'_',...
		datestr(saveTime,'yyyy_mm_dd_HHMM'),...
		'.mat'];
	save(fullfile(fdir, processedVidFileName), 'allVidFiles');
	save(fullfile(fdir, processedStatsFileName), 'vidStats', '-v6');
	save(fullfile(fdir, processingSummaryFileName), 'vidProcSum', '-v6');
	
    dataFileName = ['MAX_Processed_Data_8',...
        uniqueFileName '.mat'];
	
	% ------------------------------------------------------------------------------------------
	% RELOAD DATA AND MAKE ROI TRACES (NORMALIZED TO WINDOWED STD)
	% ------------------------------------------------------------------------------------------
	data = getData(allVidFiles);
	data = squeeze(data);
    maxData = max(data,[],3);
    save(dataFileName, 'maxData','allVidFiles');
    singleFrameRoi = manualSingleVidRois(maxData,1);
    singleFrameRoi = fixFrameNumbers(singleFrameRoi);
	R = singleFrameRoi.updateProperties();
	fprintf(['Total ',num2str(numel(R)),' ROIs.\n']);
	Xraw = makeTraceFromVid(R,data);
	
	% FILTER AND NORMALIZE TRACES AFTER COPYING TRACE TO RAWTRACE
	for k=1:numel(R)
		R(k).TraceType.raw = Xraw(:,k);%new
		% 	 R(k).Trace = X(:,k);
	end
	R.normalizeTrace2WindowedRange
	R.makeBoundaryTrace
	R.filterTrace
	save(fullfile(fdir,roiFileName), 'R');
	
    % ------------------------------------------------------------------------------------------
	% SHOW PLOT OF LABELED ROIs & THEIR TRACES
	% ------------------------------------------------------------------------------------------
    try
        show(R)
    catch
        % GET LABEL MATRIX
        labelMat = createLabelMatrix(R);
        labelMatRgb = label2rgb(labelMat, 'parula');
        figure, imshow(labelMatRgb);
        
        % GET ROI TRACE
        Xnormfilt = [R.Trace];
        figure, plot(Xnormfilt(1:10:101));
    end
    
	% ------------------------------------------------------------------------------------------
	% SAVE AND RETURN OUTPUTS (OR ASSIGN IN BASE)
	% ------------------------------------------------------------------------------------------
	save(fullfile(fdir,roiFileName), 'R');
	if nargout > 0
		varargout{1} = allVidFiles;
		if nargout > 1
			varargout{2} = R;
			if nargout > 2
				varargout{3} = info;
				if nargout > 3
					varargout{4} = uniqueFileName;
				end
			end
		else
			assignin('base','allVidFiles',allVidFiles)
		end
	else
		assignin('base','R',R)
	end
	delete(HWAITBAR)
catch me
	getReport(me)
	delete(HWAITBAR)
end



end