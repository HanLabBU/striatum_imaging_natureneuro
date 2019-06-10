function str = neurcat(str, strtemp)
f = fieldnames(str);
for j=1:length(f)
    str.(f{j}) = cat(1,str.(f{j}),strtemp.(f{j}));
end
end
