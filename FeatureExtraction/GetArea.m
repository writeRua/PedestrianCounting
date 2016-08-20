function [area] = GetArea(I, dmap)
%get foreground area 
I = I / 255;
I = double(I).*dmap;
area=sum(sum(I));
