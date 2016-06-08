function [Edge] = GetEdge(Frame, Mask, dmap)

bwMask=edge(Mask,'canny');
bwFrame=edge(Frame.*(Mask/255),'canny');
bw=(bwFrame-bwMask)>0;
bw = double(bw).*sqrt(dmap);
Edge=sum(sum(bw));
