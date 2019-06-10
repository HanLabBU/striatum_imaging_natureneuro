function [peakShape, segments, risetimes] = peakFormReduxRiseTimes(traces, activityTraces)
    %get mean baselines
    actSegs = activeSegments(activityTraces); %get all active time points
    peakShape = cell(numel(actSegs),1); %this will store shapes for each peak
    segments = cell(numel(actSegs),1);
    risetimes = cell(numel(actSegs),1);
    
    dt = .0469; % add this as third argument
    assert(size(traces,2) == numel(actSegs),'trace number and segment number dont match');
    for roi=1:size(traces,2)        
        %get the active segments for the current roi
        currSegments = actSegs{roi};
        trace = traces(:,roi);
        %initialize variables to store info for each roi
        roiSegShape = cell(size(currSegments,1),1);
        risetimescurr = cell(size(currSegments,1),1);
        roiSegs = [];
        if ~isempty(currSegments)
            segStarts = currSegments(:,1);
            segFins = currSegments(:,2)+1;
            for seg=1:size(currSegments,1)
                segStart = segStarts(seg);
                segEnd = segFins(seg);
                
                % compute risetime
                [~,i] = max(trace(segStart:segEnd-1));
                risetimescurr{seg} = i;
                
                %compute baseline
                blStart = max(1,segStart-20);
                blEnd = segStart-1;
                blTrace = trace(blStart:blEnd);
                actBLTrace = activityTraces(blStart:blEnd,roi);
                bl = mean(blTrace(~actBLTrace));
                assert(~isnan(bl),'baseline is nan!');
                roiSegShape{seg} = trace(segStart:segEnd)-bl;
                roiSegs = cat(1,roiSegs,[segStart segEnd]);
            end
        else
            roiSegShape = [];
            roiSegs = [];
            risetimescurr = [];
        end
        risetimes{roi} = risetimescurr;
        peakShape{roi} = roiSegShape;
        segments{roi} = roiSegs;
    end
end