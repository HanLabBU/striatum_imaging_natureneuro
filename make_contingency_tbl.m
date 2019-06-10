function tbl = make_contingency_tbl(prop,ntot)
tbl = nan(length(prop),2);
tbl(:,1) = prop.*ntot;
tbl(:,2) = (1-prop).*ntot;
end