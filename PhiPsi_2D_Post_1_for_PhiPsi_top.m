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
%--------------------- PhiPsi_Post_Plot1 ---------------------------
%-------------------------------------------------------------------

%---------------- Start and define global variables ----------------
clear all; close all; clc; format compact;  format long;
global Key_Dynamic Version Num_Gauss_Points
global Filename Work_Dirctory Full_Pathname num_Crack Defor_Factor
global Num_Processor Key_Parallel Max_Memory POST_Substep
global tip_Order split_Order vertex_Order junction_Order
global Key_PLOT Key_POST_HF Num_Crack_HF_Curves num_Na_Crack
global Plot_Aperture_Curves Plot_Pressure_Curves Plot_Velocity_Curves Num_Step_to_Plot
global Plot_Tan_Aper_Curves
global Key_TipEnrich Plot_Quantity_Curves Plot_Concentr_Curves
global num_Hole Plot_Wpnp_Curves Plot_Wphp_Curves
global num_Circ_Inclusion num_Poly_Inclusion
global Key_Gas_Prod_rate Key_Gas_Production Key_One_Node_Pres
global Tclock

%-------------------------- Settings -------------------------------
% Start multiple processors.
% matlabpool local 2

% Set default figure colour to white.
set(0,'defaultfigurecolor','w')

% Set default figure visible off.
set(0,'DefaultFigureVisible','off')

% Output information of matlab command window to log file.
diary('Command Window.log');
diary on;
Version='1.8.4';Date='August 25, 2018';

disp(['  PhiPsi Post Processor 1.'])
disp([' -----------------------------------------------------------------------'])
disp([' > RELEASE INFORMATION:                                                 '])
disp(['   PhiPsi Post Processor 1 is used for plotting deformed or undeformed  '])
disp(['   mesh, contours of displacements and stresses at specified substep.   '])
disp([' -----------------------------------------------------------------------'])
disp([' > AUTHOR: Fang Shi, Huaiyin Institute of Technology                    '])
disp([' > WEBSITE: http://PhiPsi.top                                           '])
disp([' > EMAIL: shifang@ustc.edu.cn                                           '])
disp([' -----------------------------------------------------------------------'])
disp(['  '])

tic;
Tclock=clock;
%Tclock(1);

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
Key_PLOT   = zeros(8,15);                                   % Initialize the Key_PLOT

%###########################################################################################################
%##########################            User defined part        ############################################
%###########################################################################################################
% ---------------------以下是PhiPsi网站算例相关-------------------------
% Filename='exa_inclusions';Work_Dirctory='X:\PhiPsi_work\exa_inclusions';
% Filename='exa_tension';Work_Dirctory='X:\PhiPsi_work\exa_tension';
% Filename='exa_earthquake';Work_Dirctory='X:\PhiPsi_work\exa_earthquake';
% Filename='exa_hydraulic_fracturing';Work_Dirctory='X:\PhiPsi_work\exa_hydraulic_fracturing';
% Filename='exa_cohesive_crack';Work_Dirctory='X:\PhiPsi_work\exa_cohesive_crack';
% Filename='exa_multi_cracks';Work_Dirctory='X:\PhiPsi_work\exa_multi_cracks';
% Filename='exa_crossing_cracks';Work_Dirctory='X:\PhiPsi_work\exa_crossing_cracks';
% Filename='exa_cracks_meet_holes';Work_Dirctory='X:\PhiPsi_work\exa_cracks_meet_holes';
Num_Step_to_Plot      = -999    ;%后处理结果计算步号(若-999,则绘制最后一步的)
Defor_Factor          = 10        ;%变形放大系数


