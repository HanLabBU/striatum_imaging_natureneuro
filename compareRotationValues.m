function stats = compareRotationValues(mouseno) %USES circ_stats toolbox
    suffix = mouseSuffix(mouseno);
    mnRotVel = nan(numel(suffix),1);
    isCHI = nan(numel(suffix),1);
    for m=1:numel(suffix)
        currMouse = loadMouse(suffix(m));
        mnRotVel(m) = nanmean(currMouse.rot);
        isCHI(m) = currMouse.isCHI;
    end
   figure
   [n,c] = hist(mnRotVel);
   err = @(p,n) sqrt(p*(1-p)/n);
   bar_err(c,n/sum(n), arrayfun(@(x) err(x/sum(n),sum(n)),n));
   xlabel('Rotation [radians/sec]')
   ylabel('Proportion of sessions');
   title('Rotation; positive = turning right');
    ylim([0 .4])
    stats.chi.left = sum(mnRotVel < 0 & isCHI);
    stats.chi.right = sum(mnRotVel > 0 & isCHI);
    stats.fsi.left = sum(mnRotVel < 0 & ~isCHI);
    stats.fsi.right = sum(mnRotVel > 0 & ~isCHI);
%     [stats.chi2, stats.p, stats.df, stats.yates, stats.tbl] = chi2test(isSig, isCHI, meanRotation);
    stats.st = fisherall(isCHI,mnRotVel);
end


%only need to compute for 1 direction
function st = fisherall(isCHI, meanRotation)
y = zeros(2,2);
y(1,1) = sum( meanRotation > 0 & isCHI);
y(2,1) = sum(meanRotation > 0 & ~isCHI);
y(1,2) = sum(meanRotation < 0 & isCHI);
y(2,2) = sum(meanRotation < 0 & ~isCHI);

[~,st.p,st.st] = fishertest(y);
st.tbl = y;
end

%only need to compute for 1 direction
function [chi2, p, df, yatesused,y] = chi2test(isSig, isCHI, meanRotation)
y = zeros(2,2);
y(1,1) = sum(isSig & meanRotation > 0 & isCHI);
y(2,1) = sum(isSig & meanRotation > 0 & ~isCHI);
y(1,2) = sum(isSig & meanRotation < 0 & isCHI);
y(2,2) = sum(isSig & meanRotation < 0 & ~isCHI);

[chi2, p, df, yatesused] = chi2tbl(y,1);

end