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

%-------------------------------------------------------------------
%--------------------- PhiPsi_Post_Plot ----------------------------
%-------------------------------------------------------------------

%---------------- Start and define global variables ----------------
clear all; close all; clc; format compact;  format long;
global Key_Dynamic Version Num_Gauss_Points 
global Filename Work_Dirctory Full_Pathname num_Crack
global Num_Processor Key_Parallel Max_Memory POST_Substep
global tip_Order split_Order vertex_Order junction_Order    
global Key_PLOT Key_POST_HF Num_Crack_HF_Curves
global Plot_Aperture_Curves Plot_Pressure_Curves Num_Step_to_Plot
global Key_TipEnrich

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

Version='1.9.1';Date='September 14, 2018';

disp(['  PhiPsi Post Processor 1 for 3D.'])  
disp([' -----------------------------------------------------------------------']) 
disp([' > RELEASE INFORMATION:                                                 ']) 
disp(['   PhiPsi Post Processor 1 is used for plotting deformed or undeformed  ']) 
disp(['   mesh, contours of displacements and stresses at specified substep.   ']) 
disp([' -----------------------------------------------------------------------']) 
disp([' > AUTHOR: Shi Fang, Huaiyin Institute of Technology                    ']) 
disp([' > WEBSITE: http://PhiPsi.top                                           ']) 
disp([' > EMAIL: shifang@ustc.edu.cn                                           ']) 
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

% -------------------------------------
%   Set color and font
% -------------------------------------                           
PhiPsi_Color_and_Font_Settings    

% -------------------------------------
%   Start Post-processor.      
% -------------------------------------   
Key_PLOT   = zeros(5,15);                                   % Initialize the Key_PLOT

%###########################################################################################################
%##########################            User defined part        ############################################
%###########################################################################################################
% Filename='exa_3D_crack';Work_Dirctory='x:\PhiPsi_work\exa_3D_crack';
% Filename='exa_3D_hollow_cylinder';Work_Dirctory='x:\PhiPsi_work\exa_3D_hollow_cylinder';
Filename='3D_beam_sifs';Work_Dirctory='X:\PhiPsi Work\3D_beam_sifs';


Num_Step_to_Plot      = 1                 ;     %后处理结果计算步号
Defor_Factor          = 10               ;     %变形放大系数
Key_TipEnrich         = 2                 ;     %裂尖增强方案：1,标准；2,仅F1; 3,光滑过渡Heaviside
Plot_Pressure_Curves  = 0                 ;     %是否绘制裂缝内水压分布曲线
Plot_Aperture_Curves  = 0                 ;     %是否绘制裂缝开度分布曲线
Num_Crack_HF_Curves   = [1,2]             ;     %绘制该裂纹对应的水力压裂分析相关曲线


% 第1行,有限元网格: Mesh(1),Node(2),El(3),Gauss poin ts(4),
%                   5: 裂缝及裂缝坐标点(=1,绘制裂缝;=2,绘制裂缝及坐标点),
%                   6: 计算点及其编号(=1,计算点;=2,计算点和编号),
%                   7: 裂缝节点(计算点)相关(=1,节点集增强节点载荷;=2,计算点净水压;=3,计算点流量;=4,计算点开度),
%                   增强节点(8),网格线(9),
%                   支撑剂(10),单元应力状态是否σ1-σ3>Tol(11),天然裂缝(12),单元接触状态(13),裂缝编号(14),Fracture zone(15)
% 第2行,网格变形图: Deformation(1),Node(2),El(3),Gauss points(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   FsBs(7=1or2or3),Deformed and undefor(8),Blank(9),支撑剂(10),Blank(11),Blank(12),
%                   单元接触状态(13),增强节点(14),Fracture zone(15)
% 第3行,应力云图:   Stress Contour(1,2:Gauss points),(2:1,Only Mises stress;2,仅x应力;3,仅剪应力),主应力(3:1,主应力;2,主应力+方向;3,仅最大主应力),
%                   Crack(5:1,line;2,shape),Scaling Factor(6),
%                   undeformed or Deformed(8),mesh(9),支撑剂(10)Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
% 第4行,位移云图:   Plot Dis-Contour(1,2:Gauss points),Blank(2),Blank(3),Blank(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   Blank(7),undeformed or Deformed(8),mesh(9),支撑剂(10),Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
% 第5行,场问题云图: Plot Dis-Contour(1),Blank(2),Blank(3),Blank(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   Blank(7),undeformed or Deformed(8),mesh(9),支撑剂(10),Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
%                         1   2   3   4   5   6              7   8   9  10  11  12  13  14   15
Key_PLOT(1,:)         = [ 1,  1,  0,  0,  1,  0,             0,  1,  0  ,0  ,0  ,0  ,0  ,0  ,0];  
Key_PLOT(2,:)         = [ 1,  1,  0,  0,  1,  Defor_Factor,  3,  0,  0  ,0  ,0  ,0  ,0  ,1  ,0];  
Key_PLOT(3,:)         = [ 0,  0,  0,  0,  2,  Defor_Factor,  0,  1,  1  ,0  ,0  ,1  ,0  ,0  ,1];  
Key_PLOT(4,:)         = [ 0,  0,  0,  0,  2,  Defor_Factor,  0,  1,  1  ,1  ,0  ,1  ,0  ,0  ,1];
Key_PLOT(5,:)         = [ 0,  0,  0,  0,  2,  Defor_Factor,  0,  1,  1  ,1  ,0  ,1  ,0  ,0  ,1];   

%###########################################################################################################
%##########################            End of user defined part        #####################################
%###########################################################################################################

PhiPsi_Post_1_Go_3D
