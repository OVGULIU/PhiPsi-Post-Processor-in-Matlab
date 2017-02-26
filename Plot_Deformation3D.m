% Written By: Shi Fang, 2016-10-24
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_Deformation3D(isub,Crack_X,Crack_Y,Crack_Z,Post_Enriched_Nodes,POS)
%绘制三维变形图.

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
global Elem_Material Num_Step_to_Plot DISP Num_Foc_z
global Num_Foc_x Num_Foc_y Foc_x Foc_y Num_Foc_z Foc_z FORCE_Matrix

% global Tri_BCD
disp(['      ----- Plotting deformed mesh......'])
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

scale = Key_PLOT(2,6);

% Get the new coordinates of all nodes.
New_Node_Coor(1:Num_Node,1) = Node_Coor(1:Num_Node,1) + scale*DISP(1:Num_Node,2);
New_Node_Coor(1:Num_Node,2) = Node_Coor(1:Num_Node,2) + scale*DISP(1:Num_Node,3);
New_Node_Coor(1:Num_Node,3) = Node_Coor(1:Num_Node,3) + scale*DISP(1:Num_Node,4);


% Get the maximum and minimum value of the new coordinates of all nodes.
Min_X_Coor_New = min(min(New_Node_Coor(1:Num_Node,1)));
Max_X_Coor_New = max(max(New_Node_Coor(1:Num_Node,1)));
Min_Y_Coor_New = min(min(New_Node_Coor(1:Num_Node,2)));
Max_Y_Coor_New = max(max(New_Node_Coor(1:Num_Node,2)));
Min_Z_Coor_New = min(min(New_Node_Coor(1:Num_Node,3)));
Max_Z_Coor_New = max(max(New_Node_Coor(1:Num_Node,3)));

c_X_Length = Max_X_Coor_New-Min_X_Coor_New;
c_Y_Length = Max_Y_Coor_New-Min_Y_Coor_New;
c_Z_Length = Max_Z_Coor_New-Min_Z_Coor_New;
	
	% length of force arrow
    % REMOVE:length_arrow = sqrt(max_area_ele);
	     
% New figure.
Tools_New_Figure
hold on;
title('\it Deformation','FontName','Times New Roman','FontSize',Size_Font)
axis off; axis equal;
delta = sqrt(aveg_area_ele);
axis([Min_X_Coor_New-delta Max_X_Coor_New+delta ...
      Min_Y_Coor_New-delta Max_Y_Coor_New+delta ...
	  Min_Z_Coor_New-delta Max_Z_Coor_New+delta]);

