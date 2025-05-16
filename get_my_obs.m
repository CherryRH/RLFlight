function [obs] = get_my_obs(org_obs)
    % org_obs(1-13)第一架飞机的参数org_obs(14-26)第二架飞机参数
    % org_obs(1-3)x\y\z坐标 （单位为10m）
    % org_obs(4-6)欧拉角𝜑\𝜃\𝜓对应翻滚(roll)、俯仰(pitch)、偏航(yaw) ）（单位是rad）
    % org_obs(7-9)线速度u\v\w （单位是m/s）
    % org_obs(10-12)角速度ω\β\η （单位是rad/s）
    % org_obs(13)血量
    % TODO:将高维的原始观察数据降维，并根据降维后的观察数据设计reward
    % 注：matlab的数组下标从1开始

    % 提取双方信息
    my_info = org_obs(1:13);
    enemy_info = org_obs(14:26);
    
    % 计算相对位置和距离
    rel_pos = enemy_info(1:3) - my_info(1:3);
    xr = rel_pos(1);
    yr = rel_pos(2);
    zr = rel_pos(3);
    
    % 计算相对速度
    rel_vel = enemy_info(7:9) - my_info(7:9);
    
    % 计算方位角 (AAy, AAp)
    AAy = atan2(yr, xr) - my_info(6); % 偏航差
    AAp = atan2(zr, sqrt(xr^2 + yr^2)) - my_info(5); % 俯仰差
    
    % 计算进入角 (ATAy, ATAp)
    ATAy = atan2(yr, xr); % 敌机对我机的偏航角
    ATAp = atan2(zr, sqrt(xr^2 + yr^2)); % 敌机对我机的俯仰角
    
    % 提取角速度信息 (β0, β1, n0, n1)
    my_pitch_rate = my_info(11);   % β0
    enemy_pitch_rate = enemy_info(11); % β1
    my_yaw_rate = my_info(12);    % n0
    enemy_yaw_rate = enemy_info(12); % n1
    
    % 生命值差值 (h0)
    hp_diff = my_info(13) - enemy_info(13);
    
    % 构建原始观察量向量
    obs = [
        xr;
        yr;
        zr;
        rel_vel(1);
        rel_vel(2);
        rel_vel(3);
        AAy;
        ATAy;
        AAp;
        ATAp;
        my_pitch_rate;
        enemy_pitch_rate;
        my_yaw_rate;
        enemy_yaw_rate;
        hp_diff;
    ];
end
