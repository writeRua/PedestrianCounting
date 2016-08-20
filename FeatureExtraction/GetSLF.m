function result = SLF(image,mask)

A=image.*(mask/255);

for i=8:8:248
    
    
    TA = double(A) - i + 1;
    TA = immultiply(TA,double(A >= i));
    
    TB = i - double(A) + 1; 
    TB = immultiply(TB,double( A<= i));
    
    Talpha = (A == i);

    [LA,nA] = bwlabel(TA);
    [LB,nB] = bwlabel(TB);
    
    NOA(i/8) = nA;
    NOB(i/8) = nB;
    
    t = 0;
    
    for k=1:nA
        r = sum(sum(immultiply((LA == k), TA)));
        r = r / length(find(LA == k));
        r = r-1;
        t = t+r;
    end
    
    hA(i/8) = 0;
    if nA~=0
        hA(i/8) = t/nA;
    end
    
    t = 0;
    
    for k=1:nB
        r = sum(sum(immultiply((LB == k), TB)));
        r = r / length(find(LB == k));
        r = r-1;
        t = t+r;
    end
    
    hB(i/8) = 0;
    if nB~=0
        hB(i/8) = t/nB;
    end

end

% NOA = (NOA - mean(NOA));
% NOB = (NOB - mean(NOB));
% hA =  (hA - mean(hA));
% hB = (hB - mean(hB));

result = [NOA NOB hA hB];
