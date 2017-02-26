% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function [Signed_Distance] = Cal_Signed_Distance(Line_AB,Point_C)
% This function calculates the signed distance from the Point_C to the Line_AB.

Signed_Distance = det([Line_AB(2,:)-Line_AB(1,:);Point_C-Line_AB(1,:)])/norm(Line_AB(2,:)-Line_AB(1,:));