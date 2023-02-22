function [res] = Private_EvalExpEquation (exp, x)
% x can hold 2 values :  1,0 for up-regulated and not
    if (~( strcmp (exp , '') ) & ~isempty(exp))%如果exp非空且不是空字符串
       res = eval(exp);%将字符串转为逻辑语句直接出结果
       
    else
       res = 0;
    end
end

function res = and(a,b)
    res = min(a,b);
end 

function res = or(a,b)
    res = max(a,b);
end
