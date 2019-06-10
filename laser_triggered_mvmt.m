function [spd, mouseindicator, trial] = laser_triggered_mvmt(metadata,radius,celltype,mvmt,absval)
spd = [];
mouseindicator = [];
trial = [];
mousenos = {};
for m=1:numel(metadata)
    mousenos = cat(1,mousenos,{metadata(m).suffix(1:4)});
end

% [~,~,mouseid] = unique(mousenos);
mouseid = categorical(mousenos);

for m=1:numel(metadata)
   if (strcmp(celltype,'chi') && metadata(m).isCHI) || ...
           (strcmp(celltype,'fsi') && ~metadata(m).isCHI) || strcmp(celltype,'all')
       mousedata = loadAndFormatPreMouseDataSpeedOnly(metadata(m));
       peaks = [diff([0, mousedata.laser]) ==1]';

       movement = mousedata.(mvmt);
       movement = movement(:);
       if absval
           movement = abs(movement);
       end
       
       curr_spd = squeeze(peakTriggeredAverage(movement,peaks,radius,0)); 
       mouseindicator = cat(1,mouseindicator,repmat(mouseid(m),size(curr_spd,2),1));
       trial = cat(1,trial,(1:size(curr_spd,2))');
       spd = cat(2,spd,(curr_spd));
   end
end




end