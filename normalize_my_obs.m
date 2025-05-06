function [norm_obs] = normalize_my_obs(obs)
    % 输入为get_my_obs的输出
    % 将observation进行归一化处理
    % 从而保证参数更新以及激活函数的有效性

    % 定义各观测值的最大范围
    max_values = [
        100;
        100;
        100;
        100;
        pi;
        pi;
        pi;
        pi;
        50;
        50;
        50;
        5;
        5;
        5;
        1000;
        1000;
    ];
    
    % 归一化到[-1,1]范围
    norm_obs = obs ./ max_values;
    
    % 确保在[-1,1]范围内
    norm_obs = max(min(norm_obs, 1), -1);
end