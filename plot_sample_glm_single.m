function plot_sample_glm_single(samples,type, suffix)
for i=1:numel(samples)
    if ~isempty(samples{i})
        samplesmsn = samples{i}.msn.pred;
        samplesint = samples{i}.int.pred;
        samplesmsnall = samples{i}.msn.all;
        figure
        plot(samples{i}.y,'r');
        hold on;
        plot(samplesmsnall.pred,'b');
        title(['GLM ' suffix{i} ' all msns']);
        savePDF(gcf,sprintf('figures/%s/examples/example_glmmulti_msnall_%s.pdf',date,suffix{i}));
        for s=1:size(samples{i}.int.pred,2)
           figure;
          plot(samples{i}.y,'r');
           hold on;
           plot(samplesmsn(:,randi(size(samplesmsn,2),1)),'b');

           title(['GLM ' suffix{i} ' single msn example ' s]);
           savePDF(gcf,sprintf('figures/%s/examples/example_glmmulti_msn_%s_%d.pdf',date,suffix{i},s))
        end
        for s=1:size(samplesint,2)
           figure;
           plot(samples{i}.y,'r');
           hold on;
           plot(samplesint(:,s),'b');
           title(sprintf('GLM %s %s single example %d',suffix{i},type,s));
           savePDF(gcf,sprintf('figures/%s/examples/example_glmmulti_%s_%s_%d.pdf',date,type,suffix{i},s))
        end
    end
    close all
end
end