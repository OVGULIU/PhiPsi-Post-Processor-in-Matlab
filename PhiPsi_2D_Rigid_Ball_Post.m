% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

%-------------------------------------------------------------------
%--------------------- FraxFEM_Post_Plot ----------------------------
%-------------------------------------------------------------------

%---------------- Start and define global variables ----------------
clear all; close all; clc; format compact;  format long;
global Key_Dynamic Version Num_Gauss_Points 
global Filename Work_Dirctory Full_Pathname num_Crack Defor_Factor
global Num_Processor Key_Parallel Max_Memory POST_Substep
global tip_Order split_Order vertex_Order junction_Order    
global Key_PLOT Key_POST_HF Num_Crack_HF_Curves num_Na_Crack
global Plot_Aperture_Curves Plot_Pressure_Curves Plot_Velocity_Curves Num_Step_to_Plot
global Key_TipEnrich Plot_Quantity_Curves Plot_Concentr_Curves

% Number of Gauss points of enriched element (default 64) for integral solution 2.
Num_Gauss_Points = 64;       

%-------------------------- Settings -------------------------------
% Set default figure colour to white.
set(0,'defaultfigurecolor','w')

% Set default figure visible off.
set(0,'DefaultFigureVisible','off')

% Output information of matlab command window to log file.
diary('Command Window.log');        
diary on;
Version='1.3.5';Date='2/6/2015';

disp(['  FraxFEM Post Processor 1.'])  
disp([' -----------------------------------------------------------------------']) 
disp([' > RELEASE INFORMATION:                                                 ']) 
disp(['   FraxFEM Post Processor 1 is used for plotting deformed or undeformed ']) 
disp(['   mesh, contours of displacements and stresses at specified substep.   ']) 
disp([' -----------------------------------------------------------------------']) 
disp([' > AUTHOR: SHI Fang, China University of Mining & Technology            ']) 
disp([' > WEBSITE: http://www.PhiPsi.com                                       ']) 
disp([' > EMAIL: fshi@cumt.edu.cn                                              ']) 
disp([' -----------------------------------------------------------------------']) 
disp(['  '])     
       
tic;
Tclock=clock;
Tclock(1);

disp([' >> Start time is ',num2str(Tclock(2)),'/',num2str(Tclock(3)),'/',num2str(Tclock(1))...
     ,' ',num2str(Tclock(4)),':',num2str(Tclock(5)),':',num2str(round(Tclock(6))),'.'])
disp(' ') 

% Make the "patch" method supported by "getframe", added in version 4.8.10
% See more: http://www.mathworks.com/support/bugreports/384622
opengl('software')      

%----------------------- Pre-Processing ----------------------------
disp(' >> Reading input file....') 

% ----------------------------------------------------
%  Option 1: Read input data from input.dat.   
% ----------------------------------------------------
% Read_Input   

% ----------------------------------------------------
%  Option 2: Read input from FraxFEM2D_Input_Control.m.         
% ----------------------------------------------------                             
Fraxfem_Input_Control                            
% Check and initialize settings of parallel computing.

% -------------------------------------
%   Start Post-processor.      
% -------------------------------------   
Key_PLOT   = zeros(1,15);                                   % Initialize the Key_PLOT

%###########################################################################################################
%##########################            User defined part        ############################################
%###########################################################################################################
Filename='Rigid_Balls';Work_Dirctory='D:\FraxFem fortran work\FraxFem work\Rigid_Balls';

%----------------------
% Filename='HF_Sys_25x25';Work_Dirctory='D:\Fraxfem Intel fortran work\Fraxfem\FraxFem work\HF_Sys_25x25';
% Filename='Paper1_Example_3_1';Work_Dirctory='D:\Fraxfem Intel fortran work\Fraxfem\FraxFem work\Paper1_Example_3_1';
% Filename='Paper1_Example_3_7';Work_Dirctory='D:\Fraxfem Intel fortran work\Fraxfem\FraxFem work\Paper1_Example_3_7';

Num_Step_to_Plot      = 0           ;%后处理结果计算步号
Model_W               = 5.0         ;
Model_H               = 5.0         ;

