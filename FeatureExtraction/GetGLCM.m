function [fea] = GetGLCM(img, dmap)
%glcm = graycomatrix_perspective(img, dmap, [0 1; -1 1; -1 0; -1 -1]);
glcm = graycomatrix(img, 'Offset', [0 1; -1 1; -1 0; -1 -1]);
modifyGLCM = 0;
if modifyGLCM
    glcm(1,1,:) = 1;
end

tmp = graycoprops(glcm, 'Energy', 'Homogeneity');
%fea = [tmp.Energy, tmp.Homogeneity];
fea = [];
for i=1:4
    %ent = entropy(glcm(:,:,i)/sum(sum(glcm(:,:,i))));
    ent = entropy(glcm(:,:,i));
    fea = [fea, tmp.Energy(1), tmp.Homogeneity(1), ent];
end
end