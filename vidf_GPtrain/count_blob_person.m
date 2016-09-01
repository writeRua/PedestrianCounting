function [ blob_person_count ] = count_blob_person( blobs , person_locations , image_size )
%To get how many people in each blob in one frame.
blob_person_count = zeros(length(blobs),1);
for i = 1:size(person_locations,1)
    loc=ceil(person_locations(i,[2,1]));
    for k=1:2
        if loc(k)<1
            loc(k)=1;
        elseif loc(k)>image_size(k)
            loc(k)=image_size(k);
        end
    end
    %disp(loc);
    for j=1:length(blobs)
        %disp(j);
        if blobs{j}(loc(1),loc(2))>0
            blob_person_count(j)=blob_person_count(j)+1;
            %disp('!');
            break;
        end
    end
end

