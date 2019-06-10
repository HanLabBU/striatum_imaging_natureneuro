function processOnlyManualTest(varargin)

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
[d8a, procstart, info] = processFirstVidFileTest(tifFile(1).fileName);
dataold = loadVidFile(tifFile(1));
isequaln(d8a,dataold)



% ------------------------------------------------------------------------------------------
% PROCESS REST OF FILES
% ------------------------------------------------------------------------------------------

for kFile = 2:numel(tifFile)
	fname = tifFile(kFile).fileName;
	fprintf(' Processing: %s\n', fname);
	[f.d8a, procstart, f.info] = processVidFileTest(fname, procstart);
    dataold = loadVidFile(tifFile(1));
    isequaln(d8a,dataold)
	info = cat(1,info, f.info);
end
end