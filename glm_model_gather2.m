function tbl = glm_model_gather2(mouseno)
    %first, fit model to data
    suffix = mouseSuffix(mouseno);

    speeds = [];
    traces = [];
    roi_no = [];
    roi_type = [];
    mouseno = [];
    speedlag1 = [];
    speedlag2 = [];
    roi_start = 0;
    for m=1:numel(suffix)
        currMouse = loadMouse({suffix{m}});
        tracescurr = allFluor(currMouse);
        tracesMSN = detrend(tracescurr.msn);
        tracesInt = detrend(cat(2,tracescurr.chi,tracescurr.fsi));
      
        y = currMouse.speed; % use fsis and chis too?

        tracesMSN = zscore(bin(tracesMSN,0.1,currMouse.taxis));
        
        tracesMSN = tracesMSN(3:end,:);
        
        roi_msns = repmat(1:size(tracesMSN,2),size(tracesMSN,1),1)+roi_start;
        roi_start = roi_start + size(roi_msns,2);
        
        
        tracesInt = zscore(bin(tracesInt,0.1,currMouse.taxis));
        tracesInt = tracesInt(3:end,:);
        roi_ints = repmat(1:size(tracesInt,2),size(tracesInt,1),1)+roi_start;
        
        roi_start = roi_start + size(roi_ints,2);
        
        y = zscore(bin(y,0.1,currMouse.taxis));
        speedlag1 = cat(1,speedlag1,repmat(y(2:end-1),size(tracesMSN,2)+size(tracesInt,2),1));
        speedlag2 = cat(1,speedlag2,repmat(y(1:end-2),size(tracesMSN,2)+size(tracesInt,2),1));
        y = y(3:end);
        
        currTraces = cat(1,tracesMSN(:),tracesInt(:));
        traces = cat(1,traces,currTraces);
        
        speeds = cat(1,speeds(:),repmat(y(:),size(tracesMSN,2)+size(tracesInt,2),1));
        roi_no = cat(1,roi_no(:),roi_msns(:),roi_ints(:));
        
        mouseno = cat(1,mouseno,repmat(nominal(suffix{m}),length(currTraces),1));
        
        if currMouse.isCHI
            roi_type = cat(1,roi_type,repmat(nominal('msn'),numel(tracesMSN),1),repmat(nominal('chi'),numel(tracesInt),1));
        else
            roi_type = cat(1,roi_type,repmat(nominal('msn'),numel(tracesMSN),1),repmat(nominal('fsi'),numel(tracesInt),1));
        end
        fprintf('Done with mouse %s\n',currMouse.suffix);
    end
    assert(length(unique(roi_no)) == 7885);
   tbl = table(speeds,speedlag1,speedlag2, traces, roi_no, roi_type, mouseno);
end