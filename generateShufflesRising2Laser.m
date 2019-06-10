function generateShufflesRising2Laser(metadata, numShuffles)
if nargin < 2
    numShuffles = 5000;
end
parpool('local',20);
for m=1:numel(metadata)
    currMouse = loadMouseLaser(metadata(m));
    %curr msn traces

    rising = allRisingLaser(currMouse);
    
    shufflesMSN = cell(size(rising.msn,2),1);
    parfor r=1:size(rising.msn,2)
        shufflesMSN{r} = sparse(simTraces(rising.msn(:,r),numShuffles));
    end
    shufflesMSN = reshapeSpCell(shufflesMSN);
    save(['shuffles/rising_phase/' metadata(m).suffix '_msn_rp2_laser.mat'],'shufflesMSN','-v7.3');
    clear shufflesMSN
    
    if ~isempty(rising.chi)
        shufflesCHI = cell(size(rising.chi,2),1);
        parfor r=1:size(rising.chi,2)
            shufflesCHI{r} = sparse(simTraces(rising.chi(:,r),numShuffles));
        end
        shufflesCHI = reshapeSpCell(shufflesCHI);
        save(['shuffles/rising_phase/' metadata(m).suffix '_chi_rp2_laser.mat'],'shufflesCHI','-v7.3');
    end
    
    if ~isempty(rising.fsi)
        shufflesFSI = cell(size(rising.fsi,2),1);
        parfor r=1:size(rising.fsi,2)
            shufflesFSI{r} = sparse(simTraces(rising.fsi(:,r),numShuffles));
        end
        shufflesFSI = reshapeSpCell(shufflesFSI);
        save(['shuffles/rising_phase/' metadata(m).suffix '_fsi_rp2_laser.mat'],'shufflesFSI','-v7.3');
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