function [corrdataout] = squeezeACorrCellIDLaser(corrdata)

[corrdataout.msnlaser.rho, corrdataout.msnlaser.zval] = meanPairVal2(...
corrdata.msnlaser.rho,corrdata.lasermsn.rho,corrdata.msnlaser.zvals,corrdata.lasermsn.zvals);

end