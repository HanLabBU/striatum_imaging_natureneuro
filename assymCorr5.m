function [S, Z] = assymCorr5(A,B,AShuffles, BShuffles)
    if nargin == 1
        B = A;
    end
    numROIsA = size(A,2);
    numROIsB = size(B,2);
    A = sparse(A);
    B = sparse(B);
    S = zeros(numROIsA,numROIsB);
    if nargin > 2
        Z = zeros(numROIsA,numROIsB, numel(BShuffles));
        numshuffs = numel(BShuffles);
    else
        Z = [];
        numshuffs = 0;
        AShuffles = [];
        BShuffles = [];
    end
    for i=1:size(A,2)
        S(i,:) = acc(B,A(:,i));
        for shuff=1:numshuffs
            % to what extent does B overlap with A?
            Z(i,:,shuff) = acc(BShuffles{shuff},AShuffles{shuff}(:,i));
        end
    end
end

