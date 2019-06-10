function [corrdata] = meanPairwiseAssymCorr2LaserEpochs(metadata) %are msns more correlated with each other or with cholinergics?
    for m=1:numel(metadata)
        corrdata = struct('msnlaser',[],'lasermsn',[]);
        currMouse = loadMouseLaser(metadata(m));
        suffix = metadata(m).suffix;
        %curr msn traces
        
        rising = allRisingLaser(currMouse);
        
        load([suffix '_msn_rp2_laser.mat']);

        shuffles.laser = repmat({currMouse.laserIndices},1,numel(shufflesMSN));
        
        [rho, zv] = assymCorr5(currMouse.laserIndices,rising.msn,shuffles.laser,shufflesMSN);
        corrdata.lasermsn.rho = rho;
        corrdata.lasermsn.zvals = zv;

        [rho, zv] = assymCorr5(rising.msn,currMouse.laserIndices,shufflesMSN,shuffles.laser);
        corrdata.msnlaser.rho = rho;
        corrdata.msnlaser.zvals = zv;
        
        save(['corrdata/' suffix '_pairwiseasymmcorr_rp2_laser_epochs.mat'],'corrdata','-v7.3');
    end
end
