function [Edge] = GetEdge(Frame, Mask, dmap)

% bwMask=edge(Mask,'canny');
% bwFrame=edge(Frame.*uint8(Mask>0),'canny');
% bw=(bwFrame-bwMask)>0;
bwFrame = edge(Frame,'canny');
bwFrame = bwFrame.*(Mask>0);
bw = double(bwFrame).*sqrt(dmap);
Edge=sum(sum(bw));
