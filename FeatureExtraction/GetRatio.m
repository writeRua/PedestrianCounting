function [ratio] = GetRatio(I, dmap)
%ratio = GetArea(I, dmap) / GetPerimeter(I, dmap);
ratio=GetPerimeter(I,dmap)/GetArea(I,dmap);
