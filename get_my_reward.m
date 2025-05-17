function [reward] = get_my_reward(obs, pre_obs, mytime)
    % 计算奖励值，输入为当前轮的obs和上一轮的obs

    % 初始化
    reward = 0;
    
    % 提取当前和上一时刻的观察量
    current_dist = norm(obs(1:3));
    prev_dist = norm(pre_obs(1:3));
    
    % 距离奖励
    dist_change = prev_dist - current_dist;
    reward_dist = dist_change * 10.0;
    
    % 方位角奖励
    AAy = obs(7); % 方位角水平分量
    AAp = obs(9); % 方位角垂直分量
    reward_yaw = -AAy^2; % 使用平方代替绝对值
    reward_pitch = -AAp^2;
    
    % 组合战机接近奖励
    reward = reward_dist + reward_yaw + reward_pitch;

    % 距离阶段奖励
    persistent last_distance_zone
    if isempty(last_distance_zone)
        last_distance_zone = floor(current_dist * 10);
    end
    current_zone = floor(current_dist * 10);
    if current_zone < last_distance_zone
        reward = reward + (last_distance_zone - current_zone) * 10;
        last_distance_zone = current_zone;
    end

    % 生命值变化奖励
    current_hp_diff = obs(15);
    prev_hp_diff = pre_obs(15);
    hp_change = current_hp_diff - prev_hp_diff;
    reward = reward + hp_change;
    
    % 结束
    if current_hp_diff >= 1000
        reward = 1000;
    elseif current_hp_diff <= -1000
        reward = -1000;
    end

    % 时间惩罚
    reward = reward - 0.01;
end
