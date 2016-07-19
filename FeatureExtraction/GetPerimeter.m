function Perimeter = GetPerimeter(I, dmap)

% bw=edge(I,'canny');    
% bw = double(bw).*sqrt(dmap);
% Perimeter=sum(sum(bw));
tmp = imerode(I, strel('disk',1));
tmp = I - tmp;
tmp = double(tmp) .* sqrt(dmap);
Perimeter = sum(tmp(:))/255;%/255 is added by lfche