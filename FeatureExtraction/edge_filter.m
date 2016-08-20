function p = edge_filter(height, width, theta)

if nargin ==0 % for test
    height = 17;
    width = 17;
    theta = 0;
end


%r=[cos(theta) -sin(theta);     sin(theta)  cos(theta)];
%mu=[(height+1)/2,(width+1)/2];% 均值向量
%Sigma=[17 0; 0 2];% 协方差矩阵
%[X,Y]=meshgrid(-(height+1)/2:(height+1), -(width+1)/2:-(width+1)/2);%在XOY面上，产生网格数据
%Rotated = r * [X(:), Y(:)]';
%p=mvnpdf(Rotated',[0 0],Sigma);%求取联合概率密度，相当于Z轴
%p=reshape(p,size(X));%将Z值对应到相应的坐标上
%p=p*40;
%imshow(p*30)
%imshow(imresize(p,[200 200],'box'))
p = d2gauss(height, 4, width, 1.5, theta/180*pi);
%imshow(imresize(p*4,[200 200],'box'))

function h = d2gauss(n1,std1,n2,std2,theta)
r=[cos(theta) -sin(theta);  sin(theta)  cos(theta)];
for i = 1 : n2
    for j = 1 : n1
        u = r * [j-(n1+1)/2 i-(n2+1)/2]';
        h(i,j) = gauss(u(1),std1)*gauss(u(2),std2);
    end
end
h = h / sqrt(sum(sum(h.*h)));
end

function y = gauss(x,std)
y = exp(-x^2/(2*std^2)) / (std*sqrt(2*pi));
end

end