function data = getData(fname)
if iscell(fname)
	for k=1:numel(fname)
		dataCell{k} = readBinaryData(fname{k});
	end
	data = cat(3,dataCell{:});
else
	data = readBinaryData(fname);
end
end