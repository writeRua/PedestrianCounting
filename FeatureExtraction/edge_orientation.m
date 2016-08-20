function [edge_bin] = edge_orientation(img, dmap)
    edge_bin = zeros(1, 6);
    pimg = padarray(img, [8 8]);
    for theta=0:30:150
        ef{theta/30+1} = edge_filter(17, 17, theta);
    end
    
    idx = find(img>0);
    for i=1:length(idx)
        pix = idx(i);
        [x y] = ind2sub(size(img), pix);
        patch = double(pimg(x:x+16, y:y+16));
        bin_val = zeros(6,1);
        for theta=1:6
            bin_val(theta) = sum(sum(patch .* ef{theta}));
        end
        [C, I] = max(bin_val);
        edge_bin(I) = edge_bin(I) + sqrt(dmap(x, y));
    end
end