% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_Main(POST_Substep)
% This function plots mesh, contours, vectors and so on.

global Key_PLOT Full_Pathname Num_Node Num_Foc_x Num_Foc_y Foc_x Foc_y
global num_Crack Key_Dynamic Real_Iteras Real_Sub Key_Contour_Metd
global Output_Freq num_Output_Sub Key_Crush num_Na_Crack
global Na_Crack_X Na_Crack_Y
global num_Hole Hole_Coor Enriched_Node_Type_Hl POS_Hl Elem_Type_Hl 
global Field_Value
global num_Circ_Inclusion Circ_Inclu_Coor Enriched_Node_Type_Incl Elem_Type_Incl POS_Incl
global num_Poly_Inclusion Poly_Incl_Coor_x Poly_Incl_Coor_y 
global Yes_Field_Problem
global Field_Boundary_Value
global Field_Boundary_Qn
global Field_Flux_x Field_Flux_y

scale = Key_PLOT(2,6);
Yes_Field_Problem = 0;
% Get the number of the substep for post process.
if isa(POST_Substep,'double') == 0
    if length(POST_Substep) == 4
		if  lower(POST_Substep)  ==  'last'
			if Key_Dynamic ==1
			    if Output_Freq  ==0
				    POST_Substep = Real_Iteras;
				else
				    POST_Substep = num_Output_Sub;
				end
			elseif Key_Dynamic ==0
			    if Output_Freq==0
				    POST_Substep = Real_Sub;
				else
			    	POST_Substep = num_Output_Sub;
				end
			end
		else
		    disp('    Error :: Unrecognized parameters of *POST_Substep.') 
		    Error_Message
		end
	elseif length(POST_Substep) == 5
		if  lower(POST_Substep) == 'first'
			POST_Substep = 1;
		else 
			disp('    Error :: Unrecognized parameters of *POST_Substep.') 
		    Error_Message
		end
	else
	    disp('    Error :: Unrecognized parameters of *POST_Substep.') 
		Error_Message
	end
end

% Read displacement file.
if exist([Full_Pathname,'.disn_',num2str(POST_Substep)], 'file') ==2
    disp('    > Reading displacement file....') 
    DISP= load([Full_Pathname,'.disn_',num2str(POST_Substep)]);
else
    DISP =[];
end

% Read field value file.
if exist([Full_Pathname,'.fdvl_',num2str(POST_Substep)], 'file') ==2
    disp('    > Reading field value file....') 
    Field_Value= load([Full_Pathname,'.fdvl_',num2str(POST_Substep)]);
	Yes_Field_Problem = 1;
else
    Field_Value=[];
end

% 读取场问题x方向流量文件.
if exist([Full_Pathname,'.fbfx_',num2str(POST_Substep)], 'file') ==2
    disp('    > Reading field fbfx file....') 
    Field_Flux_x = load([Full_Pathname,'.fbfx_',num2str(POST_Substep)]);
else
    Field_Flux_x=[];
end

% 读取场问题y方向流量文件.
if exist([Full_Pathname,'.fbfy_',num2str(POST_Substep)], 'file') ==2
    disp('    > Reading field fbfy file....') 
    Field_Flux_y = load([Full_Pathname,'.fbfy_',num2str(POST_Substep)]);
else
    Field_Flux_y=[];
end

% 场问题边值边界条件.
if exist([Full_Pathname,'.fbvl'], 'file') ==2
    disp('    > Reading field value file....') 
    Field_Boundary_Value= load([Full_Pathname,'.fbvl']);
else
    Field_Boundary_Value=[];
end

% 场问题边界流量.
if exist([Full_Pathname,'.fbqn'], 'file') ==2
    disp('    > Reading field value file....') 
    Field_Boundary_Qn= load([Full_Pathname,'.fbqn']);
else
    Field_Boundary_Qn=[];
end

% Read force file.
disp('    > Reading force file....') 
if exist([Full_Pathname,'.focx'], 'file') ==2 
    Force_X_Matrix = load([Full_Pathname,'.focx']);
end
if exist([Full_Pathname,'.focy'], 'file') ==2 
    Force_Y_Matrix = load([Full_Pathname,'.focy']);
