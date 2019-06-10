function st = pairwise_fishertest(siginds)
c = nchoosek(1:3,2);
fields = fieldnames(siginds);
st = struct();

assert(all(~isnan(siginds.msn)));
assert(all(~isnan(siginds.fsi)));
assert(all(~isnan(siginds.chi)));
for f=1:numel(fields)
    currfield1 = fields{c(f,1)};
    currfield2 = fields{c(f,2)};
    [st(f).h,st(f).p,st(f).st] = fishertest([sum(siginds.(currfield1)) sum(~siginds.(currfield1)); ...
        sum(siginds.(currfield2)) sum(~siginds.(currfield2))]);
    st(f).comparison = {currfield1, currfield2};
    
    % now correct
    st(f).p = st(f).p*size(c,1);
end

end