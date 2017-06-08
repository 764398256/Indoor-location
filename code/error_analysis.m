clc;clear;close all;
load('error_knn');
load('error_wknn');
load('error_wknnpro');
load('error_bayes');

hold on
h0 = cdfplot(error_bayes);
h1 = cdfplot(error_knn);
h2 = cdfplot(error_wknn);
h3 = cdfplot(error_wknnpro);
set(h0, 'color', 'g', 'LineStyle', '-.', 'LineWidth', 2);
set(h1, 'color', 'm', 'LineStyle', ':', 'LineWidth', 2);
set(h2, 'color', 'b', 'LineStyle', '--', 'LineWidth', 2);
set(h3, 'color', 'r', 'LineStyle', '-', 'LineWidth', 2);
legend([h0 h1 h2 h3],'��Ҷ˹', 'KNN', 'WKNN', '�Ľ�����');
xlabel('Positioning Error(m)');
ylabel('The CDF of the Positioning Error');