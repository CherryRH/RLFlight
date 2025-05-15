function [isdone] = get_my_isdone(org_obs)
    % 自定义训练中止条件，输入为原始战场数据，同get_my_obs.m的输入
    % isdone为1的时候，当前轮训练结束
    % 回忆gridworld，watertank，bipedrobot，都只在"无法继续行动"或"超过最大训练时间"时停止训练

    % 获取双方血量
    my_health = org_obs(13);
    enemy_health = org_obs(26);
    
    % 检查是否有一方被击落
    if my_health <= 0 || enemy_health <= 0
        isdone = 1;
        return;
    end
    
    % 检查是否超出最大距离
    my_pos = org_obs(1:3);
    enemy_pos = org_obs(14:16);
    distance = norm(enemy_pos - my_pos);
    if distance > 100
        isdone = 1;
        return;
    end
    
    % 继续训练
    isdone = 0;
end