end

% Read Boundary file.
disp('    > Reading Boundary file....') 
if exist([Full_Pathname,'.boux'], 'file') ==2  
    Boundary_X_Matrix = load([Full_Pathname,'.boux']);
end
if exist([Full_Pathname,'.bouy'], 'file') ==2  
    Boundary_Y_Matrix = load([Full_Pathname,'.bouy']);
end

% Read coordinates and other info of cracks if cracks exist.
if num_Crack(POST_Substep) ~= 0
	disp('    > Reading coordinates of cracks....') 
	file_Crack_X = fopen([Full_Pathname,'.crax_',num2str(POST_Substep)]);
	file_Crack_Y = fopen([Full_Pathname,'.cray_',num2str(POST_Substep)]);
	Crack_X = cell(num_Crack(POST_Substep));
	Crack_Y = cell(num_Crack(POST_Substep));
	for i=1:num_Crack(POST_Substep) 
		Crack_X{i} = str2num(fgetl(file_Crack_X));
        Crack_Y{i} = str2num(fgetl(file_Crack_Y));
	end
	fclose(file_Crack_X);
	fclose(file_Crack_Y);
	
	disp('    > Reading ennd file....') 
	Enriched_Node_Type = load([Full_Pathname,'.ennd_',num2str(POST_Substep)]);
	disp('    > Reading posi file....') 
	POS = load([Full_Pathname,'.posi_',num2str(POST_Substep)]);
	disp('    > Reading elty file....');
	Elem_Type = load([Full_Pathname,'.elty_',num2str(POST_Substep)]);
	disp('    > Reading celc file....');
	Coors_Element_Crack = load([Full_Pathname,'.celc_',num2str(POST_Substep)]);
	
	if exist([Full_Pathname,'.njel_',num2str(POST_Substep)], 'file') ==2 
	    disp('    > Reading njel file....');
	    Node_Jun_elem = load([Full_Pathname,'.njel_',num2str(POST_Substep)]); %Junction增强节点对应的Junction单元号,added on 2016-07-11
	else
	    Node_Jun_elem=[];
	end
	disp('    > Reading celv file....');
	Coors_Vertex        = load([Full_Pathname,'.celv_',num2str(POST_Substep)]);
	disp('    > Reading celj file....');
	Coors_Junction      = load([Full_Pathname,'.celj_',num2str(POST_Substep)]);
	disp('    > Reading celt file....');
	Coors_Tip           = load([Full_Pathname,'.celt_',num2str(POST_Substep)]);
	disp('    > Reading ctty file....');
	Crack_Tip_Type      = load([Full_Pathname,'.ctty_',num2str(POST_Substep)]);
else
    Crack_X = [];   Crack_Y = [];
	Enriched_Node_Type = [];
	Elem_Type = [];x_cr_tip_nodes=[];y_cr_tip_nodes=[];
	POS = []; Coors_Element_Crack= [];Coors_Vertex= [];
    Coors_Junction= []; Coors_Tip= []; Elem_Type= [];
	Crack_Tip_Type= [];Node_Jun_elem=[];
end

% Read coordinates and other info of holes if holes exist.
if num_Hole ~= 0
	disp('    > Reading coordinates of hole....') 
	file_Hole = fopen([Full_Pathname,'.hlcr']);
	for i=1:num_Hole
		Hole_Coor(i,1:3)= str2num(fgetl(file_Hole));
	end
	fclose(file_Hole);
	disp('    > Reading ennh file of hole....') 
	Enriched_Node_Type_Hl = load([Full_Pathname,'.ennh_',num2str(POST_Substep)]);
	disp('    > Reading posh file of hole....') 
	POS_Hl = load([Full_Pathname,'.posh_',num2str(POST_Substep)]);
	disp('    > Reading elth file of hole....');
	Elem_Type_Hl = load([Full_Pathname,'.elth_',num2str(POST_Substep)]);
end

