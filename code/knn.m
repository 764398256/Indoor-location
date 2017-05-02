clc;clear;close all;
%----------- load -----------%
map = openfig('map.fig','reuse');
load('testpoints');
load('a_radiomapdata');
apqty = 3;
k = 3;
result = cell(1,1);
%----------- knn -----------%
testqty = size(testpoints, 2);
tempcell = cell(size(a_radiomapdata));
for i = 1:testqty
    %----------- ����ŷʽ���� -----------%
    tempcell(:,:) = {testpoints{i}(2,:)};
    EuclideanDistancecell = cellfun(@(x,y) (x - y).^2, a_radiomapdata, tempcell, 'UniformOutput', false);
    EuclideanDistance = sqrt(cellfun(@sum, EuclideanDistancecell));
    %----------- ���㶨λ��� -----------%
    [sorted, index] = sort(EuclideanDistance(:));
    [y_index, x_index] = ind2sub(size(a_radiomapdata), index);
    y_knn = sum(y_index(1:k)) / k;
    x_knn = sum(x_index(1:k)) / k;
    result{i} = [x_knn y_knn]; 
end

%----------- ��λ���ͼ -----------%
for j = 1:testqty
    x = result{j}(1) - 1;
    y = result{j}(2) - 1;
    xloc = 80 * x;
    if y >= 2
        yloc = 79 + 80 + (y - 2) * 83;
    elseif y >= 1
        yloc = 79 + (y - 1) * 80;
    else
        yloc = 79 * y;
    end
    hold on;
    scatter(xloc, yloc, 20, 'k');
    text(xloc, yloc, num2str(j));
end
