function [FractalDim] = GetFractalDim(Frame, Mask)

bwMask=edge(Mask,'canny');
bwFrame=edge(Frame.*(Mask/255),'canny');
bw=(bwFrame-bwMask)>0;
[n,r] = boxcount(bw);
df = -diff(log(n))./diff(log(r));
FractalDim=mean(df);
