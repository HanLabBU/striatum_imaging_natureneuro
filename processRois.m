function R = processRois(R, data)

    R = fixFrameNumbers(R); % shouldn't do anything

    R = R.updateProperties(); % shouldn't do anything

    Xraw = makeTraceFromVid(R,data); % makes traces from unique pixels

    % FILTER AND NORMALIZE TRACES AFTER COPYING TRACE TO RAWTRACE
    for k=1:numel(R)		
        R(k).TraceType.raw = Xraw(:,k);
    end

    R.makeBoundaryTrace % draws boundary trace

end