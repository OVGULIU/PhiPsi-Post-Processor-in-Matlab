% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function [Num] = Cal_Ele_Num_by_Coors(X,Y)
% This function calculate the element num by the coordinates of the point inside the element.

global G_NN G_X_NODES G_Y_NODES G_X_Min G_X_Max G_Y_Min G_Y_Max

Num       = 0;
tem     = intersect(intersect(find(G_X_Min<=X),find(G_X_Max>=X)), ...
                    intersect(find(G_Y_Min<=Y),find(G_Y_Max>=Y)));
	
for i=1:size(tem,2)
	[Yes_In Yes_On]= inpolygon(X,Y,G_X_NODES(:,tem(i)),G_Y_NODES(:,tem(i)));  
    if Yes_In ==1 || Yes_On==1
		Num = tem(i);
		break
	end
end	
