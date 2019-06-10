function [b,test_data, X_all, y_all] = regression_model_train_bin(mouseno, maxlag, interneuron_type, fields)
    %first, fit model to data
    offset = (maxlag-1)/2;
    suffix = mouseSuffix(mouseno);
    test_data = cell(length(suffix),1);
    num_folds = 10;
    b = cell(length(suffix),num_folds);
    X_all = cell(numel(suffix),1);
    y_all = cell(numel(suffix),1);
    for m=1:numel(suffix)
        currMouse = loadMouse({suffix{m}});
        tracesMSN = cat(2,currMouse.activationStateMSN,currMouse.actStateBroadMSN);
        tracesMSN = risingPhase(cat(2,currMouse.tracesMSN, currMouse.broadTracesMSN),tracesMSN);
        %include the next line?
%         tracesMSN = removeMAMinMat(tracesMSN, 10, 500);

        fluor = (sum(tracesMSN,2)); % use fsis and chis too?
        switch interneuron_type
            case 'fsi'
                trInt = currMouse.activationStateFSI;
                trBrInt = currMouse.actStateBroadFSI;
                trIntAll = cat(2,trInt, trBrInt);
                trIntAll = risingPhase(cat(2,currMouse.tracesFSI, currMouse.broadTracesFSI),trIntAll);
                fluor_int = (sum(trIntAll,2));
            case 'chi'
                trInt = currMouse.activationStateCHI;
                trBrInt = currMouse.actStateBroadCHI;
                trIntAll = cat(2,trInt, trBrInt);
                trIntAll = risingPhase(cat(2,currMouse.tracesCHI, currMouse.broadTracesCHI),trIntAll);
                fluor_int = (sum(trIntAll,2));
        end
        
        if isempty(trInt) && isempty(trBrInt)
            continue
        end
        ind_start = offset+1;
        ind_end = length(fluor)-offset;
        X = [];
        for f=1:numel(fields)
            if strcmp(fields{f},'int')
                currfield = fluor_int;
            elseif strcmp(fields{f},'msn')
                tr = tracesMSN(:,randi(size(tracesMSN,2),size(trIntAll,2),1));
                fluor = fluor+sum(trIntAll,2)-sum(tr,2);
                currfield = sum(tr,2);
            elseif strcmp(fields{f},'accel')
                currfield = abs([0; diff(currMouse.speed)]);
            elseif strcmp(fields{f}, 'inter')
                currfield = abs(currMouse.rot).*currMouse.speed;
            elseif strcmp(fields{f},'rot')
                currfield = abs(currMouse.rot);
            elseif strcmp(fields{f},'onset')
                peaks = findPeaksManual(currMouse.speed, currMouse.dt);
                currfield = time_since_last_peak(peaks, length(currMouse.speed))';
                currfield = currfield(ind_start:ind_end);
                X = cat(2,X,currfield);
                continue
            elseif strcmp(fields{f},'intercept')
                currcoeffs = ones(ind_end-ind_start+1,1);
            else
                currfield = currMouse.(fields{f});
            end
            if ~strcmp(fields{f},'intercept')
                currcoeffs = zscore(construct_history_terms(currfield,maxlag));
            end
            X = cat(2,X,currcoeffs);
        end
        y = fluor(ind_start:ind_end);
        taxis = currMouse.taxis(ind_start:ind_end);
        taxis = taxis-taxis(1);
        bins = 0:0.1:taxis(end)+.09;
        
        X = bin(X,bins,taxis);
        y = bin(y,bins,taxis);
        
        %set aside 10% for testing. Maybe try training and testing all
        %around?
        test_len = floor(length(y)/num_folds);
        fold_steps = 1:(test_len-1):length(y);
        for j=1:length(fold_steps)-1
            train_inds = setdiff(1:length(y),fold_steps(j):fold_steps(j+1));
            test_inds = fold_steps(j):fold_steps(j+1);
            ytrain = y(train_inds);
            xtrain = X(train_inds,:);
            b{m,j} = regress(ytrain,xtrain);
            test_data{m}(j).X = X(test_inds,:);
            test_data{m}(j).Y = y(test_inds);
        end
%         figure;
%         plot(y,'b');
%         hold on;
%         yyaxis right;
%         plot(X*nanmean(cat(2,b{m,:}),2),'r');
%         legend('actual','predicted');
%         title([suffix{m} '']);
        X_all{m} = X;
        y_all{m} = y;
    end
end

function Xout = bin(X, edges, taxis)
    Xout = nan(length(edges)-1,size(X,2));
    for b=1:length(edges)-1
        inds = taxis >= edges(b) & taxis < edges(b+1);
        Xout(b,:) = nanmean(X(inds,:),1);
    end
end