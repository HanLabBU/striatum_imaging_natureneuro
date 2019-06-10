% Computes the mean number of spikes per second
function allEventPr = meanActiveRegionsSegments(mouse, loMvmt, hiMvmt)
    suffixList = mouseSuffix(mouse);
    numSessions = numel(suffixList);
  
    
    allEventPr = struct('chi',[],'msn',[],'fsi',[]);
    
    for mouse=1:numSessions
        allMouseData = loadMouse(suffixList(mouse));
        allMouseData = addSpeedInfo(allMouseData, loMvmt, hiMvmt);
        dt = allMouseData.dt;
        
        %cholinergics and then msns
       actState = allActive(allMouseData);
       
       fields = fieldnames(actState);
       for f=1:numel(fields)
       
        roiact.lo = eventsPerSecSegs(actState.(fields{f}), dt, ...
            allMouseData.loSpdSustainSegs);
        
        roiact.hi = eventsPerSecSegs(actState.(fields{f}), dt,...
            allMouseData.hiSpdSustainSegs);
        
           allEventPr(mouse).(fields{f}) = roiact;
       
       end
    end

end