% 读取圆形夹杂的坐标.
if num_Circ_Inclusion ~= 0
	disp('    > Reading coordinates of circle inclusions....') 
	file_Circ_Inclusion = fopen([Full_Pathname,'.jzcr']);
	for i=1:num_Circ_Inclusion
		Circ_Inclu_Coor(i,1:3)= str2num(fgetl(file_Circ_Inclusion));
	end
	fclose(file_Circ_Inclusion);
	disp('    > Reading ennh file of circle inclusions....') 
	Enriched_Node_Type_Incl = load([Full_Pathname,'.ennj_',num2str(POST_Substep)]);
	disp('    > Reading posh file of circle inclusions....') 
	POS_Incl = load([Full_Pathname,'.posj_',num2str(POST_Substep)]);
	disp('    > Reading elth file of circle inclusions....');
	Elem_Type_Incl = load([Full_Pathname,'.eltj_',num2str(POST_Substep)]);
end

% 读取多边形夹杂的坐标,2016-10-04.
if num_Poly_Inclusion ~= 0
	disp('    > Reading coordinates of polygon inclusions....') 
	file_Poly_Incl_Coor_x = fopen([Full_Pathname,'.jzpx']);
	file_Poly_Incl_Coor_y = fopen([Full_Pathname,'.jzpy']);
	Poly_Incl_Coor_x = cell(num_Poly_Inclusion);
	Poly_Incl_Coor_y = cell(num_Poly_Inclusion);
	for i=1:num_Poly_Inclusion
		Poly_Incl_Coor_x{i} = str2num(fgetl(file_Poly_Incl_Coor_x));
        Poly_Incl_Coor_y{i} = str2num(fgetl(file_Poly_Incl_Coor_y));
	end
	fclose(file_Poly_Incl_Coor_x);
	fclose(file_Poly_Incl_Coor_y);
	
	disp('    > Reading ennh file of polygon inclusions....') 
	Enriched_Node_Type_Incl = load([Full_Pathname,'.ennj_',num2str(POST_Substep)]);
	disp('    > Reading posh file of polygon inclusions....') 
	POS_Incl = load([Full_Pathname,'.posj_',num2str(POST_Substep)]);
	disp('    > Reading elth file of polygon inclusions....');
	Elem_Type_Incl = load([Full_Pathname,'.eltj_',num2str(POST_Substep)]);
end

% Read coordinates of natural cracks if natural cracks exist(读取天然裂缝的坐标).
if num_Na_Crack ~= 0
	disp('    > Reading coordinates of natural cracks....') 
	file_Na_Crack_X = fopen([Full_Pathname,'.ncrx']);
	file_Na_Crack_Y = fopen([Full_Pathname,'.ncry']);
	Na_Crack_X = cell(num_Na_Crack);
	Na_Crack_Y = cell(num_Na_Crack);
	for i=1:num_Na_Crack
		Na_Crack_X{i} = str2num(fgetl(file_Na_Crack_X));
        Na_Crack_Y{i} = str2num(fgetl(file_Na_Crack_Y));
	end
	fclose(file_Na_Crack_X);
	fclose(file_Na_Crack_Y);
end

% Read enriched nodes of cracks if cracks exist.
if num_Crack(POST_Substep) ~= 0
	disp('    > Reading enriched nodes of cracks....') 
	Post_Enriched_Nodes = load([Full_Pathname,'.ennd_',num2str(POST_Substep)]);
else
	Post_Enriched_Nodes =[];
end

% Read crushed elements if Key_Crush=1
if Key_Crush ==1
    crue_namefile = [Full_Pathname,'.crue_',num2str(POST_Substep)];
	% Check if "crue" file of the POST_Substep substep exist or not.
    if exist(crue_namefile,'file') ==2
        Crushed_element = load(crue_namefile);
	else
	    Crushed_element =[];
	end
else
    Crushed_element =[];
end

% Get the total force matrix(fx ,fy ,fsum).
FORCE_Matrix = zeros(Num_Node,3);
for i=1:Num_Foc_x
    c_node = Foc_x(i,1);
	FORCE_Matrix(c_node,1) = Foc_x(i,2);
end
for i=1:Num_Foc_y
    c_node = Foc_y(i,1);
	FORCE_Matrix(c_node,2) = Foc_y(i,2);
end
for i=1:Num_Node
    FORCE_Matrix(i,3) = sqrt(FORCE_Matrix(i,1)^2+FORCE_Matrix(i,2)^2);
