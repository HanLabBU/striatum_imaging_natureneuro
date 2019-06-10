function writeCellCounts2Fi(fi,cc)


fprintf(fi,'---------------------------------------------\n');

fprintf(fi,'Avg +/- SEM ROIs, all: %d +/- %d \n', nanmean([cc.all]),serrMn([cc.all]'));
fprintf(fi,'Avg +/- SEM ROIs, CHI animals: %d +/- %d \n', nanmean([cc([cc.isCHI]).all]),serrMn([cc([cc.isCHI]).all]'));
fprintf(fi,'Avg +/- SEM ROIs, FSI animals: %d +/- %d \n', nanmean([cc(~[cc.isCHI]).all]),serrMn([cc(~[cc.isCHI]).all]'));

fprintf(fi,'Avg +/- SEM MSN, all: %d +/- %d \n', nanmean([cc.msn]),serrMn([cc.msn]'));
fprintf(fi,'Avg +/- SEM MSN, CHI animals: %d +/- %d \n', nanmean([cc([cc.isCHI]).msn]),serrMn([cc([cc.isCHI]).msn]'));
fprintf(fi,'Avg +/- SEM MSN, FSI animals: %d +/- %d \n', nanmean([cc(~[cc.isCHI]).msn]),serrMn([cc(~[cc.isCHI]).msn]'));
fprintf(fi,'Avg +/- SEM CHI: %d +/- %d \n', nanmean([cc([cc.isCHI]).chi]),serrMn([cc([cc.isCHI]).chi]'));
fprintf(fi,'Avg +/- SEM FSI: %d +/- %d \n', nanmean([cc(~[cc.isCHI]).fsi]),serrMn([cc(~[cc.isCHI]).fsi]'));
fprintf(fi,'---------------------------------------------\n');

end