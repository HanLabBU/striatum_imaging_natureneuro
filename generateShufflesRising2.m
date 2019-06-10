function generateShufflesRising2(mouseno, numShuffles)
mouseData = loadMouse(mouseno);
if nargin < 2
    numShuffles = 5000;
end
parpool('local',20);
for m=1:numel(mouseData)
    currMouse = mouseData(m);
    %curr msn traces

    currMSN = getRisingPhase(currMouse,'msn');
    
    currCHI = getRisingPhase(currMouse,'chi');
   
    currFSI = getRisingPhase(currMouse,'fsi');
    shufflesMSN = cell(size(currMSN,2),1);
    parfor r=1:size(currMSN,2)
        shufflesMSN{r} = sparse(simTraces(currMSN(:,r),numShuffles));
    end
    shufflesMSN = reshapeSpCell(shufflesMSN);
    save(['shuffles/rising_phase/' currMouse.suffix '_msn_rp2.mat'],'shufflesMSN','-v7.3');
    clear shufflesMSN
    
    if ~isempty(currCHI)
        shufflesCHI = cell(size(currCHI,2),1);
        parfor r=1:size(currCHI,2)
            shufflesCHI{r} = sparse(simTraces(currCHI(:,r),numShuffles));
        end
        shufflesCHI = reshapeSpCell(shufflesCHI);
        save(['shuffles/rising_phase/' currMouse.suffix '_chi_rp2.mat'],'shufflesCHI','-v7.3');
    end
    
    if ~isempty(currFSI)
        shufflesFSI = cell(size(currFSI,2),1);
        parfor r=1:size(currFSI,2)
            shufflesFSI{r} = sparse(simTraces(currFSI(:,r),numShuffles));
        end
        shufflesFSI = reshapeSpCell(shufflesFSI);
        save(['shuffles/rising_phase/' currMouse.suffix '_fsi_rp2.mat'],'shufflesFSI','-v7.3');
    end
    clear shufflesCHI shufflesFSI
    disp('done with mouse');
end
delete(gcp('nocreate'));
end

function xOut = simTraces(x,reps)
    segs = activeSegmentsSE(x);
    if isempty(segs{1})
        xOut = zeros(length(x),reps);
        return
    end
    xOut = cell(reps,1);
    tic
    for r=1:reps
        xOut{r} = circshift(x,randi(length(x)));
    end
    toc
    xOut = cat(2,xOut{:});
end