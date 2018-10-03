function [g,ceq] = nonlcon(x)

global E v T t_lim theta_lim pi G


%------------
G = E/2.0/(1.0+v);       % 剪切弹性模量.
g = [16*T/pi*x(1)/(x(1)^4 - x(2)^4)-t_lim; ...
     32*T*180/pi/pi/G/(x(1)^4 - x(2)^4)-theta_lim];
ceq =[];

