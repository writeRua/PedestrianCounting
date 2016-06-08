function [ratio] = GetRatio(I, dmap)
ratio = GetArea(I, dmap) / GetPerimeter(I, dmap);
