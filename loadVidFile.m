function data = loadVidFile(tifFile)
[expDir, expName] = fileparts(tifFile.fileName);
vidFileDir = [expDir, filesep, 'VidFiles'];
vidFileName = fullfile(vidFileDir,expName);
data =  getData([vidFileName '.1024.1024.2047.uint8']);
end