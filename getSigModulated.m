function sigInds = getSigModulated(suffix,celltype)


    allMouseData = loadMouse({suffix});
    speed = allMouseData.speed;
    movementTransition1 = findPeaksManual(speed, allMouseData.dt);
    movementTransition = findPeaksManual2(speed, allMouseData.dt);
    assert(isequaln(movementTransition1,movementTransition),'find peaks manual gives different results!!!!');
    movementTransition = indices2Indicator(movementTransition, length(speed));
   
    traces = allFluor(allMouseData);
    
    peakMovement = peakTriggeredAverage(traces.(celltype), movementTransition, 50,0);   

    peakMovement = squeeze(nanmean(peakMovement,2));
    
    [sigInds.pos, sigInds.neg] = (findSigDifInds(peakMovement,40));
    sig = sigInds;
end
