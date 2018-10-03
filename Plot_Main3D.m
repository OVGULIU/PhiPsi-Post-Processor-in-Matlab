%     .................................................
%             ____  _       _   ____  _____   _        
%            |  _ \| |     |_| |  _ \|  ___| |_|       
%            | |_) | |___   _  | |_) | |___   _        
%            |  _ /|  _  | | | |  _ /|___  | | |       
%            | |   | | | | | | | |    ___| | | |       
%            |_|   |_| |_| |_| |_|   |_____| |_|       
%     .................................................
%     PhiPsi:     a general-purpose computational      
%                 mechanics program written in Fortran.
%     Website:    http://phipsi.top                    
%     Author:     Fang Shi  
%     Contact me: shifang@ustc.edu.cn     

function Plot_Main3D(POST_Substep)
% This function plots mesh and deformed mesh for 3D problems.

global Key_PLOT Full_Pathname Num_Node Num_Foc_x Num_Foc_y Foc_x Foc_y Num_Foc_z Foc_z
global num_Crack Key_Dynamic Real_Iteras Real_Sub Key_Contour_Metd
global Output_Freq num_Output_Sub Key_Crush DISP  FORCE_Matrix
global Key_Data_Format

scale = Key_PLOT(2,6);
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
disp('    > Reading displacement file....') 
% DISP= load([Full_Pathname,'.disn_',num2str(POST_Substep)]);
if Key_Data_Format==1 
	DISP   = load([Full_Pathname,'.disn_',num2str(POST_Substep)]);
elseif Key_Data_Format==2  %Binary
	c_file = fopen([Full_Pathname,'.disn_',num2str(POST_Substep)],'rb');
	[cc_DISP,cc_count]   = fread(c_file,inf,'double');
	fclose(c_file);
	%转换成Matlab中的数据格式
	for ccc_i=1:cc_count/3
		DISP(ccc_i,1) = ccc_i;
		DISP(ccc_i,2) = cc_DISP(ccc_i*3-2);
		DISP(ccc_i,3) = cc_DISP(ccc_i*3-1);
		DISP(ccc_i,4) = cc_DISP(ccc_i*3);
	end
end
% size(DISP)

% Read force file.
disp('    > Reading force file....') 
Force_X_Matrix = load([Full_Pathname,'.focx']);
Force_Y_Matrix = load([Full_Pathname,'.focy']);
Force_Z_Matrix = load([Full_Pathname,'.focz']);

% Read Boundary file.
disp('    > Reading Boundary file....') 
Boundary_X_Matrix = load([Full_Pathname,'.boux']);
Boundary_Y_Matrix = load([Full_Pathname,'.bouy']);
Boundary_Z_Matrix = load([Full_Pathname,'.bouz']);

% Read coordinates and other info of cracks if cracks exist.
if num_Crack(POST_Substep) ~= 0
	disp('    > Reading coordinates of cracks....') 
	file_Crack_X = fopen([Full_Pathname,'.crax_',num2str(POST_Substep)]);
	file_Crack_Y = fopen([Full_Pathname,'.cray_',num2str(POST_Substep)]);
	file_Crack_Z = fopen([Full_Pathname,'.craz_',num2str(POST_Substep)]);
	Crack_X = cell(num_Crack(POST_Substep));
	Crack_Y = cell(num_Crack(POST_Substep));
	Crack_Z = cell(num_Crack(POST_Substep));
	for i=1:num_Crack(POST_Substep) 
		Crack_X{i} = str2num(fgetl(file_Crack_X));
        Crack_Y{i} = str2num(fgetl(file_Crack_Y));
		Crack_Z{i} = str2num(fgetl(file_Crack_Z));
	end
	fclose(file_Crack_X);
	fclose(file_Crack_Y);
	fclose(file_Crack_Z);
	
	% disp('    > Reading ennd file....') 
	Enriched_Node_Type = load([Full_Pathname,'.ennd_',num2str(POST_Substep)]);
	% disp('    > Reading posi file....') 
	POS = load([Full_Pathname,'.posi_',num2str(POST_Substep)]);
	% disp('    > Reading elty file....');
	Elem_Type = load([Full_Pathname,'.elty_',num2str(POST_Substep)]);
else
    Crack_X = [];   Crack_Y = [];  Crack_Z = [];
	Enriched_Node_Type = [];
	Elem_Type = [];x_cr_tip_nodes=[];y_cr_tip_nodes=[];
	POS = []; Coors_Element_Crack= [];Coors_Vertex= [];
    Coors_Junction= []; Coors_Tip= []; Elem_Type= [];
	Crack_Tip_Type= [];Node_Jun_elem=[];Node_Cross_elem=[];
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

% Read nodal average stress file.
if Key_PLOT(3,1)~=0
    disp('    > Reading nodal average stress file....') 
	%读取节点应力
	if Key_Data_Format==1 
        Stress_Matrix = load([Full_Pathname,'.strn_',num2str(POST_Substep)]);
	elseif Key_Data_Format==2  %Binary
		% c_file = fopen([Full_Pathname,'.strn_',num2str(POST_Substep)],'rb');
		% [cc_Stress_Matrix,cc_count]   = fread(c_file,inf,'double');
		% fclose(c_file);
		%%%%转换成Matlab中的数据格式
		% for ccc_i=1:cc_count/4
			% Stress_Matrix(ccc_i,1) = ccc_i;
			% Stress_Matrix(ccc_i,2) = cc_Stress_Matrix(ccc_i*4-3);
			% Stress_Matrix(ccc_i,3) = cc_Stress_Matrix(ccc_i*4-2);
			% Stress_Matrix(ccc_i,4) = cc_Stress_Matrix(ccc_i*4-1);
			% Stress_Matrix(ccc_i,5) = cc_Stress_Matrix(ccc_i*4);
		% end
	end
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
for i=1:Num_Foc_z
    c_node = Foc_z(i,1);
	FORCE_Matrix(c_node,3) = Foc_z(i,2);
end
for i=1:Num_Node
    FORCE_Matrix(i,4) = sqrt(FORCE_Matrix(i,1)^2+FORCE_Matrix(i,2)^2++FORCE_Matrix(i,3)^2);
end

% Plot mesh.
if Key_PLOT(1,1)==1
    Plot_Mesh3D(POST_Substep,Crack_X,Crack_Y,Crack_Z,Post_Enriched_Nodes,POS)
end

% Plot deformation.
if Key_PLOT(2,1)==1
    Plot_Deformation3D(POST_Substep,Crack_X,Crack_Y,Crack_Z,Post_Enriched_Nodes,POS)
end


disp('    Plot completed.')
disp(' ')

clear DISP
clear Force_X_Matrix
clear Force_Y_Matrix
clear Boundary_X_Matrix
clear Boundary_Y_Matrix
clear Node_Jun_elem
clear POS
clear Crack_X
clear Crack_Y
clear Coors_Element_Crack
clear Coors_Vertex
clear Coors_Junction
clear Coors_Tip
clear Elem_Type