function [reward] = get_my_reward(obs, pre_obs, mytime)
    % 计算奖励值，输入为当前轮的obs和上一轮的obs

    % 初始化
    reward = 0;
    
    % 提取当前和上一时刻的观察量
    current_dist = norm(obs(1:3));
    prev_dist = norm(pre_obs(1:3));
    
    % 距离奖励
    dist_change = prev_dist - current_dist;
    if dist_change > 0
        reward_dist = dist_change * 20.0;
    else
        reward_dist = dist_change * 80.0;
    end
    
    % 方位角奖励
    AAy = obs(7); % 方位角水平分量
    AAp = obs(9); % 方位角垂直分量
    reward_yaw = -AAy^2 * 1.0; % 使用平方代替绝对值
    reward_pitch = -AAp^2 * 4.0;
    
    % 组合战机接近奖励
    reward = reward_dist + reward_yaw + reward_pitch;

    % 距离阶段奖励
    stage_num = 20;
    persistent last_distance_zone
    if isempty(last_distance_zone)
        last_distance_zone = floor(current_dist * stage_num);
    end
    current_zone = floor(current_dist * stage_num);
    if current_zone < last_distance_zone
        reward = reward + (last_distance_zone - current_zone) * 5;
        last_distance_zone = current_zone;
    end

    % 生命值变化奖励
    current_hp_diff = obs(15);
    prev_hp_diff = pre_obs(15);
    hp_change = current_hp_diff - prev_hp_diff;
    reward = reward + hp_change * 1000;

    % 时间惩罚
    reward = reward - 0.1;
end
