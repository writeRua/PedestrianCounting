function [ color ] = num2color( num,base_num,base_color )
%It's a mapping from num to color.
%base_num and base_color are parameters of the mapping.

%The mapping satisfy the property below:
%    It maps the base_color to the corresponding base_num.
%    It's linearly fitted between every pair of neighboring base points. 

%if length(base_num)~=length(base_color)
%    error('In num2color( num,base_num,base_color ): the 2 cells, base_num and base_error, should have the same length!');
%end
if num<=base_num{1}
    color=uint8(base_color{1});
elseif num>base_num{length(base_num)}
    color=uint8(base_color{length(base_color)});
else
    for i=1:length(base_num)-1
        if num<=base_num{i+1} && num>base_num{i}
            start_color=double(base_color{i});
            end_color=double(base_color{i+1});
            color=(num-base_num{i}).*(end_color-start_color)./(base_num{i+1}-base_num{i})+start_color;
            color=uint8(color);
            break;
        end
    end  
end


end

