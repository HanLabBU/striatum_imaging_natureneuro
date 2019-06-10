function [spd, mouseindicator, trial] = laser_triggered_mvmt_hilo(metadata,radius,celltype,mvmt,absval)
spd = struct('hi',[],'lo',[]);

mouseindicator = struct('hi',[],'lo',[]);

trial = struct('hi',[],'lo',[]);

% get mouse names
mousenos = {};
for m=1:numel(metadata)
    mousenos = cat(1,mousenos,{metadata(m).suffix(1:4)});
end

% [~,~,mouseid] = unique(mousenos);
mouseid = categorical(mousenos);

for m=1:numel(metadata)
   if (strcmp(celltype,'chi') && metadata(m).isCHI) || ...
           (strcmp(celltype,'fsi') && ~metadata(m).isCHI) || strcmp(celltype,'all')
       % load and format data
       mousedata = loadAndFormatPreMouseDataSpeedOnly(metadata(m));
       % add speed info
       mousedata = addSpeedInfo(mousedata,1,5);
       peaks = [diff([0, mousedata.laser]) ==1]';

       movement = mousedata.(mvmt);
       movement = movement(:);
        if absval
            movement = abs(movement);
        end
       % get high peaks and low peaks
       hipeaks = peaks_in_segments(mousedata.hiSpdSustainSegs, peaks);
       lopeaks = peaks_in_segments(mousedata.loSpdSustainSegs, peaks);

       curr_spd.hi = squeeze(peakTriggeredAverage(movement,hipeaks,radius,0)); 
       spd.hi = cat(2,spd.hi,(curr_spd.hi));
       
       curr_spd.lo = squeeze(peakTriggeredAverage(movement,lopeaks, radius,0));
       spd.lo = cat(2,spd.lo,(curr_spd.lo));
       
        mouseindicator.hi = cat(1,mouseindicator.hi,repmat(mouseid(m),size(curr_spd.hi,2),1));
        mouseindicator.lo = cat(1,mouseindicator.lo,repmat(mouseid(m),size(curr_spd.lo,2),1));
        
       trial.lo = cat(1,trial.lo,(1:size(curr_spd.lo,2))');
      trial.hi = cat(1,trial.hi,(1:size(curr_spd.hi,2))');
       
   end
end

end


function peaksout = peaks_in_segments(segments, peaks)
peaksout = zeros(size(peaks));
peaks = find(peaks); % get peak indices

peak_inds = arrayfun(@(x) any(x >= segments(:,1) & (x <= segments(:,2))), peaks);
peaksout(peaks(peak_inds)) = 1; 
end