function p = ztestpw(mu,err)
c = nchoosek(1:length(mu),2);
p = nan(size(c,1),1);
z = nan(size(c,1),1);
for i=1:size(c,1)
    num = mu(c(i,1))-mu(c(i,2));
    denom = sqrt(err(c(i,1))^2+err(c(i,2))^2);
    z(i) = num/denom;
    p(i) = min(normcdf(z(i)),1-normcdf(z(i)))*2;
end
p = cat(2,c,p(:),z(:));
end