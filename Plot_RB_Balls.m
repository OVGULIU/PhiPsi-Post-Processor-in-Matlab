% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_RB_Balls(isub,Model_W,Model_H)
% This function plots the initial geometry.

global Node_Coor Elem_Node Key_POST_HF
global Num_Node Num_Elem
global Min_X_Coor Max_X_Coor Min_Y_Coor Max_Y_Coor
global Key_PLOT aveg_area_ele Outline
global Size_Font Elem_Fontcolor Elem_Fontsize Node_Fontcolor Node_Fontsize
global num_Crack num_of_Material
global Color_Crack Width_Crack Full_Pathname
global Color_Backgro_Mesh_1 Color_Backgro_Mesh_2 Color_Backgro_Mesh_3 Color_Backgro_Mesh_4
global Color_Backgro_Mesh_5 Color_Backgro_Mesh_6 Color_Backgro_Mesh_7
global Color_Backgro_Mesh_8 Color_Backgro_Mesh_9 Color_Backgro_Mesh_10
global Elem_Material Num_Step_to_Plot
global Na_Crack_X Na_Crack_Y num_Na_Crack

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% Preparing.
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% New figure.
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Tools_New_Figure
hold on;
title('\it Finite Element Mesh','FontName','Times New Roman','FontSize',Size_Font)
axis off; axis equal;
delta = sqrt(aveg_area_ele);
axis([0.0 Model_W 0.0 Model_H]);


disp(['      ----- Plotting balls...'])
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%         绘制外边框
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
line([0,Model_W],      [0,0],'LineWidth',1.0,'Color','black')
line([Model_W,Model_W],[0,Model_H],'LineWidth',1.0,'Color','black')
line([Model_W,0],[Model_H,Model_H],'LineWidth',1.0,'Color','black')
line([0,0],[Model_H,0],'LineWidth',1.0,'Color','black')
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%         绘制支撑剂的圆球
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if Key_PLOT(1,1)==1 
	% 如果相关文件存在
	if exist([Full_Pathname,'.rbco_',num2str(isub)], 'file') ==2 
        % 读取文件		
		c_Data=load([Full_Pathname,'.rbco_',num2str(isub)]);
        num_ball = size(c_Data,1);
        for i=1:num_ball
			% 绘制实心圆
			alpha=0:pi/20:2*pi;
			Coor_x =  c_Data(i,1);
			Coor_y =  c_Data(i,2);
		    R =  c_Data(i,3);
			
			x = Coor_x + R*cos(alpha);
			y = Coor_y + R*sin(alpha);
			
			plot(x,y,'-')
			axis equal
			fill(x,y,[128/255,138/255,135/255])
		end
	end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%        Save pictures.
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Save_Picture(c_figure,Full_Pathname,'ball')
