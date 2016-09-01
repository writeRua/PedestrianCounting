function [ if_overlap ] = if_overlap( mask1,mask2,min_overlap_rate )
%To judge if overlap between two masks.  
%min_overlap_rate has defauut value 0.5

if (nargin<2)
    error('In if_overlap(mask1,mask2,min_overlap_rate):Too few parameters!');
elseif(nargin>3)
    error('In if_overlap(mask1,mask2,min_overlap_rate):Too many parameters!');
elseif(nargin==2)
    min_overlap_rate=0.5;
end


temp1=length(find((mask1&mask2)>0));
temp2=length(find((mask1|mask2)>0));
if_overlap=(temp1/temp2)>min_overlap_rate;

end

