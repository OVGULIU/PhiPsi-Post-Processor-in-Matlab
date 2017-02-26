% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_Mesh3D(isub,Crack_X,Crack_Y,Crack_Z,Post_Enriched_Nodes,POS)
% This function plots the initial geometry,三维.

global Node_Coor Elem_Node Key_POST_HF
global Num_Node Num_Elem
global Min_X_Coor Max_X_Coor Min_Y_Coor Max_Y_Coor Min_Z_Coor Max_Z_Coor
global Key_PLOT aveg_area_ele
global Size_Font Elem_Fontcolor Elem_Fontsize Node_Fontcolor Node_Fontsize
global num_Crack num_of_Material
global Color_Crack Width_Crack Full_Pathname
global Color_Backgro_Mesh_1 Color_Backgro_Mesh_2 Color_Backgro_Mesh_3 Color_Backgro_Mesh_4
global Color_Backgro_Mesh_5 Color_Backgro_Mesh_6 Color_Backgro_Mesh_7
global Color_Backgro_Mesh_8 Color_Backgro_Mesh_9 Color_Backgro_Mesh_10
global Elem_Material Num_Step_to_Plot

% global Tri_BCD
disp(['      ----- Plotting undeformed mesh......'])
xi_1 =[];yi_1 =[];zi_1 =[];
xi_2 =[];yi_2 =[];zi_2 =[];
xi_3 =[];yi_3 =[];zi_3 =[];
xi_4 =[];yi_4 =[];zi_4 =[];
xi_5 =[];yi_5 =[];zi_5 =[];
xi_6 =[];yi_6 =[];zi_6 =[];
xi_7 =[];yi_7 =[];zi_7 =[];
xi_8 =[];yi_8 =[];zi_8 =[];
xi_9 =[];yi_9 =[];zi_9 =[];
xi_10 =[];yi_10 =[];zi_10 =[];

c_X_Length = Max_X_Coor-Min_X_Coor;
c_Y_Length = Max_Y_Coor-Min_Y_Coor;
c_Z_Length = Max_Z_Coor-Min_Z_Coor;

% New figure.
Tools_New_Figure
hold on;
title('\it Finite Element Mesh','FontName','Times New Roman','FontSize',Size_Font)
axis off; axis equal;
delta = sqrt(aveg_area_ele);
axis([Min_X_Coor-delta Max_X_Coor+delta ...
      Min_Y_Coor-delta Max_Y_Coor+delta ...
	  Min_Z_Coor-delta Max_Z_Coor+delta]);
	  
%绘制坐标轴
plot3([0,c_X_Length/5],[0,0] , [0,0],'LineWidth',2.0,'Color','red');
plot3([0,0],[0,c_Y_Length/5] , [0,0],'LineWidth',2.0,'Color','green');
plot3([0,0],[0,0] , [0,c_Z_Length/5],'LineWidth',2.0,'Color','blue');
	  
%绘制单元网格
Line_width =0.1;
for iElem = 1:Num_Elem
    NN = [Elem_Node(iElem,1) Elem_Node(iElem,2) ...
	      Elem_Node(iElem,3) Elem_Node(iElem,4) ...
		  Elem_Node(iElem,5) Elem_Node(iElem,6) ...
		  Elem_Node(iElem,7) Elem_Node(iElem,8)];                             % Nodes for current element
	for i=1:3
		plot3([Node_Coor(NN(i),1),Node_Coor(NN(i+1),1)],...
			  [Node_Coor(NN(i),2),Node_Coor(NN(i+1),2)],...
			  [Node_Coor(NN(i),3),Node_Coor(NN(i+1),3)],'LineWidth',Line_width,'Color','black')	
	end
	for i=5:7
		plot3([Node_Coor(NN(i),1),Node_Coor(NN(i+1),1)],...
			  [Node_Coor(NN(i),2),Node_Coor(NN(i+1),2)],...
			  [Node_Coor(NN(i),3),Node_Coor(NN(i+1),3)],'LineWidth',Line_width,'Color','black')	
	end
	for i=1:4
		plot3([Node_Coor(NN(i),1),Node_Coor(NN(i+4),1)],...
			  [Node_Coor(NN(i),2),Node_Coor(NN(i+4),2)],...
			  [Node_Coor(NN(i),3),Node_Coor(NN(i+4),3)],'LineWidth',Line_width,'Color','black')	
	end	
	plot3([Node_Coor(NN(1),1),Node_Coor(NN(4),1)],...
		  [Node_Coor(NN(1),2),Node_Coor(NN(4),2)],...
		  [Node_Coor(NN(1),3),Node_Coor(NN(4),3)],'LineWidth',Line_width,'Color','black')		
		  
	plot3([Node_Coor(NN(5),1),Node_Coor(NN(8),1)],...
		  [Node_Coor(NN(5),2),Node_Coor(NN(8),2)],...
		  [Node_Coor(NN(5),3),Node_Coor(NN(8),3)],'LineWidth',Line_width,'Color','black')	
