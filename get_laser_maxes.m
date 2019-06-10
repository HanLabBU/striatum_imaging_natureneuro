function get_laser_maxes(suffix,finames)
for d=1:numel(finames)
   newdata = loadProcessedVideoData(finames{d});
   if d == 1
       datamax = max(newdata,[],3);
       datamin = min(newdata,[],3);
   else
       datamax = max(cat(3,datamax,newdata),[],3);
       datamin = min(cat(3,datamin,newdata),[],3);
   end
end

maxFrame = datamax;
minFrame = datamin;
save(sprintf('processedData/max-stats-laser/max_frames_%s.mat',suffix),'maxFrame','minFrame');

end