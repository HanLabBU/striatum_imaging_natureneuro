% Computes the mean number of spikes per second
function allEventPr = meanActiveRegions(mouse)
    suffixList = mouseSuffix(mouse);
    numSessions = numel(suffixList);
  
    
    allEventPr = struct('chi',[],'msn',[],'fsi',[]);
    
    for mouse=1:numSessions
        allMouseData = loadMouse(suffixList(mouse));
            dt = allMouseData.dt;
        %cholinergics and then msns
        actState = allActive(allMouseData);
        fields = fieldnames(actState);
        for f=1:numel(fields)
            allEventPr(mouse).(fields{f}) = eventsPerSec(actState.(fields{f}), dt);
        end
    end

end