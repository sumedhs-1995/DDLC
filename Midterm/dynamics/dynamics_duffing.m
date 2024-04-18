function [dxdt,u] = dynamics_duffing(t,x,a, f,data_type)
u_max = a;
u_min = -a;
if strcmp(data_type,'train')
    % u = u_min + (u_max - u_min)*rand(length(t),1);
    u = a*sin(f*t);
elseif strcmp(data_type,'test')
    u = a*sin(f*t);
    % u = u_min + (u_max - u_min)*rand(length(t),1);
else
    error('Invalid Data Type')
end
x1 = x(2);
x2 = x(1)-(x(1))^3 -0.5*x(2) + u;
dxdt = [x1;x2];
end