% 第1行,有限元网格: Mesh(1),Node(2),El(3),Gauss points(4),
%                   5: 裂缝及裂缝坐标点(=1,绘制裂缝;=2,绘制裂缝及坐标点),
%                   6: 计算点及其编号(=1,计算点;=2,计算点和编号),
%                   7: 裂缝节点(计算点)相关(=1,节点及增强节点载荷;=2,计算点净水压;=3,计算点流量;=4,计算点开度;=5,计算点粘聚力x方向分力;=6,计算点粘聚力y方向分力),
%                   增强节点(8),网格线(9),
%                   支撑剂(10),单元应力状态是否σ1-σ3>Tol(11),天然裂缝(12),单元接触状态/粘聚裂缝状态(13),裂缝编号(14),Fracture zone(15)
% 第2行,网格变形图: Deformation(1),Node(2),El(3),Gauss points(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   FsBs(7=1or2or3),Deformed and undefor(8),Blank(9),支撑剂(10),Blank(11),Blank(12),
%                   单元接触状态/粘聚裂缝状态(13),增强节点(14),Fracture zone(15)
% 第3行,应力云图:   Stress Contour(1,2:Gauss points),(2:1,Only Mises stress;2,仅x应力;3,仅y应力;4,仅剪应力),
%                   主应力(3:1,主应力;2,主应力+方向;3,仅最大主应力),塑性相关(4:1,等效塑性应变),
%                   Crack(5:1,line;2,shape),Scaling Factor(6),FsBs(7=1or2or3),
%                   undeformed or Deformed(8),mesh(9),支撑剂(10),Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
% 第4行,位移云图:   Plot Dis-Contour(1,2:Gauss points),only位移分量平方和开根号(2=1),Blank(3),Blank(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   FsBs(7=1or2or3),,undeformed or Deformed(8),mesh(9),支撑剂(10),Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
% 第5行,场问题云图: Plot Contour(1:场值,2:流量矢量,3:场值+流量矢量),Blank(2),Blank(3),Blank(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   Blank(7),undeformed or Deformed(8),mesh(9),支撑剂(10),Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
% 第6行,分子动力学: Plot Contour(1:位置,2:速度,3:),轨迹(2=1,全部轨迹;>1,轨迹包括的计算步数),Blank(3),Blank(4),Blank(5),Scaling Factor(6),
%                   Blank(7),Original location(8),5x5的标记线(9),Blank(10),Blank(11),Blank(12),Blank(13),Blank(14),Box(15)
% 第7行,曲线绘制:   曲线绘制相关：开关(1=1,则绘制曲线),应力强度因子曲线(2),应力强度因子曲线裂缝号(3),应力强度因子曲线裂尖号(4),
%                   水力压裂分析计算结果曲线的绘制(5=1,绘制裂缝内净水压分布曲线;5=2,裂缝开度分布曲线；=3，裂缝切向开度分布曲线；
%                                                  5=4，裂缝流体节点流速分布曲线;5=5，裂缝流体节点流量分布曲线;5=6，裂缝流体节点处支撑剂浓度流量分布曲线),
%                   水力压裂分析计算结果曲线对应的裂缝号(6),水力压裂分析注水点压力变化曲线(7=1,以时间为x坐标轴;7=2,以压裂步为x轴),
%                   绘制页岩气产出率变化曲线(8=1),是否绘制累积产量变化曲线(9=1),是否绘制某一个点的压力变化(10=1),
%                   绘制载荷位移曲线(11=1,载荷位移曲线的绘制*.fdcu文件,),Blank(12-15)
% 第8行,近场动力学: Plot Contour(1:位置,2:速度,3:),轨迹(2=1,全部轨迹;>1,轨迹包括的计算步数),Blank(3),Blank(4),Blank(5),Scaling Factor(6),
%                   Point size(7),Original location(8),plot a mesh(9),Blank(10),Blank(11),Blank(12),Blank(13),Blank(14),Box(15)
%                         1   2   3   4   5   6              7   8   9  10  11  12  13  14   15
Key_PLOT(1,:)         = [ 1,  0,  0,  0,  2,  0,             5,  1,  1  ,1  ,0  ,1  ,1  ,0  ,1];
Key_PLOT(2,:)         = [ 1,  0,  0,  0,  2,  Defor_Factor,  3,  0,  1  ,1  ,1  ,1  ,1  ,0  ,1];
Key_PLOT(3,:)         = [ 2,  0,  0,  0,  2,  Defor_Factor,  0,  1,  1  ,0  ,0  ,1  ,0  ,0  ,0];
Key_PLOT(4,:)         = [ 2,  0,  0,  0,  2,  Defor_Factor,  0,  1,  1  ,1  ,0  ,1  ,0  ,0  ,1];
Key_PLOT(5,:)         = [ 0,  0,  0,  0,  1,  Defor_Factor,  0,  0,  1  ,1  ,0  ,1  ,0  ,0  ,1];
Key_PLOT(6,:)         = [ 0,  20, 0,  0,  0,  0,             0,  0,  1  ,0  ,0  ,0  ,0  ,0  ,1];
Key_PLOT(7,:)         = [ 0,  1,  1,  2,  1,  1,             0,  0,  0  ,0  ,1  ,0  ,0  ,0  ,0];
Key_PLOT(8,:)         = [ 0,  5,  0,  0,  0,  Defor_Factor,  2,  0,  0  ,0  ,0  ,0  ,0  ,0  ,0];



% Filename='exa_earthquake';Work_Dirctory='X:\PhiPsi_work\exa_earthquake';
% PhiPsi_Post_1_Go

% Filename='exa_hydraulic_fracturing';Work_Dirctory='X:\PhiPsi_work\exa_hydraulic_fracturing';
% PhiPsi_Post_1_Go

% Filename='exa_inclusions';Work_Dirctory='X:\PhiPsi_work\exa_inclusions';
% PhiPsi_Post_1_Go

% Filename='exa_tension';Work_Dirctory='X:\PhiPsi_work\exa_tension';
% PhiPsi_Post_1_Go
% Filename='exa_multi_cracks';Work_Dirctory='X:\PhiPsi_work\exa_multi_cracks';
% PhiPsi_Post_1_Go
% Filename='exa_crossing_cracks';Work_Dirctory='X:\PhiPsi_work\exa_crossing_cracks';
% PhiPsi_Post_1_Go
Filename='exa_cracks_meet_holes';Work_Dirctory='X:\PhiPsi_work\exa_cracks_meet_holes';
PhiPsi_Post_1_Go
% Filename='exa_plastic';Work_Dirctory='X:\PhiPsi_work\exa_plastic';
% PhiPsi_Post_1_Go

