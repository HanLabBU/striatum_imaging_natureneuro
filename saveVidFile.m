 function vfile = saveVidFile(data,~,tifFile)
 [expDir, expName] = fileparts(tifFile.fileName);
vidFileDir = [expDir, filesep, 'VidFiles'];
 if ~isdir(vidFileDir)
 	mkdir(vidFileDir);
 end
 vidFileName = fullfile(vidFileDir,expName);
 vfile = writeBinaryData(data, vidFileName);
end