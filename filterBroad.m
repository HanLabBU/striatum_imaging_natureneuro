function Xout = filterBroad(X)
   Xout = zeros(size(X));
    for i=1:size(X,2)
        currx = X(:,i);
%         %fit polynomial
        currx = [flipud(currx(1:301)); currx; flipud(currx(end-300:end))];
        currx = sgolayfilt(currx, 3,101); %301);
        currx = currx(302:end-301);
        Xout(:,i) = currx;
    end

%     Xout = loPassButterworth(Xout,1/.0469, [.1]); %1/1000, 1/10]);

end