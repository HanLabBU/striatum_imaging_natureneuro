function data = processTDTLaser(suffix, finname)

data = processTDTFile(finname);
maxTDT = max(data,[],3);
save(['processedData/' suffix '_tdtprocessed.mat'],'data');
save(sprintf('/fastdata/ca-imaging-NATURESUBMISSION-3/ca-imaging-NATURESUBMISSION-3/processedData/max-stats-laser/max_tdt_%s.mat', suffix),'maxTDT');
end