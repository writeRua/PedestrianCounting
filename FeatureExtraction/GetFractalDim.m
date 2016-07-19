function [FractalDim] = GetFractalDim(Frame, Mask)

%bwMask=edge(Mask,'canny');
%bwFrame=edge(Frame.*uint8(Mask>0),'canny');
%bw=(bwFrame-bwMask)>0;

bwFrame=edge(Frame,'canny');
bwFrame = bwFrame.*double(Mask>0);
[n,r] = boxcount(bwFrame);
df = -diff(log(n))./diff(log(r));
FractalDim=mean(df);
