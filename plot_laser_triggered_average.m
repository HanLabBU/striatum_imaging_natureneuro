function [p, st,st2] = plot_laser_triggered_average(mta,genotype,block,isactivity,normalize)
% average by roi
    radius = (size(mta.msn{1},1)-1)/2;
    dt = 0.0469;
    msn = cellfun(@(x) squeeze(nanmean(x,2)),mta.msn,'uniformoutput',false);
    msn = cat(2,msn{:});
    
    
    tdt = cellfun(@(x) squeeze(nanmean(x,2)),mta.tdt,'uniformoutput',false);
    tdt = cat(2,tdt{:});
    
    preinds = (radius-block+1):radius;
    postinds = (radius+2):(radius+1+block);
    
    % quantification
    [p.msn,st.msn] = signtest_explicit(nanmean(msn(preinds,:),1)',nanmean(msn(postinds,:),1)',0);
    [p.tdt,st.tdt] = signtest_explicit(nanmean(tdt(preinds,:),1)',nanmean(tdt(postinds,:),1)',0);
    
    
    [st2.p,st2.st] = ranksum_explicit(nanmean(msn(postinds(1:2),:),1)',nanmean(tdt(postinds(1:2),:),1)');
    
   
    if nargin > 4
        msn = (msn/normalize.msn-1)*100;
        tdt = (tdt/normalize.tdt-1)*100;
    end

    
   figure
   shadedErrorBar((-radius:radius)*dt,mean(msn,2),serrMn(msn,2)','b',0);
   hold on;
   shadedErrorBar((-radius:radius)*dt,mean(tdt,2),serrMn(tdt,2)','r',0);
   
   ax = gca;
   legend([ax.Children(2), ax.Children(6)],{genotype,'MSN'});
   
   xlabel('Time from laser stim [s]');
   if nargin > 3 && isactivity
       ylabel('Pr(active) (% over baseline)');
   else
       ylabel('\DeltaF/F');
    end
   title(sprintf('Laser-triggered MSN and %s activity',genotype));
   if nargin > 3 && isactivity
       savePDF(gcf,sprintf('figures/%s/laser_triggered_tdt_prob_%s.pdf',date,genotype))
   else
       savePDF(gcf,sprintf('figures/%s/laser_triggered_tdt_dff_%s.pdf',date,genotype))
   end

end