%绘制单元面
Color_3D_ele_face = [189/255,252/255,201/255];
FaceAlpha_3D_ele_face = 0.8;
if Key_PLOT(2,3) == 1
  for iElem = 1:Num_Elem
    NN = [Elem_Node(iElem,1) Elem_Node(iElem,2) ...
	      Elem_Node(iElem,3) Elem_Node(iElem,4) ...
		  Elem_Node(iElem,5) Elem_Node(iElem,6) ...
		  Elem_Node(iElem,7) Elem_Node(iElem,8)];                             % Nodes for current element
		  %绘制第1个面
		  c_x = [New_Node_Coor(NN(1),1),New_Node_Coor(NN(2),1),New_Node_Coor(NN(3),1),New_Node_Coor(NN(4),1)];
		  c_y = [New_Node_Coor(NN(1),2),New_Node_Coor(NN(2),2),New_Node_Coor(NN(3),2),New_Node_Coor(NN(4),2)];
		  c_z = [New_Node_Coor(NN(1),3),New_Node_Coor(NN(2),3),New_Node_Coor(NN(3),3),New_Node_Coor(NN(4),3)];
		  % fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face)
		  %绘制第2个面
		  c_x = [New_Node_Coor(NN(5),1),New_Node_Coor(NN(6),1),New_Node_Coor(NN(7),1),New_Node_Coor(NN(8),1)];
		  c_y = [New_Node_Coor(NN(5),2),New_Node_Coor(NN(6),2),New_Node_Coor(NN(7),2),New_Node_Coor(NN(8),2)];
		  c_z = [New_Node_Coor(NN(5),3),New_Node_Coor(NN(6),3),New_Node_Coor(NN(7),3),New_Node_Coor(NN(8),3)];
		  % fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face)
		  %绘制第3个面
		  c_x = [New_Node_Coor(NN(1),1),New_Node_Coor(NN(2),1),New_Node_Coor(NN(6),1),New_Node_Coor(NN(5),1)];
		  c_y = [New_Node_Coor(NN(1),2),New_Node_Coor(NN(2),2),New_Node_Coor(NN(6),2),New_Node_Coor(NN(5),2)];
		  c_z = [New_Node_Coor(NN(1),3),New_Node_Coor(NN(2),3),New_Node_Coor(NN(6),3),New_Node_Coor(NN(5),3)];
		  % fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face)
		  %绘制第4个面
		  c_x = [New_Node_Coor(NN(2),1),New_Node_Coor(NN(3),1),New_Node_Coor(NN(7),1),New_Node_Coor(NN(6),1)];
		  c_y = [New_Node_Coor(NN(2),2),New_Node_Coor(NN(3),2),New_Node_Coor(NN(7),2),New_Node_Coor(NN(6),2)];
		  c_z = [New_Node_Coor(NN(2),3),New_Node_Coor(NN(3),3),New_Node_Coor(NN(7),3),New_Node_Coor(NN(6),3)];
		  % fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face)
		  %绘制第5个面
		  c_x = [New_Node_Coor(NN(7),1),New_Node_Coor(NN(8),1),New_Node_Coor(NN(4),1),New_Node_Coor(NN(3),1)];
		  c_y = [New_Node_Coor(NN(7),2),New_Node_Coor(NN(8),2),New_Node_Coor(NN(4),2),New_Node_Coor(NN(3),2)];
		  c_z = [New_Node_Coor(NN(7),3),New_Node_Coor(NN(8),3),New_Node_Coor(NN(4),3),New_Node_Coor(NN(3),3)];
		  % fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face)
		  %绘制第6个面
		  c_x = [New_Node_Coor(NN(5),1),New_Node_Coor(NN(1),1),New_Node_Coor(NN(4),1),New_Node_Coor(NN(8),1)];
		  c_y = [New_Node_Coor(NN(5),2),New_Node_Coor(NN(1),2),New_Node_Coor(NN(4),2),New_Node_Coor(NN(8),2)];
		  c_z = [New_Node_Coor(NN(5),3),New_Node_Coor(NN(1),3),New_Node_Coor(NN(4),3),New_Node_Coor(NN(8),3)];
		  % fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face,'FaceLighting','gouraud')
		  fill3(c_x,c_y,c_z,Color_3D_ele_face,'FaceAlpha',FaceAlpha_3D_ele_face)
  end 
end
%绘制变形后的网格
Line_width =0.1;
if Key_PLOT(2,1)==1
	for iElem = 1:Num_Elem
		NN = [Elem_Node(iElem,1) Elem_Node(iElem,2) ...
			  Elem_Node(iElem,3) Elem_Node(iElem,4) ...
			  Elem_Node(iElem,5) Elem_Node(iElem,6) ...
			  Elem_Node(iElem,7) Elem_Node(iElem,8)];                             % Nodes for current element
		for i=1:3
			plot3([New_Node_Coor(NN(i),1),New_Node_Coor(NN(i+1),1)],...
				  [New_Node_Coor(NN(i),2),New_Node_Coor(NN(i+1),2)],...
				  [New_Node_Coor(NN(i),3),New_Node_Coor(NN(i+1),3)],'LineWidth',Line_width,'Color','black')	
		end
		for i=5:7
			plot3([New_Node_Coor(NN(i),1),New_Node_Coor(NN(i+1),1)],...
				  [New_Node_Coor(NN(i),2),New_Node_Coor(NN(i+1),2)],...
				  [New_Node_Coor(NN(i),3),New_Node_Coor(NN(i+1),3)],'LineWidth',Line_width,'Color','black')	
		end
		for i=1:4
			plot3([New_Node_Coor(NN(i),1),New_Node_Coor(NN(i+4),1)],...
				  [New_Node_Coor(NN(i),2),New_Node_Coor(NN(i+4),2)],...
				  [New_Node_Coor(NN(i),3),New_Node_Coor(NN(i+4),3)],'LineWidth',Line_width,'Color','black')	
		end	
		plot3([New_Node_Coor(NN(1),1),New_Node_Coor(NN(4),1)],...
			  [New_Node_Coor(NN(1),2),New_Node_Coor(NN(4),2)],...
			  [New_Node_Coor(NN(1),3),New_Node_Coor(NN(4),3)],'LineWidth',Line_width,'Color','black')		
		plot3([New_Node_Coor(NN(5),1),New_Node_Coor(NN(8),1)],...
			  [New_Node_Coor(NN(5),2),New_Node_Coor(NN(8),2)],...
			  [New_Node_Coor(NN(5),3),New_Node_Coor(NN(8),3)],'LineWidth',Line_width,'Color','black')		
	end 
