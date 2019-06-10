function locs = findVelocityPeaks(speed, threshold)
        
        [peaks,locs] = findpeaks(speed);
        locs = locs(peaks > threshold);
%         locs = find(speed == max(speed));
end