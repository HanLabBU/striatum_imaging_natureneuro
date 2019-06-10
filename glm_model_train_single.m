function [cout, sample_info] = glm_model_train_single(mouseno, interneuron_type)
    %first, fit model to data
    suffix = mouseSuffix(mouseno);
    num_folds = 10;
    % initialize output variables
    c_all = cell(numel(suffix),1);
    c_all_int = cell(numel(suffix),1);
    c_ind = cell(numel(suffix),1);
    c_ind_int = cell(numel(suffix),1);
    
    sample_info = cell(numel(suffix),1);
    for m=1:numel(suffix)
        % load mouse
        currMouse = loadMouse({suffix{m}});
%         load traces
        traces = allFluor(currMouse);
        tracesMSN = traces.msn;
        tracesInt = traces.(interneuron_type);
        if isempty(tracesInt)
            fprintf('Skipping mouse %s\n',currMouse.suffix);
            continue
        end
        
        taxis = currMouse.taxis;
        taxis = taxis-taxis(1);
        y = currMouse.speed;
        % bin speed and fluorescence values
        y = bin(y,.1,taxis);
        tracesMSN = bin(tracesMSN,.1,taxis);
        tracesInt = bin(tracesInt,.1,taxis);
       
        
        samples.y = y;
        
        % kfold validation for all individual traces
        [c, samples.msn] = kfoldvalidate_all(tracesMSN,y,num_folds);
        [c_int, samples.int] = kfoldvalidate_all(tracesInt, y, num_folds);
        [c_msn_all, samples.msn.all] = kfoldvalidate_all(mean(tracesMSN,2),y,num_folds);
        [c_int_all, samples.int.all] = kfoldvalidate_all(mean(tracesInt,2),y,num_folds);
        
        % store output
        c_ind{m} = c;
        c_ind_int{m} = c_int;
        c_all{m} = c_msn_all;
        c_all_int{m} = c_int_all;
        sample_info{m} = samples;
        fprintf('Done with mouse %s\n',currMouse.suffix);
    end
    cout.ind = c_ind;
    cout.indint = c_ind_int;
    cout.all = c_all;
    cout.allint = c_all_int;
end