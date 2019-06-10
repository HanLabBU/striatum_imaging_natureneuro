function plot_sample_glm_multi(Xsamples,Ysamples,type)
suffix = mouseSuffix('good');
for i=1:numel(Xsamples.msn)
    if ~isempty(Xsamples.msn{i})
        samplesmsn = Xsamples.msn{i};
           figure;
          plot(Ysamples{i},'r');
           hold on;
           plot(samplesmsn,'b');

           title(['GLM ' suffix{i} ' multiple msn example']);
           savePDF(gcf,sprintf('figures/%s/examples/example_glmmulti_msn_%s.pdf',date,suffix{i}))
            samplesint = Xsamples.int{i};
            for s=1:size(samplesint,2)
               figure;
              plot(Ysamples{i},'r');
               hold on;
               plot(samplesint,'b');
               title(sprintf('GLM %s %s multiple example',suffix{i},type));
               savePDF(gcf,sprintf('figures/%s/examples/example_glmmulti_%s_%s_%d.pdf',date,type,suffix{i},s))
            end
    end
end
end