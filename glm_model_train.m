function [cout, Ypred, Y] = glm_model_train(mouseno, interneuron_type, numiters)
    %first, fit model to data
    suffix = mouseSuffix(mouseno);
    num_folds = 10;
    c_all = cell(numel(suffix),1);
    Ypred = cell(numel(suffix),1);
    Y = cell(numel(suffix),1);
    for m=1:numel(suffix)
        currMouse = loadMouse({suffix{m}});
        traces = allFluor(currMouse);
        tracesMSN = traces.msn;
        tracesInt = traces.(interneuron_type);
        
        if isempty(tracesInt)
            fprintf('Skipping mouse %s\n',currMouse.suffix);
            continue
        end
        taxis = currMouse.taxis;
        taxis = taxis-taxis(1);
        y = bin(currMouse.speed,0.1,taxis);
        c_msn_all = nan(numiters,num_folds);
        tic
        Xall = bin(tracesMSN,.1,taxis);
        for i=1:numiters
            x = mean(Xall(:,randi(size(tracesMSN,2),size(tracesInt,2),1)),2);
            x = zscore(x);
            X = cat(2,ones(size(x,1),1),x);
            c_msn_all(i,:) = kfoldvalidate(X,y,num_folds);
            if i==1
                Xsampmsn = X;
            end
        end
        c_all{m} = c_msn_all;
        
        % now predict yvals
        b = regress(y,Xsampmsn);
        ypred.msn = Xsampmsn*b;
        
        Ypred{m} = ypred.msn;
        Y{m} = y;
        fprintf('Done with mouse %s\n',currMouse.suffix);
    end
    cout.all = c_all;

end
