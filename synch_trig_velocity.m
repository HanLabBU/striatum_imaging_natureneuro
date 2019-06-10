function [vout, msnout, chiout] = synch_trig_velocity(mouseno,radius,celltype)

suffix = mouseSuffix(mouseno);
vout = []; chiout = []; msnout = [];
trigpointsall = [];
for m=1:length(suffix)
    mousedata = loadMouse(suffix(m));
%     if strmatch(celltype,'chi')
%         if ~mousedata.isCHI
%             continue
%         end
%     end
%     
    rp = allRising(mousedata);
    fluor = allFluor(mousedata);
    
    synch = sum(rp.msn,2);
    trigpoints = synchtrig(synch);
    
    curr = peakTriggeredAverage(mousedata.speed, trigpoints,radius,0);
%     curr = nanmean(curr,2);
    
    chi = peakTriggeredAverage(rp.chi, trigpoints, radius, 0);
    msn = peakTriggeredAverage(rp.msn, trigpoints, radius, 0);
    
    vout = cat(2,vout,curr);
    msnout = cat(2,msnout,secondsqueeze(nanmean(msn,2)));
    chiout = cat(2,chiout,secondsqueeze(nanmean(chi,2)));
    trigpointsall = cat(1,trigpointsall,sum(trigpoints));
end
end

function xout = secondsqueeze(X)
[x1,~,x2] = size(X);
xout = reshape(X,[x1,x2]);
end

function tpout = synchtrig(synch)
%find points were changes from < 50 to > 50 %
% synch = synch-mean(synch); % change to zero mean
synch = zscore(synch);
ispos = (synch > 2); %find when transitions from below to above avg
%now, find maxima in this interval
tp = [];
segs = activeSegmentsSE(ispos);
segs = segs{1};
% smooth_segs?
for s=1:size(segs,1)
    [~,i] = max(synch(segs(s,1):segs(s,2)));
    tp = cat(1,tp,i+segs(s,1)-1);
end
tpout = zeros(size(synch));
tpout(tp) = deal(1);
end
