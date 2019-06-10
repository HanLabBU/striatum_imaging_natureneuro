function [cout, sample_info] = glm_model_train_single_siginds(mouseno, interneuron_type,posorneg)
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
        % load traces
        currMouse = loadMouse({suffix{m}});
        traces = allFluor(currMouse);
        tracesMSN = traces.msn;
        
        % trim interneuron traces to only those positively or negatively
        % modulated
        if exist('posorneg','var')
           siginds = getSigModulated(suffix{m},interneuron_type);
           traces.(interneuron_type) = traces.(interneuron_type)(:,~~siginds.(posorneg));
        end
        
        tracesInt = traces.(interneuron_type);
        
        if isempty(tracesInt)
            fprintf('Skipping mouse %s\n',currMouse.suffix);
            continue
        end
        
        % bin all of the values (speed and fluorescence)
        taxis = currMouse.taxis;
        taxis = taxis-taxis(1);
        y = currMouse.speed;
        y = bin(y,.1,taxis);
        tracesMSN = bin(tracesMSN,.1,taxis);
        tracesInt = bin(tracesInt,.1,taxis);
       
        
        samples.y = y;
        % cross validate and store
        [c, samples.msn] = kfoldvalidate_all(tracesMSN,y,num_folds);
        [c_int, samples.int] = kfoldvalidate_all(tracesInt, y, num_folds);
        [c_msn_all, samples.msn.all] = kfoldvalidate_all(mean(tracesMSN,2),y,num_folds);
        [c_int_all, samples.int.all] = kfoldvalidate_all(mean(tracesInt,2),y,num_folds);
        
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