%x——wifi定位结果横坐标矩阵
%y——wifi定位结果纵坐标矩阵
%v——运动目标运动速度
%t——时间间隔矩阵
%N——粒子个数
function result = Particlefilter(x, y, v, t, N)
result = zeros(2,length(x));
particles = zeros(4,N);
n = 0; m = 1; k = 1;
x_s = 0; y_s = 0;
while k <= length(x)
if v(k) == 0
    n = n + 1;
    x_s = x_s + x(k);
    y_s = y_s + y(k);
    k = k + 1;
    continue
end
if n ~= 0
    x_s = x_s / n;
    y_s = y_s / n;
    n = 0;
end

result(1,m) = x_s;
result(2,m) = y_s;
m = m + 1;

if x(k) - x(k-1) > 0
    theta = pi / 2;
else
    theta = -pi / 2;
end
particles(1,:) = normrnd(x_s, 1, [1 N]);
particles(2,:) = normrnd(y_s, 1, [1 N]);
particles(3,:) = normrnd(v(k) * sin(theta), 0.01, [1 N]);%x方向速度
particles(4,:) = normrnd(v(k) * cos(theta), 0.01, [1 N]);%y方向速度
weights = ones(1,N) / N;
x_s = 0; y_s = 0;

for i = k:length(x)
    if v(i) == 0
        k = i;
        break
    end
    %-------- prediction --------%
    F = [1 0 t(i) 0; 0 1 0 t(i); 0 0 1 0; 0 0 0 1];
    n = [normrnd(0, 1, [1 N]); normrnd(0, 1, [1 N]); normrnd(0, 0.1, [1 N]); normrnd(0, 0.1, [1 N])];
    particles_last = particles;
    particles = F * particles_last + n;
    for j = 1:100
        idx = find((particles(1,:) < 0) | (particles(1,:) > 48) | (particles(2,:) < 0) | ((particles(1,:) >= 0) & (particles(1,:) <= 23.4483) & (particles(2,:) > 4)) | ((particles(1,:) > 23.4483) & (particles(1,:) <= 43.2246) & (particles(2,:) > 5)) | ((particles(1,:) > 43.2246) & (particles(1,:) <= 48) & (particles(2,:) > 4)));
        particles(:, idx) = F * particles_last(:, idx) + [normrnd(0, 1, [1 length(idx)]); normrnd(0, 1, [1 length(idx)]); normrnd(0, 0.1, [1 length(idx)]); normrnd(0, 0.1, [1 length(idx)])];
        if isempty(idx)
            break
        end
    end
%     theta = (x(i) - x(i-1)) / v(i);
%     x_pre = particles(1,:) + v(i-1) * t(i) * cos(theta) + normrnd(0.5, 1, [1 N]);
%     y_pre = particles(2,:) + v(i-1) * t(i) * sin(theta) + normrnd(0.5, 1, [1 N]);
%     v_pre = particles(3,:) + normrnd(0, 0.1, [1 N]);
    %---------- update ----------%
    distance = arrayfun(@(x,y) sqrt(x^2 + y^2), (particles(1,:) - (x(i) + t(i) * v(i) * sin(theta)) / 2 ), (particles(2,:) - (y(i) + t(i) * v(i) * cos(theta)) / 2) , 'UniformOutput', true);
    weights = normpdf(distance, 0, 4) / sum(normpdf(distance, 0, 4));
    %-------- resampling --------%
    if 1 / sum(weights.^2) < N / 2
        cumulative_sum = cumsum(weights);
        indexes = searchsorted(cumulative_sum, rand([1,length(weights)]));
        particles(:) = particles(:,indexes);
        weights = ones(1,length(weights)) / length(weights);
    end        
    %--------- estimate ---------%
    result(1,m) = sum(particles(1,:) .* weights);
    result(2,m) = sum(particles(2,:) .* weights);
    m = m + 1;
    k = i + 1;
    
end
end
end

function indexes = searchsorted(array1, array2)
array1 = [0 array1];
indexes = array2;
for i = 1 : length(array1) - 1
    indexes(array2 >= array1(i) & array2 < array1(i + 1)) = i;
end
end