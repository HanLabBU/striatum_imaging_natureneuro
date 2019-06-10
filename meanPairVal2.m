

%function returns column 1 of rho1, then column 2, then column 3....
function [rout, zout]= meanPairVal2(rho1, rho2, zval1, zval2)
    rho2 = rho2';
    sz = size(rho2);
    rout = mean(cat(3,rho1,rho2),3);
    rout = rout(:);
    if nargin > 2
        zval2 = permute(zval2,[2 1 3]);
        zout = mean(cat(4, zval1, zval2),4);
        zout = reshape(zout,[size(zout,1)*size(zout,2),size(zout,3)]);
    else
        zout = [];
    end
end