function [reward] = get_my_reward(obs, pre_obs, mytime)
    % 计算奖励值，输入为当前轮的obs和上一轮的obs

    % 常量
    % 最大距离
    MAX_DISTANCE = 100;
    % 理想攻击距离
    IDEAL_DISTANCE = 30;
    % 最小速度
    MIN_SPEED = 4;
    % 最大速度
    MAX_SPEED = 10;
    % 理想角度
    IDEAL_ANGLE = pi/8;
    % 严重旋转阈值
    ROTATION_THRESHOLD = pi/3;
    
    % 距离变化奖励
    current_distance = obs(4);
    prev_distance = pre_obs(4);
    distance_change = prev_distance - current_distance;
    if distance_change > 0
        distance_change_reward = distance_change * ((MAX_DISTANCE - current_distance) * 0.01);
    else
        distance_change_reward = distance_change * 10.0;
    end
    
    % 绝对距离奖励
    distance_bonus = 0;
    if current_distance <= IDEAL_DISTANCE
        distance_bonus = (IDEAL_DISTANCE - current_distance) * 0.1;
    elseif current_distance >= MAX_DISTANCE
        distance_bonus = -300;
    else
        distance_bonus = -5;
    end
    
    % 角度对准奖励
    yaw_diff = obs(8);
    pitch_diff = obs(9);
    alignment_reward = 0;
    if abs(yaw_diff) < IDEAL_ANGLE && abs(pitch_diff) < IDEAL_ANGLE
        alignment_reward = 2;
    end

    % 旋转惩罚
    angle_penalty = (abs(yaw_diff) + abs(pitch_diff)) * 1.0;
    rotation_penalty = 0;
    if abs(yaw_diff) > ROTATION_THRESHOLD || abs(pitch_diff) > ROTATION_THRESHOLD
        rotation_penalty = (abs(yaw_diff) + abs(pitch_diff)) * 5.0;
    end
    
    % 速度奖励
    speed = norm(obs(10:12));
    if speed > MIN_SPEED
        speed_reward = min(speed, MAX_SPEED) * 0.2;
    else
        speed_reward = -(MIN_SPEED - speed) * 1.0;
    end
    
    % 攻击奖励
    current_enemy_health = obs(17);
    prev_enemy_health = pre_obs(17);
    attack_reward = (prev_enemy_health - current_enemy_health) * 1;
    
    % 时间惩罚
    time_penalty = 0.01;
    
    reward = distance_change_reward + distance_bonus + ...
             alignment_reward - angle_penalty - rotation_penalty + ...
             speed_reward - time_penalty + attack_reward;
    
    if current_enemy_health <= 0
        reward = reward + 100;
    end
    
    if obs(16) <= 0
        reward = reward - 100;
    end
end

% 计算角度差（-pi到pi之间）
function diff = angleDiff(a, b)
    diff = mod(b - a + pi, 2*pi) - pi;
end