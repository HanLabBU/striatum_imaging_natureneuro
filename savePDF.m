function savePDF(f, tit)
fp = fileparts(tit);
if ~exist(fp)
    mkdir(fp);
end
% savefig(f, [tit(1:end-4) '.fig']);


print(f, tit,'-dpdf','-bestfit');
print(f, [tit(1:end-4) '.png'], '-dpng');
end