end

% Plot mesh.
if Key_PLOT(1,1)==1
    Plot_Mesh(POST_Substep,Crack_X,Crack_Y,Post_Enriched_Nodes,POS)
end

% Calculating shaped crack points
if ((Key_PLOT(2,1) == 1 & Key_PLOT(2,5) == 2) || ...
    ((Key_PLOT(3,1) == 1 || Key_PLOT(3,1) == 2) & Key_PLOT(3,5) == 2) ||...
    ((Key_PLOT(4,1) == 1 || Key_PLOT(4,1) == 2) & Key_PLOT(4,5) == 2) )  && num_Crack(POST_Substep)~=0
	disp(['    > Calculating shaped crack points......'])
	[Shaped_Crack_Points] = Cal_Shaped_Cracks(Crack_X,Crack_Y,POST_Substep,POST_Substep,num_Crack,Crack_Tip_Type,POS,...
								   Enriched_Node_Type,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
								   Coors_Vertex,Coors_Junction,Coors_Tip,DISP,scale);
else
	Shaped_Crack_Points=[];						   
end

% Plot deformation.
if Key_PLOT(2,1)==1
    Plot_Deformation(DISP,FORCE_Matrix,Boundary_X_Matrix,Boundary_Y_Matrix,Post_Enriched_Nodes...
	                 ,POST_Substep,Crack_X,Crack_Y,POS,Enriched_Node_Type,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
					 Coors_Vertex,Coors_Junction,Coors_Tip,Crack_Tip_Type,Shaped_Crack_Points,Crushed_element)
end

% Read nodal average stress file.
if Key_PLOT(3,1)~=0
    disp('    > Reading nodal average stress file....') 
    Stress_Matrix = load([Full_Pathname,'.strn_',num2str(POST_Substep)]);
end

% Plot nodal stress contours.
if Key_PLOT(3,1)==1
    Plot_Node_Stress(DISP,Stress_Matrix,POST_Substep,Crack_X,Crack_Y,POS,...
	                 Enriched_Node_Type,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
					 Coors_Vertex,Coors_Junction,Coors_Tip,Crack_Tip_Type,Shaped_Crack_Points)
end

% Plot Gauss points stress contours.
if Key_PLOT(3,1)==2
    Plot_Gauss_Stress(DISP,Stress_Matrix,POST_Substep,Crack_X,Crack_Y,POS,...
	                 Enriched_Node_Type,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
					 Coors_Vertex,Coors_Junction,Coors_Tip,Crack_Tip_Type,Shaped_Crack_Points)
end

% Plot nodal disp contours.
if Key_PLOT(4,1)==1
    Plot_Node_Disp(DISP,POST_Substep,Crack_X,Crack_Y,POS,Enriched_Node_Type,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
					      Coors_Vertex,Coors_Junction,Coors_Tip,Crack_Tip_Type,Shaped_Crack_Points)
end

% Plot Gauss points disp contours.
if Key_PLOT(4,1)==2
    Plot_Gauss_Disp(DISP,POST_Substep,Crack_X,Crack_Y,POS,Enriched_Node_Type,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
					      Coors_Vertex,Coors_Junction,Coors_Tip,Crack_Tip_Type,Shaped_Crack_Points)
end

% Plot nodal field value contours.
if Key_PLOT(5,1)~=0
    if exist([Full_Pathname,'.fbfx_',num2str(POST_Substep)], 'file') ==2
        Plot_Node_Field_Value(DISP,Field_Value,POST_Substep,Crack_X,Crack_Y,POS,Enriched_Node_Type,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
					      Coors_Vertex,Coors_Junction,Coors_Tip,Crack_Tip_Type,Shaped_Crack_Points)
	end
end

clear DISP
clear Force_X_Matrix
clear Force_Y_Matrix
clear Boundary_X_Matrix
clear Boundary_Y_Matrix
clear POS
clear Crack_X
clear Crack_Y
clear Coors_Element_Crack
clear Node_Jun_elem
clear Coors_Vertex
clear Coors_Junction
clear Coors_Tip
clear Elem_Type