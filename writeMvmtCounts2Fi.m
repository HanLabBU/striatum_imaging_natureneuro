function writeMvmtCounts2Fi(fi,mc)

fprintf(fi,'---------------------------------------------\n');

fprintf(fi,'Avg +/- SEM Onset events, all: %d +/- %d \n', nanmean([mc.onset]),serrMn([mc.onset]'));
fprintf(fi,'Avg +/- SEM Onset events, CHI animals: %d +/- %d \n', nanmean([mc([mc.isCHI]).onset]),serrMn([mc([mc.isCHI]).onset]'));
fprintf(fi,'Avg +/- SEM Onset events, FSI animals: %d +/- %d \n\n', nanmean([mc(~[mc.isCHI]).onset]),serrMn([mc(~[mc.isCHI]).onset]'));

fprintf(fi,'Avg +/- SEM Offset events, all: %d +/- %d \n', nanmean([mc.offset]),serrMn([mc.offset]'));
fprintf(fi,'Avg +/- SEM Offset events, CHI animals: %d +/- %d \n', nanmean([mc([mc.isCHI]).offset]),serrMn([mc([mc.isCHI]).offset]'));
fprintf(fi,'Avg +/- SEM Offset events, FSI animals: %d +/- %d \n\n', nanmean([mc(~[mc.isCHI]).offset]),serrMn([mc(~[mc.isCHI]).offset]'));

fprintf(fi,'Avg +/- SEM VMax events, all: %d +/- %d \n', nanmean([mc.vmax]),serrMn([mc.vmax]'));
fprintf(fi,'Avg +/- SEM VMax events, CHI animals: %d +/- %d \n', nanmean([mc([mc.isCHI]).vmax]),serrMn([mc([mc.isCHI]).vmax]'));
fprintf(fi,'Avg +/- SEM VMax events, FSI animals: %d +/- %d \n\n', nanmean([mc(~[mc.isCHI]).vmax]),serrMn([mc(~[mc.isCHI]).vmax]'));


fprintf(fi,'Avg +/- SEM Hi speed segments, all: %d +/- %d \n', nanmean([mc.hispd]),serrMn([mc.hispd]'));
fprintf(fi,'Avg +/- SEM Hi speed segments, CHI animals: %d +/- %d \n', nanmean([mc([mc.isCHI]).hispd]),serrMn([mc([mc.isCHI]).hispd]'));
fprintf(fi,'Avg +/- SEM Hi speed segments, FSI animals: %d +/- %d \n\n', nanmean([mc(~[mc.isCHI]).hispd]),serrMn([mc(~[mc.isCHI]).hispd]'));

fprintf(fi,'Avg +/- SEM Lo speed segments, all: %d +/- %d \n', nanmean([mc.lospd]),serrMn([mc.lospd]'));
fprintf(fi,'Avg +/- SEM Lo speed segments, CHI animals: %d +/- %d \n', nanmean([mc([mc.isCHI]).lospd]),serrMn([mc([mc.isCHI]).lospd]'));
fprintf(fi,'Avg +/- SEM Lo speed segments, FSI animals: %d +/- %d \n\n', nanmean([mc(~[mc.isCHI]).lospd]),serrMn([mc(~[mc.isCHI]).lospd]'));

fprintf(fi,'---------------------------------------------\n');
end