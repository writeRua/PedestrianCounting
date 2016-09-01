%To make a picture of colorbar, which shows a mapping from color to num.

%The mapping satisfy the property below:
%    It convert the base_color to the corresponding base_num.
%    It's linearly fitted between every pair of neighboring base points. 





%=======basic settings:

savepath='D:\lab\People_Counting\colorbar.png';
%base_color={[255,0,0],[255,255,0],[0,255,0]};
%base_color={[255,0,0],[255,255,0],[0,255,0],[0,255,255],[0,0,255]};
base_color={[0,255,0],[0,255,255],[0,0,255],[255,0,255],[255,0,0]};
%base_num={1,33,65,97,128};
base_num={0,5,10,15,20};
mark_num={0,5,10,15,20}; %Which points that need a mark.
color_bar_size=[128,30];
image_size=[150,50];
color_bar_basepoint=[11,1];
fontsize=10;


%=====================

num_length_scale=(base_num{length(base_num)}-base_num{1})/color_bar_size(1);
color_bar=zeros([color_bar_size,3],'uint8');
for i=1:color_bar_size(1)
    for j=1:color_bar_size(2)
        color_bar(color_bar_size(1)-i+1,j,:)=num2color(i*num_length_scale,base_num,base_color);
    end
end
%imshow(color_bar);

image=uint8(255)*ones([image_size,3],'uint8');
image(color_bar_basepoint(1):color_bar_basepoint(1)+color_bar_size(1)-1,color_bar_basepoint(2):color_bar_basepoint(2)+color_bar_size(2)-1,1:3)=color_bar;

mark_location_x=color_bar_basepoint(2)+color_bar_size(2)+2;
for i=1:length(mark_num)
    mark_location_y=color_bar_basepoint(1)+color_bar_size(1)-(mark_num{i}-base_num{1})/num_length_scale-fontsize/2;
    mark_location=[mark_location_x,mark_location_y];
    image=write_text_to_image(image,num2str(mark_num{i}),[0,0,0],mark_location,fontsize);
end

imwrite(image,savepath);
