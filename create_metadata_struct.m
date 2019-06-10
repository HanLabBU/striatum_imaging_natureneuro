function metadata = create_metadata_struct
metadata = struct();
suff = input('What is the suffix of the animal?\n','s');
metadata.suffix = suff;

% add tiff files
fprintf('Please select tiff files!\n');
[fi,path,ext] = uigetfile('/handata/eng_research_handata2/mike-romano/*.tif','multiselect','on');
if ~iscell(fi) && numel(fi) == 1 && fi == 0
    files = {};
else
    files = cell(numel(fi),1);
    for f=1:numel(fi)
       files{f} = [path fi{f} ext];
    end
end
metadata.rawtiffs = files;

% select tdt files
fprintf('Please select movement file!\n');
[fi,path,ext] = uigetfile('/handata/eng_research_handata2/mike-romano/','multiselect','on');
metadata.movementfile = [path fi ext];

fprintf('Please select tdt file(s)!\n');
[fi,path,ext] = uigetfile('/handata/eng_research_handata2/mike-romano/*.tif','multiselect','on');
if ~iscell(fi) && numel(fi) == 1 && fi == 0
    metadata.tdtfile = {};
else
    if ~iscell(fi)
        metadata.tdtfile = [path fi ext];
    else
        metadata.tdtfile = {};
        for f=1:numel(fi)
            metadata.tdtfile{end+1} = [path fi{f} ext];
        end
    end
end

ischi = input('Is this mouse CHI?\n');
metadata.isCHI = ischi;

fprintf('Please select laser file\n');
[fi,path,ext] = uigetfile('/handata/eng_research_handata2/mike-romano/');

metadata.laserfi = [path fi ext];


end