clc;clear;close all;
%----------- load -----------%
load('a_Area_ap_a_rawdata');
load('a_Area_ap_b_rawdata');
load('a_Area_ap_c_rawdata');
ap_a_kalman = Kalmanfilter(a_Area_ap_a_rawdata);
ap_b_kalman = Kalmanfilter(a_Area_ap_b_rawdata);
ap_c_kalman = Kalmanfilter(a_Area_ap_c_rawdata);
%--------- analysis ---------%
[m, n] = size(ap_a_kalman);
% i = floor(m * n * rand(1));
i = 60;
x1 = 1:length(ap_a_kalman{i});
y1 = ap_a_kalman{i};
figure(1);plot(x1, y1, x1, ones(1,length(x1))*sum(y1)/length(y1), '-r');axis([0 length(x1) (min(y1)-10) (max(y1)+10)]);title('RSSI');
xlabel('N');
ylabel('RSSI(db)');

ap_a_dev = cell2mat(cellfun(@std, ap_a_kalman, 'UniformOutput', false));
figure(2);
for j = 1:size(ap_a_dev, 1)
    x2 = 1:length(ap_a_dev(1,:));
    y2 = ap_a_dev(j,:);
    subplot(2,2,j);plot(0.8 * x2, y2);title('��׼�������Ĺ�ϵ');
    xlabel('Distance/m');
    ylabel('Standard Deviation');
end

ap_a_skewness = cell2mat(cellfun(@skewness, ap_a_kalman, 'UniformOutput', false));
figure(3);
for k = 1:size(ap_a_skewness, 1)
    x3 = 1:length(ap_a_skewness(1,:));
    y3 = ap_a_skewness(k,:);
    subplot(2,2,k);plot(0.8 * x3, y3);title('ƫ�������Ĺ�ϵ');
    xlabel('Distance/m');
    ylabel('Skewness');
end