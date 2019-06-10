function [mdl,st] = laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula,isControl)
radius = 50;
if hilo
    [spd, mouse, trial] = laser_triggered_mvmt_hilo(metadata,radius,genotype,mvmt,absval);
else
    [spd, mouse, trial] = laser_triggered_mvmt(metadata,radius,genotype,mvmt,absval); % use normalized
end
if absval
    absstring = 'abs';
else
    absstring = '';
end
    
if nargin < 9 || isempty(isControl)
   control_string = ''; 
else
    control_string = isControl;
end
    
if hilo
    figure
    plot_laser_triggered_mvmt_box(spd.lo,[genotype '-' absstring mvmt '-lo-speed-' control_string],normalize);
    savePDF(gcf,sprintf('figures/%s/laser_triggered_values_%s.pdf',date,[genotype '-' absstring mvmt '-lo-speed_' control_string]));
    [mdl, st, ~] = make_lasertrigspd_tbl_normalize2(spd.lo, mouse.lo, trial.lo,normalize,formula);
    write_statistics(fi,mdl,st,[genotype '-lo-speed-' control_string],mvmt);
    savePDF(gcf,sprintf('figures/%s/laser_triggered_diagnostics_%s.pdf',date,[genotype '-' absstring mvmt '-lo-speed_' control_string]));

    
    plot_laser_triggered_mvmt_box(spd.hi,[genotype '-' absstring mvmt '-hi-speed-' control_string],normalize);
    savePDF(gcf,sprintf('figures/%s/laser_triggered_values_%s.pdf',date,[genotype '-' absstring mvmt '-hi-speed_' control_string]));
    [mdl, st, ~] = make_lasertrigspd_tbl_normalize2(spd.hi, mouse.hi, trial.hi,normalize,formula);
    write_statistics(fi,mdl,st,[genotype '-hi-speed-' control_string],mvmt);
    savePDF(gcf,sprintf('figures/%s/laser_triggered_diagnostics_%s.pdf',date,[genotype '-' absstring mvmt '-hi-speed_' control_string]));

else
    plot_laser_triggered_mvmt_box(spd,[genotype '-' absstring mvmt '-all-speed-' control_string],normalize);
    savePDF(gcf,sprintf('figures/%s/laser_triggered_values_%s.pdf',date,[genotype '-' absstring mvmt '-all-speed_' control_string]));
    [mdl, st, ~] = make_lasertrigspd_tbl_normalize2(spd, mouse, trial,normalize,formula);
    write_statistics(fi,mdl,st,genotype,mvmt);
    savePDF(gcf,sprintf('figures/%s/laser_triggered_diagnostics_%s.pdf',date,[genotype '-' absstring mvmt '-all-speed_' control_string]));

end
end

function write_statistics(fi,mdl,st,genotype,movement)
% now, write the statistics to a table
fprintf(fi,'--------------------------------\n');
fprintf(fi,sprintf('Laser-triggered %s table, %s\n',movement, genotype));
write_linear_model(fi,mdl);
fprintf(fi,'ANOVA omnibus');
write_linear_model(fi,st.anova);
% now relevant statistics for the model
fprintf(fi,'------------\nF test for main effect of time\n');
fprintf(fi,'F(%d,%d): %d, p=%0.4f\n',st.f.df(1),st.f.df(2),st.f.true,st.f.p);
fprintf(fi,'\n');
fprintf(fi,'Comparisons with initial velocity, Benjamini-hochberg corrected\n');
p = posthoc_benjaminihochberg_raw(st.t.p);
for i=1:length(st.t.true)
    fprintf(fi,'Bin %d:\nt(%d): %d, p=%0.4f\n',i,st.t.df,st.t.true(i),p(i));
end
end