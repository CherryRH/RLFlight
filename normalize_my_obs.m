function [norm_obs] = normalize_my_obs(obs)
    % 输入为get_my_obs的输出
    % 将observation进行归一化处理
    % 从而保证参数更新以及激活函数的有效性

    % 定义各观察量的范围
    ranges = [
        -100, 100;   % 1: x0
        -100, 100;   % 2: y0
        -100, 100;   % 3: z0
        -30, 30;       % 4: v0 (x方向相对速度)
        -30, 30;       % 5: v1 (y方向相对速度)
        -30, 30;       % 6: v2 (z方向相对速度)
        -pi, pi;         % 7: AAy
        -pi, pi;         % 8: ATAy
        -pi, pi;         % 9: AAp
        -pi, pi;         % 10: ATAp
        -pi/6, pi/6;     % 11: β0
        -pi/6, pi/6;     % 12: β1
        -pi/6, pi/6;     % 13: n0
        -pi/6, pi/6;     % 14: n1
        -1000, 1000;     % 15: h0
    ];
    
    % 线性归一化
    norm_obs = zeros(size(obs));
    for i = 1:length(obs)
        obs_min = ranges(i,1);
        obs_max = ranges(i,2);
        norm = 2*(obs(i)-obs_min)/(obs_max-obs_min) - 1;
        norm_obs(i) = min(1, max(-1, norm));
    end
end