end
%绘制变形前的网格
Line_width =0.1;
if Key_PLOT(2,8)==1
	for iElem = 1:Num_Elem
		NN = [Elem_Node(iElem,1) Elem_Node(iElem,2) ...
			  Elem_Node(iElem,3) Elem_Node(iElem,4) ...
			  Elem_Node(iElem,5) Elem_Node(iElem,6) ...
			  Elem_Node(iElem,7) Elem_Node(iElem,8)];                             % Nodes for current element
		for i=1:3
			plot3([Node_Coor(NN(i),1),Node_Coor(NN(i+1),1)],...
				  [Node_Coor(NN(i),2),Node_Coor(NN(i+1),2)],...
				  [Node_Coor(NN(i),3),Node_Coor(NN(i+1),3)],'LineWidth',Line_width,'Color','red')	
		end
		for i=5:7
			plot3([Node_Coor(NN(i),1),Node_Coor(NN(i+1),1)],...
				  [Node_Coor(NN(i),2),Node_Coor(NN(i+1),2)],...
				  [Node_Coor(NN(i),3),Node_Coor(NN(i+1),3)],'LineWidth',Line_width,'Color','red')	
		end
		for i=1:4
			plot3([Node_Coor(NN(i),1),Node_Coor(NN(i+4),1)],...
				  [Node_Coor(NN(i),2),Node_Coor(NN(i+4),2)],...
				  [Node_Coor(NN(i),3),Node_Coor(NN(i+4),3)],'LineWidth',Line_width,'Color','red')	
		end	
		plot3([Node_Coor(NN(1),1),Node_Coor(NN(4),1)],...
			  [Node_Coor(NN(1),2),Node_Coor(NN(4),2)],...
			  [Node_Coor(NN(1),3),Node_Coor(NN(4),3)],'LineWidth',Line_width,'Color','red')		
		plot3([Node_Coor(NN(5),1),Node_Coor(NN(8),1)],...
			  [Node_Coor(NN(5),2),Node_Coor(NN(8),2)],...
			  [Node_Coor(NN(5),3),Node_Coor(NN(8),3)],'LineWidth',Line_width,'Color','red')		
	end 
end

%绘制坐标轴
plot3([0,c_X_Length/5],[0,0] , [0,0],'LineWidth',5.0,'Color','red');
plot3([0,0],[0,c_Y_Length/5] , [0,0],'LineWidth',5.0,'Color','green');
plot3([0,0],[0,0] , [0,c_Z_Length/5],'LineWidth',5.0,'Color','blue');

%绘制载荷
if Key_PLOT(2,7) == 1 || Key_PLOT(2,7) == 3
    disp(['      ----- Plotting forces of nodes......'])
    Max_x_Force = max(abs(FORCE_Matrix(:,1)));
	Max_y_Force = max(abs(FORCE_Matrix(:,2)));
	Max_z_Force = max(abs(FORCE_Matrix(:,3)));
	Max_Force   = max(Max_x_Force,max(Max_y_Force,Max_z_Force));
	
	% length of force arrow
    % REMOVE:length_arrow = sqrt(max_area_ele);
	length_arrow = max(c_X_Length,max(c_Y_Length,c_Z_Length))/7.0;          
	
	% Loop through each node.
	for i = 1:Num_Node
	    if FORCE_Matrix(i,4) ~=0           % If the nodes has force load, then:
			c_force_x   = FORCE_Matrix(i,1);
			c_force_y   = FORCE_Matrix(i,2);
            c_force_z   = FORCE_Matrix(i,3);
			delta_L_x = c_force_x*length_arrow/Max_Force;
			delta_L_y = c_force_y*length_arrow/Max_Force;
			delta_L_z = c_force_z*length_arrow/Max_Force;
			
			StartPoint = [New_Node_Coor(i,1)-delta_L_x   New_Node_Coor(i,2)-delta_L_y     New_Node_Coor(i,3)-delta_L_z];
			EndPoint   = [New_Node_Coor(i,1)             New_Node_Coor(i,2)               New_Node_Coor(i,3)          ];
			plot3([StartPoint(1),EndPoint(1)],[StartPoint(2),EndPoint(2)], [StartPoint(3),EndPoint(3)],'LineWidth',2.0,'Color',[153/255,51/255,250/255]);
		end	
	end
