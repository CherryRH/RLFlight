function [obs] = get_my_obs(org_obs)
    % org_obs(1-13)第一架飞机的参数org_obs(14-26)第二架飞机参数
    % org_obs(1-3)x\y\z坐标 （单位为10m）
    % org_obs(4-6)欧拉角𝜑\𝜃\𝜓对应翻滚(roll)、俯仰(pitch)、偏航(yaw) ）（单位是rad）
    % org_obs(7-9)线速度u\v\w （单位是m/s）
    % org_obs(10-12)角速度ω\β\η （单位是rad/s）
    % org_obs(13)血量
    % TODO:将高维的原始观察数据降维，并根据降维后的观察数据设计reward
    % 注：matlab的数组下标从1开始

    my_info = org_obs(1:13);    % 我方飞机信息
    enemy_info = org_obs(14:26); % 敌方飞机信息
    
    my_pos = my_info(1:3);       % 我方位置 (x,y,z)
    enemy_pos = enemy_info(1:3);  % 敌方位置 (x,y,z)
    
    % 计算相对位置和距离
    rel_pos = enemy_pos - my_pos;
    distance = norm(rel_pos);
    
    % 计算角度差
    desired_yaw = atan2(rel_pos(2), rel_pos(1));
    yaw_diff = angleDiff(my_info(6), desired_yaw);
    desired_pitch = atan2(rel_pos(3), sqrt(rel_pos(1)^2 + rel_pos(2)^2));
    pitch_diff = angleDiff(my_info(5), desired_pitch);
    
    % 构建观测向量
    obs = [
        rel_pos(1);
        rel_pos(2);
        rel_pos(3);
        distance;
        my_info(4);
        my_info(5);
        my_info(6);
        yaw_diff;
        pitch_diff;
        my_info(7);
        my_info(8);
        my_info(9);
        my_info(10);
        my_info(11);
        my_info(12);
        my_info(13);
        enemy_info(13);
    ];
end

% 计算角度差（-pi到pi之间）
function diff = angleDiff(a, b)
    diff = mod(b - a + pi, 2*pi) - pi;
end