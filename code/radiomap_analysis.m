clc;clear;close all;
%----------- load -----------%
load('a_radiomapdata_kalman');
apqty = 3;
%--------- ���ݷ��� ----------%
for i = 1:apqty
    figure(i);
    temp = cellfun(@(x) x(i), a_radiomapdata_kalman, 'UniformOutput', false);
    for j = 1:size(a_radiomapdata_kalman,1)
        y = cell2mat(temp(j,:));
        x = 1:size(y, 2);
        subplot(2,2,j); plot(x,y);title(['RSSI������ϵͼ(AP',num2str(i),')']);
        xlabel('Distance');
        ylabel('Gauss filtered RSSI(db)');
    end
end