end 
%绘制单元面
Color_3D_ele_face = [189/255,252/255,201/255];
FaceAlpha_3D_ele_face = 0.8;
if Key_PLOT(1,3) == 1
  for iElem = 1:Num_Elem
    NN = [Elem_Node(iElem,1) Elem_Node(iElem,2) ...
	      Elem_Node(iElem,3) Elem_Node(iElem,4) ...
		  Elem_Node(iElem,5) Elem_Node(iElem,6) ...
		  Elem_Node(iElem,7) Elem_Node(iElem,8)];                             % Nodes for current element
		  %绘制第1个面
		  c_x = [Node_Coor(NN(1),1),Node_Coor(NN(2),1),Node_Coor(NN(3),1),Node_Coor(NN(4),1)];
		  c_y = [Node_Coor(NN(1),2),Node_Coor(NN(2),2),Node_Coor(NN(3),2),Node_Coor(NN(4),2)];
		  c_z = [Node_Coor(NN(1),3),Node_Coor(NN(2),3),Node_Coor(NN(3),3),Node_Coor(NN(4),3)];
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  %绘制第2个面
		  c_x = [Node_Coor(NN(5),1),Node_Coor(NN(6),1),Node_Coor(NN(7),1),Node_Coor(NN(8),1)];
		  c_y = [Node_Coor(NN(5),2),Node_Coor(NN(6),2),Node_Coor(NN(7),2),Node_Coor(NN(8),2)];
		  c_z = [Node_Coor(NN(5),3),Node_Coor(NN(6),3),Node_Coor(NN(7),3),Node_Coor(NN(8),3)];
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  %绘制第3个面
		  c_x = [Node_Coor(NN(1),1),Node_Coor(NN(2),1),Node_Coor(NN(6),1),Node_Coor(NN(5),1)];
		  c_y = [Node_Coor(NN(1),2),Node_Coor(NN(2),2),Node_Coor(NN(6),2),Node_Coor(NN(5),2)];
		  c_z = [Node_Coor(NN(1),3),Node_Coor(NN(2),3),Node_Coor(NN(6),3),Node_Coor(NN(5),3)];
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  %绘制第4个面
		  c_x = [Node_Coor(NN(2),1),Node_Coor(NN(3),1),Node_Coor(NN(7),1),Node_Coor(NN(6),1)];
		  c_y = [Node_Coor(NN(2),2),Node_Coor(NN(3),2),Node_Coor(NN(7),2),Node_Coor(NN(6),2)];
		  c_z = [Node_Coor(NN(2),3),Node_Coor(NN(3),3),Node_Coor(NN(7),3),Node_Coor(NN(6),3)];
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  %绘制第5个面
		  c_x = [Node_Coor(NN(7),1),Node_Coor(NN(8),1),Node_Coor(NN(4),1),Node_Coor(NN(3),1)];
		  c_y = [Node_Coor(NN(7),2),Node_Coor(NN(8),2),Node_Coor(NN(4),2),Node_Coor(NN(3),2)];
		  c_z = [Node_Coor(NN(7),3),Node_Coor(NN(8),3),Node_Coor(NN(4),3),Node_Coor(NN(3),3)];
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  %绘制第6个面
		  c_x = [Node_Coor(NN(5),1),Node_Coor(NN(1),1),Node_Coor(NN(4),1),Node_Coor(NN(8),1)];
		  c_y = [Node_Coor(NN(5),2),Node_Coor(NN(1),2),Node_Coor(NN(4),2),Node_Coor(NN(8),2)];
		  c_z = [Node_Coor(NN(5),3),Node_Coor(NN(1),3),Node_Coor(NN(4),3),Node_Coor(NN(8),3)];
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
  end 
end
%绘制裂缝面
if Key_PLOT(1,5) == 1
    disp(['      ----- Plotting crack surface...'])
	if isempty(Crack_X)==0
		for i = 1:num_Crack(isub)
			nPt = size(Crack_X{i},2);
			%目前一个裂缝只能由4个点构成
			c_x = [Crack_X{i}(1:4)];
			c_y = [Crack_Y{i}(1:4)];
			c_z = [Crack_Z{i}(1:4)];
			fill3(c_x,c_y,c_z,'r','FaceAlpha',0.8,'FaceLighting','gouraud')
		end	
	end
