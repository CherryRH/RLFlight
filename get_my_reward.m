function [reward] = get_my_reward(obs, pre_obs, mytime)
    % 计算奖励值，输入为当前轮的obs和上一轮的obs
    
    % 初始化奖励
    reward = 0;
    
    % 1. 距离奖励：越近奖励越高（使用反比例函数）
    current_distance = obs(4); % 当前距离
    prev_distance = pre_obs(4); % 上一时刻距离
    distance_reward = (prev_distance - current_distance) * 0.1; % 距离缩短奖励
    
    % 2. 角度奖励：朝向目标奖励
    yaw_diff = abs(obs(8)); % 偏航角差
    angle_reward = (1 - yaw_diff/pi) * 0.5; % 完全朝向时最大奖励0.5
    
    % 3. 血量奖励：敌方血量减少奖励
    current_enemy_health = obs(16);
    prev_enemy_health = pre_obs(16);
    health_reward = (prev_enemy_health - current_enemy_health) * 10; % 每次击中奖励
    
    % 4. 时间惩罚
    time_penalty = -0.01; % 每步小惩罚
    
    % 5. 势能奖励（可选）：鼓励积极进攻
    potential_reward = 0;
    if current_distance < 30 % 只在近距离生效
        potential_reward = (30 - current_distance) * 0.01;
    end
    
    % 总奖励
    reward = distance_reward + angle_reward + health_reward + time_penalty + potential_reward;
    
    % 如果击落敌机，给予大奖励
    if current_enemy_health <= 0
        reward = reward + 100;
    end
    
    % 如果我方被击落，给予大惩罚
    if obs(15) <= 0
        reward = reward - 100;
    end
end