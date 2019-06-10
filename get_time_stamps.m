function ts = get_time_stamps(metadata_raw)
ts = [];
for m=1:numel(metadata_raw.rawtiffs)
    tiff = strrep(metadata_raw.rawtiffs{m},char(1),'');
    ts = cat(1,ts,arrayfun(@getHcTimeStamp2,imfinfo(tiff)));
end
end