% 第1行,有限元网格: Mesh(1),Node(2),El(3),Gauss points(4),
%                   5: 裂缝及裂缝坐标点(=1,绘制裂缝;=2,绘制裂缝及坐标点),
%                   6: 计算点及其编号(=1,计算点;=2,计算点和编号),
%                   7: 裂缝节点(计算点)相关(=1,节点集增强节点载荷;=2,计算点净水压;=3,计算点流量),
%                   增强节点(8),网格线(9),
%                   支撑剂(10),单元应力状态是否σ1-σ3>Tol(11),天然裂缝(12),单元接触状态(13),裂缝编号(14),Blank(15)
%                         1   2   3   4   5   6              7   8   9  10  11  12  13  14   15
Key_PLOT(1,:)         = [ 1,  0,  0,  0,  0,  0,             2,  1,  1  ,1  ,0  ,1  ,1  ,1  ,0];  
%###########################################################################################################
%##########################            End of user defined part        #####################################
%###########################################################################################################
disp(['    ---#---#---#---#---#---#---#---#---#---#---']) 
disp(['    Attention :: Results number to plot: ',num2str(Num_Step_to_Plot)])
disp(['    ---#---#---#---#---#---#---#---#---#---#---']) 
disp(['    ']) 
if Key_HF==1
    disp(['    HF:    yes'])   %显示是否是HF分析后处理
end
disp(['    ']) 

% Get the full name of files.
Full_Pathname = [Work_Dirctory,'\',Filename];

Plot_RB_Balls(Num_Step_to_Plot,Model_W,Model_H)

% Read input geometry files.
% Read_Geo
% disp(['  '])    

% Check if result files exist.
% if exist([Full_Pathname,'.disn_',num2str(Num_Step_to_Plot)], 'file') ~=2
    % disp(' >> Error :: No result files found, post-processor terminated.') 
	% Error_Message
% end

% Get the number of cracks if crack file exists.
% if exist([Full_Pathname,'.crax_',num2str(Num_Step_to_Plot)], 'file') ==2  
	% file_Crack_X = fopen([Full_Pathname,'.crax_',num2str(Num_Step_to_Plot)]);
	% row=0;
	% while ~feof(file_Crack_X)
		% row=row+sum(fread(file_Crack_X,10000,'*char')==char(10));
	% end
	% fclose(file_Crack_X);
	% num_Crack(Num_Step_to_Plot) = row;
% else
    % num_Crack(Num_Step_to_Plot) = 0;
% end

% Get the number of natural cracks if natural crack file exists.
% if exist([Full_Pathname,'.ncrx'], 'file') ==2  
	% file_Na_Crack_X = fopen([Full_Pathname,'.ncrx']);
	% row=0;
	% while ~feof(file_Na_Crack_X)
		% row=row+sum(fread(file_Na_Crack_X,10000,'*char')==char(10));
	% end
	% fclose(file_Na_Crack_X);
	% num_Na_Crack = row;
% else
    % num_Na_Crack = 0;
% end

% Plot.
% Plot_Main(Num_Step_to_Plot) 

% 绘制HF曲线
% if Plot_Aperture_Curves == 1 || Plot_Pressure_Curves==1||...
   % Plot_Velocity_Curves==1   || Plot_Quantity_Curves==1|| Plot_Concentr_Curves ==1
    % Plot_HF_curves(Num_Step_to_Plot) 
% end

% 绘制应力强度因子曲线
% if Plot_SIF_KI_Curves==1
    % Plot_SIF_curves(Num_Step_to_Plot,Num_Crack_SIF_Curves,Num_Tip_SIF_Curves) 
% end

% 绘制裂缝注水点水压变化曲线
% if Plot_Inj_Pres_Curves==1
    % Plot_Injection_Pressure_curves(Num_Step_to_Plot,Key_InjP_Curves_x)
% end

% 输出完成信息
disp(' ')
disp('    Plot completed.')
disp(' ')

Cclock=clock;
% Display end time.
disp([' >> End time is ',num2str(Cclock(2)),'/',num2str(Cclock(3)),'/',num2str(Cclock(1))...
     ,' ',num2str(Cclock(4)),':',num2str(Cclock(5)),':',num2str(round(Cclock(6))),'.'])
	 
% Stop log file.
diary off;

%-------------------------------------------------------------------
%------------------ The end of FraxFEM_Post_Plot --------------------
%-------------------------------------------------------------------