end

% Plot nodes
if isempty(Post_Enriched_Nodes) ~= 1
    length_min = min(c_X_Length,min(c_Y_Length,c_Z_Length))/5.0; 
	r = length_min/20;
    if Key_PLOT(2,2)==1
		disp(['      ----- Plotting nodes......'])
		for i =1 :size(Post_Enriched_Nodes,2)
			for j =1:Num_Node
				x_node = New_Node_Coor(j,1);                                          
				y_node = New_Node_Coor(j,2);  
                z_node = New_Node_Coor(j,3);  				
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
    if Key_PLOT(2,14)==1
		disp(['      ----- Plotting enriched nodes......'])
		for i =1 :size(Post_Enriched_Nodes,2)
			for j =1:Num_Node
				x_node = New_Node_Coor(j,1);                                          
				y_node = New_Node_Coor(j,2);  
                z_node = New_Node_Coor(j,3);  				
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


%绘制裂缝面
if Key_PLOT(2,5) == 1
    disp(['      ----- Plotting crack surface...'])
	if isempty(Crack_X)==0
		for i = 1:num_Crack(isub)
			nPt = size(Crack_X{i},2);
			%目前一个裂缝只能由4个点构成
			c_x = [Crack_X{i}(1:4)];
			c_y = [Crack_Y{i}(1:4)];
			c_z = [Crack_Z{i}(1:4)] ;
			fill3(c_x,c_y,c_z,'r','FaceAlpha',0.8,'FaceLighting','gouraud')
		end	
	end
end


% patch(xi_1(:,1),yi_1(:,1),zi_1(:,1),Color_Backgro_Mesh_1) 
% mesh(xi_1(:,1),yi_1(:,1),zi_1(:,1),Color_Backgro_Mesh_1) 

% Plot elements.  
disp(['      ----- Plotting elements...'])
% patch(xi_1,yi_1,zi_1,Color_Backgro_Mesh_1) 
% patch(xi_2,yi_2,zi_2,Color_Backgro_Mesh_2)    
% patch(xi_3,yi_3,zi_3,Color_Backgro_Mesh_3)   
% patch(xi_4,yi_4,zi_4,Color_Backgro_Mesh_4)  
% patch(xi_5,yi_5,zi_5,Color_Backgro_Mesh_5)  
% patch(xi_6,yi_6,zi_6,Color_Backgro_Mesh_6)  
% patch(xi_7,yi_7,zi_7,Color_Backgro_Mesh_7)     
% patch(xi_8,yi_8,zi_8,Color_Backgro_Mesh_8) 
% patch(xi_9,yi_9,zi_9,Color_Backgro_Mesh_9) 
% patch(xi_10,yi_10,zi_10,Color_Backgro_Mesh_10)
% plot3(xi_1,yi_1,zi_1,Color_Backgro_Mesh_1) 
% plot3(xi_2,yi_2,zi_2,Color_Backgro_Mesh_2)    
% plot3(xi_3,yi_3,zi_3,Color_Backgro_Mesh_3)   
% plot3(xi_4,yi_4,zi_4,Color_Backgro_Mesh_4)  
% plot3(xi_5,yi_5,zi_5,Color_Backgro_Mesh_5)  
% plot3(xi_6,yi_6,zi_6,Color_Backgro_Mesh_6)  
% plot3(xi_7,yi_7,zi_7,Color_Backgro_Mesh_7)     
% plot3(xi_8,yi_8,zi_8,Color_Backgro_Mesh_8) 
% plot3(xi_9,yi_9,zi_9,Color_Backgro_Mesh_9) 
% plot3(xi_10,yi_10,zi_10,Color_Backgro_Mesh_10)

% Plot Tri_BCD.
% patch(Tri_BCD(:,1),Tri_BCD(:,2),[235/255 142/255 85/255]);    % ****************************
                        


% Save pictures.
Save_Picture(c_figure,Full_Pathname,'defm')
