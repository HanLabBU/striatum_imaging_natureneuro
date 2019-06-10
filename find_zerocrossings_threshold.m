function zc = find_zerocrossings_threshold(rotation)
threshold = 1;
% current sign: is rotation positive
currsig = rotation(1) > 0;
% initialize zeros
zc = zeros(length(rotation),1);
% sufficient_magnitude = (abs(rotation(1)) > 1);
sufficient_magnitude = (abs(rotation(1)) > threshold);
% has not crossed here
zc(1) = nan;
% for each index in rotation
for i=2:(length(rotation))
    if rotation(i) == 0 % if zero, ignore
        continue
    end
    % see if crosses magnitude. if it does, mark it
    if abs(rotation(i)) > threshold
        sufficient_magnitude = 1;
    end
%     if current index is not the same sign, and it has reached sufficient
%     magnitude, mark point. If not same sign reset sufficient magnitude
    if currsig ~= (rotation(i) > 0)
        if sufficient_magnitude
            zc(i) = 1;
            currsig = (rotation(i) > 0);
            sufficient_magnitude = 0;
        else % if hasn't reached significant magnitude
            currsig = (rotation(i) > 0);
            sufficient_magnitude = 0;
        end
    end
end
    
    
end