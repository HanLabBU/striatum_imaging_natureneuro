function addCorrStatsCombo2(fi,stats,inttype)
fprintf(fi,'---------------------------------\n');
fprintf(fi,'ROI-ROI Pearson correlation statistics\n');
fprintf(fi,'The following are for %s mice\n',inttype);
fprintf(fi,'------\nClose vs far:\n');
fprintf(fi,'\nClose vs control (sign test):');
write_signtest_2_file(fi,stats.diff.incontrol.p,stats.diff.incontrol.st);
fprintf(fi,'\nClose vs far (sign test):');
write_signtest_2_file(fi,stats.diff.inout.p,stats.diff.inout.st);
fprintf(fi,'\nFar vs control (sign test):\n');
write_signtest_2_file(fi,stats.diff.outcontrol.p,stats.diff.outcontrol.st);
fprintf(fi,'\nFar control vs close control (sign test):\n');
write_signtest_2_file(fi,stats.diff.outincontrol.p,stats.diff.outincontrol.st);


fprintf(fi,'------\nHigh vs Low speed:\n');
fprintf(fi,'\nHigh speed vs control (sign test)');
write_signtest_2_file(fi,stats.hilo.hicontrol.p,stats.hilo.hicontrol.st);
fprintf(fi,'\nHigh speed vs low speed (sign test)');
write_signtest_2_file(fi,stats.hilo.hivslo.p,stats.hilo.hivslo.st);
fprintf(fi,'\nLow speed vs control (sign test)');
write_signtest_2_file(fi,stats.hilo.locontrol.p,stats.hilo.locontrol.st);
fprintf(fi,'\nHigh speed control vs low speed control (sign test)');
write_signtest_2_file(fi,stats.hilo.control.p,stats.hilo.control.st);
fprintf(fi,'---------------------------------\n');

end