end
                        
% Plot the node numbers.
% if Key_PLOT(1,1) ==1 && Key_PLOT(1,2) == 1
    % disp(['      ----- Plotting node number...'])
    % for iNode = 1:Num_Node
        % text(Node_Coor(iNode,1)+0.05*delta,Node_Coor(iNode,2),1,num2str(iNode),...
		              % 'FontName','Times New Roman','FontSize',Node_Fontsize,'color',Node_Fontcolor)
    % end
% end

% Plot the element numbers.
% if Key_PLOT(1,1) ==1 && Key_PLOT(1,3) == 1
    % disp(['      ----- Plotting element number...'])
    % for iElem = 1:Num_Elem
        % NN = [Elem_Node(iElem,1) Elem_Node(iElem,2) ...
	          % Elem_Node(iElem,3) Elem_Node(iElem,4)];
        % XN = Node_Coor(NN,1);
        % YN = Node_Coor(NN,2);
        % text(mean(XN),mean(YN),1,num2str(iElem),'FontName','Times New Roman','FontSize',Elem_Fontsize,'color',Elem_Fontcolor)
    % end
% end

% Plot nodes
if isempty(Post_Enriched_Nodes) ~= 1
    length_min = min(c_X_Length,min(c_Y_Length,c_Z_Length))/5.0; 
	r = length_min/20;
    if Key_PLOT(1,2)==1
		disp(['      ----- Plotting nodes......'])
		for i =1 :size(Post_Enriched_Nodes,2)
			for j =1:Num_Node
				x_node = Node_Coor(j,1);                                          
				y_node = Node_Coor(j,2);  
                z_node = Node_Coor(j,3);  				
				[sphere_x,sphere_y,sphere_z] = sphere;
			    s1 = surf(sphere_x*r + x_node, sphere_y*r + y_node, sphere_z*r + z_node);
				set(s1,'FaceColor',[3/255,168/255,158/255], ...
						  'FaceAlpha',1,'FaceLighting','gouraud','EdgeColor','none')  %FaceAlpha表示透明度
				daspect([1 1 1]);	
			end
		end
	end
end


% Plot enriched nodes
if isempty(Post_Enriched_Nodes) ~= 1
    length_min = min(c_X_Length,min(c_Y_Length,c_Z_Length))/5.0; 
	r = length_min/10;
    if Key_PLOT(1,8)==1
		disp(['      ----- Plotting enriched nodes......'])
		for i =1 :size(Post_Enriched_Nodes,2)
			for j =1:Num_Node
				x_node = Node_Coor(j,1);                                          
				y_node = Node_Coor(j,2);  
                z_node = Node_Coor(j,3);  				
				if Post_Enriched_Nodes(j,i)==1     % Tip nodes
				% plot(x_node,y_node,'bs')
					[sphere_x,sphere_y,sphere_z] = sphere;
					surf(sphere_x*r + x_node, sphere_y*r + y_node, sphere_z*r + z_node);
				elseif Post_Enriched_Nodes(j,i)==2 % Heaviside nodes
					[sphere_x,sphere_y,sphere_z] = sphere;
					s1 = surf(sphere_x*r + x_node, sphere_y*r + y_node, sphere_z*r + z_node);
					set(s1,'FaceColor',[0 0 1], ...
						  'FaceAlpha',1,'FaceLighting','gouraud','EdgeColor','none')  %FaceAlpha表示透明度
					daspect([1 1 1]);	  
				elseif Post_Enriched_Nodes(j,i)==3 % Junction nodes
					[sphere_x,sphere_y,sphere_z] = sphere;
					surf(sphere_x*r + x_node, sphere_y*r + y_node, sphere_z*r + z_node);
				end
			end
		end
	end
end

% Plot Gauss points.
if Key_PLOT(1,4) == 1
    disp(['      ----- Plotting Gauss points...'])
    % Read gauss point coordinates file.
	Gauss_Coor = load([Full_Pathname,'.gcor_',num2str(isub)]);
	plot(Gauss_Coor(:,2),Gauss_Coor(:,3),'bo','MarkerSize',1,'Color','black')

	clear Gauss_Coor
end



% Save pictures.
Save_Picture(c_figure,Full_Pathname,'mesh')
