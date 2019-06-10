function bouts = mean_bout_length(fi,mouseno)
suffix = mouseSuffix(mouseno);
bouts = [];
for m=1:numel(suffix)
   mousedata = loadMouse(suffix(m));
   mousedata = addSpeedInfo(mousedata,1,5);
   bouts = cat(1,bouts,mousedata.hiSpdSustainSegs);
   
end
bout_lengths = mousedata.dt*(diff(bouts,[],2)+1);

fprintf(fi,'Mean bout length: %d +/- %0.3f (SEM) seconds, %d bouts\n',nanmean(bout_lengths),serrMn(bout_lengths),length(bout_lengths));

fprintf('Mean bout length: %d +/- %0.3f (SEM) seconds, %d bouts\n',nanmean(bout_lengths),serrMn(bout_lengths),length(bout_lengths));


end