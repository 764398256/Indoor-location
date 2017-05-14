%x����wifi��λ������������
%y����wifi��λ������������
%v�����˶�Ŀ���˶��������
%t����ʱ��������
%N�������Ӹ���
function result = Particlefilter(x, y, d, N)
particles = zeros(N,3);
particles(1,:) = normrnd(x(1), 2, [1 N]);
particles(2,:) = normrnd(y(1), 2, [1 N]);
particles(3,:) = normrnd(d(1), 0.5, [1 N]);%����
% particles(4,:) = normrnd(v(1), 2, [1 N]);%����
weights = ones(1,N) / N;

for i = 2:length(x)
    %-------- prediction --------%
    costheta = x(i) - x(i-1) / d(i);
    sintheta = y(i) - y(i-1) / d(i);
    x_pre = particles(1,:) + d(i) * costheta;
    y_pre = particles(2,:) + d(i) * sintheta;
    d = particles(3,:) + normrnd(0, 0.5, [1 N]);
    %---------- update ----------%
    distance = arrayfun(@(x,y) sqrt(x^2 + y^2), x_pre - x(i), y_pre - y(i) , 'UniformOutput', true);
    weights = normpdf(distance, 0, 1) / sum(normpdf(distance, 0, 1));
    %-------- resampling --------%
    if 1 / sum(weights.^2) < length(x) / 2
        cumulative_sum = cumsum(weights);
        indexes = searchsorted(cumulative_sum, rand([1,length(weights)]));
        particles(:) = particles(:,indexes);
        weights = ones(1,length(weights)) / length(weights);
    end        
    %--------- estimate ---------%
    result = [sum(x_pre .* weights) sum(y_pre .* weights)];
end
end

function indexes = searchsorted(array1, array2)
array1 = [0 array1];
indexes = array2;
for i = 1 : length(array1) - 1
    indexes(array2 >= array1(i) & array2 < array1(i + 1)) = i - 1;
end
end