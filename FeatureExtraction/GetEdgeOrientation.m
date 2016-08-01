function [fea] = GetEdgeOrientation(Frame, Mask, dmap)

%bwMask=edge(Mask,'canny');
%bwFrame=edge(Frame.*uint8(Mask>0),'canny');
%bw=(bwFrame-bwMask)>0;

bwFrame=edge(Frame,'canny');
bwFrame = bwFrame.*double(Mask>0);
fea = edge_orientation(bwFrame, dmap);
