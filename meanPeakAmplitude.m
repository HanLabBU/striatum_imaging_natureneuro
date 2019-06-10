function [peakAmps, peakAmpsHi, peakAmpsLo] = meanPeakAmplitude(mouseNum, pctileLo, pctileHi)
    suffixList = mouseSuffix(mouseNum);
    
    numSessions = numel(suffixList);
    peakAmps = struct('msn',[],'chi',[]);
    peakAmpsHi = struct('msn',[],'chi',[]);
    peakAmpsLo = struct('msn',[],'chi',[]);
    
    for mouse=1:numSessions
        allMouseData = loadMouse(suffixList(mouse));
        allMouseData = addSpeedInfo(allMouseData, pctileLo, pctileHi);
        
      
        
        hiSegs = allMouseData.hiSpdSustainSegs;
        loSegs = allMouseData.loSpdSustainSegs;
        
        traces = allFluor(allMouseData);
        actstates= allActive(allMouseData);
        fields = fieldnames(traces);
        for f = 1:numel(fields)

            [peakShape,~, segs] = peakFormRedux(traces.(fields{f}), actstates.(fields{f}));


            peakAmps(mouse).(fields{f}) = peakAmplitudes(peakShape);

            peakAmpsHi(mouse).(fields{f}) = peakAmpsInSeg(peakAmps(mouse).(fields{f}), segs, hiSegs);

            peakAmpsLo(mouse).(fields{f}) = peakAmpsInSeg(peakAmps(mouse).(fields{f}), segs, loSegs);
        end       
    end
end