% implemented as per Reiner, A., Yekutieli, D., & Benjamini, Y. (2003). 
%Identifying differentially expressed genes using false discovery rate controlling procedures.
%Bioinformatics, 19(3), 368–375. https://doi.org/10.1093/bioinformatics/btf877
function p = posthoc_benjaminihochberg_raw(p)
   p = correct(p);
  
end
function p_corrected = correct(p)
   sz = size(p);
   p_vector = p(:);
   [psort,i] = sort(p_vector);
   
   assert(length(unique(p_vector)) == length(p_vector),'not unique p values!');
   
   [~,orig_order] = sort(i);
   psort = psort./(1:length(psort))'*length(psort); % correct p-values (initial). Now for-loop
   for i=1:(numel(psort)-1)
       psort(i) = min(psort(i:end));
   end
   psort = psort(orig_order);
   p_corrected = reshape(psort,sz(1),sz(2));
end