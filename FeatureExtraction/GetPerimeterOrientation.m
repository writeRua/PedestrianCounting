function [fea] = GetPerimeterOrientation(Mask, dmap)

%bwMask=edge(Mask,'canny');
%bwFrame=edge(Frame.*uint8(Mask>0),'canny');
%bw=(bwFrame-bwMask)>0;

%bwFrame=edge(Mask,'canny');

bwFrame = imerode(Mask, strel('disk',1));
bwFrame = Mask - bwFrame;
fea = edge_orientation(bwFrame, dmap);
