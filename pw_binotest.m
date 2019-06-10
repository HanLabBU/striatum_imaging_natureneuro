function st = pw_binotest(vector,labels,correct)
c = nchoosek(1:numel(vector),2);
if correct
    factor = size(c,1);
else
    factor = 1;
end
for i=1:size(c,1)
   st(i).p = myBinomTest(vector(c(i,1)),vector(c(i,1))+vector(c(i,2)))*factor;
   st(i).n = [vector(c(i,1)), vector(c(i,2))];
   st(i).labels = labels([c(i,1) c(i,2)]);
end

end