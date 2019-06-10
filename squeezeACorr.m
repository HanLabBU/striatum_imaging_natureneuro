function corrdataout = squeezeACorr(corrdata)    
[corrdataout.msnmsn.rho, corrdataout.msnmsn.zval] = ...
    meanPairVal(corrdata.msnmsn.rho, corrdata.msnmsn.zvals);
corrdataout.msnmsn.d = lowerTriVals(corrdata.msnmsn.d);
corrdataout.msnmsn.d2 = lowerTriValsCell(corrdata.msnmsn.d2);

if ~isempty(corrdata.chichi)
     [corrdataout.chichi.rho, corrdataout.chichi.zval] = ...
        meanPairVal(corrdata.chichi.rho, corrdata.chichi.zvals);
    corrdataout.chichi.d = lowerTriVals(corrdata.chichi.d);
    corrdataout.chichi.d2 = lowerTriValsCell(corrdata.chichi.d2);

    [corrdataout.msnchi.rho, corrdataout.msnchi.zval] = meanPairVal2(...
        corrdata.msnchi.rho,corrdata.chimsn.rho,corrdata.msnchi.zvals,corrdata.chimsn.zvals);
    corrdataout.msnchi.d = corrdata.msnchi.d(:);
    corrdataout.msnchi.d2 = corrdata.msnchi.d2(:);
else
    corrdataout.chichi = [];
    corrdataout.msnchi = [];
end
if ~isempty(corrdata.fsifsi)
     [corrdataout.fsifsi.rho, corrdataout.fsifsi.zval] = ...
        meanPairVal(corrdata.fsifsi.rho, corrdata.fsifsi.zvals);
    corrdataout.fsifsi.d = lowerTriVals(corrdata.fsifsi.d);
    corrdataout.fsifsi.d2 = lowerTriValsCell(corrdata.fsifsi.d2);

    [corrdataout.msnfsi.rho, corrdataout.msnfsi.zval] = meanPairVal2(...
        corrdata.msnfsi.rho,corrdata.fsimsn.rho,corrdata.msnfsi.zvals,corrdata.fsimsn.zvals);
    corrdataout.msnfsi.d = corrdata.msnfsi.d(:);
    corrdataout.msnfsi.d2 = corrdata.msnfsi.d2(:);
else
    corrdataout.fsifsi = [];
    corrdataout.msnfsi = [];
end

end