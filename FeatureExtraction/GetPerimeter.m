function Perimeter = GetPerimeter(I, dmap)

bw=edge(I,'canny');    
bw = double(bw).*sqrt(dmap);
Perimeter=sum(sum(bw));
