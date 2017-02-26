% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

%-------------------------------------------------------------------
%--------------------- PhiPsi_Post_Plot2 ---------------------------
%-------------------------------------------------------------------

%---------------- Start and define global variables ----------------
clear all; close all; clc; format compact;  format long;
global Key_Dynamic Version Num_Gauss_Points 
global Filename Work_Dirctory Full_Pathname num_Crack Defor_Factor
global Num_Processor Key_Parallel Max_Memory POST_Substep
global tip_Order split_Order vertex_Order junction_Order    
global Key_PLOT Key_POST_HF Num_Crack_HF_Curves num_Na_Crack
global Plot_Aperture_Curves Plot_Pressure_Curves Plot_Velocity_Curves Num_Step_to_Plot
global Key_TipEnrich Plot_Quantity_Curves Plot_Concentr_Curves Itera_Num
global Na_Crack_X Na_Crack_Y num_Na_Crack Itera_HF_Time Key_HF_Analysis
global num_Hole Hole_Coor   
global num_Circ_Inclusion num_Poly_Inclusion Key_Time_String

%-------------------------- Settings -------------------------------
% Set default figure colour to white.
set(0,'defaultfigurecolor','w')

% Set default figure visible off.
set(0,'DefaultFigureVisible','off')

% Output information of matlab command window to log file.
diary('Command Window.log');        
diary on;
Version='1.2.0';Date='February 2, 2017';

disp(['  PhiPsi Post Processor 2.'])  
disp([' -----------------------------------------------------------------------']) 
disp([' > RELEASE INFORMATION:                                                 ']) 
disp(['   PhiPsi Post Processor 2 is used for creating animations.             ']) 
disp([' -----------------------------------------------------------------------']) 
disp([' > AUTHOR: SHI Fang, China University of Mining & Technology            ']) 
disp([' > WEBSITE: http://PhiPsi.top                                           ']) 
disp([' > EMAIL: phispi@sina.cn                                                ']) 
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
PhiPsi_Input_Control                            
% Check and initialize settings of parallel computing.

% -------------------------------------
%   Start Post-processor.      
% -------------------------------------   
Key_PLOT   = zeros(6,15);                                   % Initialize the Key_PLOT

%###########################################################################################################
%##########################            User defined part        ############################################
%###########################################################################################################
% Filename='Brief_intro_1';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Brief_intro_1';
% Filename='test_3x3';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\test_3x3';
% Filename='test_3x3';Work_Dirctory='D:\PhiPsi fortran work1\PhiPsi work\test_3x3';
% Filename='test_3x2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\test_3x2';
% Filename='test_3x2';Work_Dirctory='D:\PhiPsi fortran work1\PhiPsi work\test_3x2';
% Filename='test_5x5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\test_5x5';
% Filename='test_5x5_compression';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\test_5x5_compression';
% Filename='test_11x11';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\test_11x11';
% Filename='uniaxial_tension_test';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\uniaxial_tension_test';
% Filename='hole_regular_mesh';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\hole_regular_mesh';
% Filename='K_benchmark_Bigger';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\K_benchmark_Bigger';
% Filename='static_random';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\static_random';
% Filename='Penalty_Test';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Penalty_Test';
% Filename='Penalty_Test_11x11';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Penalty_Test_11x11';
% Filename='Penalty_Test_11x11_2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Penalty_Test_11x11_2';
% Filename='Penalty_Test_11x11_3';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Penalty_Test_11x11_3';
% Filename='Penalty_Test_11x11_tension';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Penalty_Test_11x11_tension';
% Filename='Penalty_Test_21x21';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Penalty_Test_21x21';
% Filename='Penalty_Test_77x77_bi-tension';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Penalty_Test_77x77_bi-tension';
% Filename='Simple';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Simple';
% Filename='Shear';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Shear';
% Filename='brazil_coarse_mesh';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\brazil_coarse_mesh';
% Filename='brazil_fine_mesh';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\brazil_fine_mesh';
% Filename='recta_uniaxial-tension_test';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\recta_uniaxial-tension_test';
% Filename='HF_pressure_test';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_pressure_test';
% Filename='HF_pressure_test';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_pressure_test';
% Filename='HF_pressure_test2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_pressure_test2';
% Filename='Junction';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Junction';
% Filename='HF_Sys_5x5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_5x5';
% Filename='HF_Sys_5x5_1';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_5x5_1';
% Filename='HF_Sys_11x11';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_11x11';
% Filename='E_1';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\E_1';
% Filename='E_1_Fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\E_1_Fixed';
% Filename='HF_Sys_11x11';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_11x11';
% Filename='HF_31x31_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_31x31_fixed';
% Filename='HF_Sys_17x17';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_17x17';
% Filename='HF_Sys_17x17_0.25';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_17x17_0.25';
% Filename='HF_Sys_17x17_Fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_17x17_Fixed';
% Filename='HF_Sys_17x17_InSitu_0_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_17x17_InSitu_0_5';
% Filename='HF_Sys_17x17_InSitu_4_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_17x17_InSitu_4_5';
% Filename='HF_Sys_17x17_InSitu_5_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_17x17_InSitu_5_5';
% Filename='HF_Sys_17x17_Static';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_17x17_Static';
% Filename='Paper1_example_1_2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper1_example_1_2';
% Filename='Example_2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Example_2';
% Filename='HF_Sys_21x21';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_21x21';
% Filename='HF_Sys_25x25';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25';
% Filename='HF_Sys_25x25_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25_fixed';
% Filename='HF_Sys_25x25_Right_Force';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25_Right_Force';
% Filename='HF_Sys_25x25_Right_Neg_Force';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25_Right_Neg_Force';
% Filename='HF_Sys_25x25_Top_Neg_Force';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25_Top_Neg_Force';
% Filename='HF_Sys_25x25_Geostress';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25_Geostress';
% Filename='HF_Sys_25x25_InSitu_4_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25_InSitu_4_5';
% Filename='HF_Sys_25x25_InSitu_0_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25_InSitu_0_5';
% Filename='HF_Sys_45x45';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_45x45';
% Filename='HF_Sys_45x45_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_45x45_fixed';
% Filename='HF_Sys_45x45_InSitu_4_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_45x45_InSitu_4_5';
% Filename='HF_Sys_55x55';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_55x55';
% Filename='HF_Sys_55x55_unixal_tension';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_55x55_unixal_tension';
% Filename='HF_Sys_55x55_tension_and_compres';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_55x55_tension_and_compres';
% Filename='HF_Sys_55x55_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_55x55_fixed';
% Filename='HF_Sys_55x55_InSitu_4_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_55x55_InSitu_4_5';
% Filename='HF_Sys_55x55_InSitu_0_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_55x55_InSitu_0_5';
% Filename='HF_Sys_55x55_InSitu_7_10';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_55x55_InSitu_7_10';
% Filename='HF_Sys_55x55_InSitu_9_10';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_55x55_InSitu_9_10';
% Filename='HF_Sys_65x65';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_65x65';
% Filename='HF_Sys_65x65_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_65x65_fixed';
% Filename='HF_Sys_45x80';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_45x80';
% Filename='HF_Sys_75x150';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_75x150';
% Filename='HF_Sys_77x77_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_77x77_fixed';
% Filename='HF_Sys_77x77_InSitu_5_4.5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_77x77_InSitu_5_4.5';
% Filename='HF_Sys_99x99_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_99x99_fixed';
% Filename='HF_Sys_100x180';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_100x180';
% Filename='HF_Sys_25x25_Geostress';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_25x25_Geostress';
% Filename='HF_Sys_33x33';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_33x33';
% Filename='HF_Sys_33x33_Static';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_33x33_Static';
% Filename='HF_Sys_79x49';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_79x49';
% Filename='HF_Sys_100x100';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_100x100';
% Filename='HF_Sys_Youn';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_Youn';
% Filename='n2xx';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\n2xx';
% Filename='n2xxf';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\n2xxf';
% Filename='HF_Sys_200x_300_80x80_FZ_5_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\HF_Sys_200x_300_80x80_FZ_5_5';
% Filename='contact_reduction_test_15x15';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\contact_reduction_test_15x15';
% Filename='contact_reduction_test_30x30';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\contact_reduction_test_30x30';
% Filename='contact_reduction_test_50x50';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\contact_reduction_test_50x50';
% Filename='Paper02_01';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_01';
% Filename='Paper02_03';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_03';
% Filename='Paper02_03_test1';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_03_test1';
% Filename='XiaoLong_test_7x7';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\XiaoLong_test_7x7';
% Filename='Paper02_04';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04';
% Filename='Paper02_04_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fixed';
% Filename='Paper02_04_InSitu_5_4';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_InSitu_5_4';
% Filename='Paper02_04_fine';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine';
% Filename='Paper02_04_fine_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_fixed';
% Filename='Paper02_04_fine_InSitu_5_4';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4';
% Filename='Paper02_04_fine_InSitu_5_4_test2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4_test2';
% Filename='Paper02_04_fine_InSitu_5_4_test3';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4_test3';
% Filename='Paper02_04_fine_InSitu_5_4_test4';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4_test4';
% Filename='Paper02_04_fine_InSitu_5_4_test5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4_test5';
% Filename='Paper02_04_fine_InSitu_5_4_test6';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4_test6';
% Filename='Paper02_04_fine_InSitu_5_4_test7';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4_test7';
% Filename='Paper02_04_fine_InSitu_5_4_test8';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4_test8';
% Filename='Paper02_04_fine_InSitu_5_4_test9';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4_test9';
% Filename='Paper02_04_fine_InSitu_5_4.5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_4.5';
% Filename='Paper02_04_fine_InSitu_5_5';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper02_04_fine_InSitu_5_5';
% Filename='Paper03_Verification';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper03_Verification';
% Filename='Paper03_Sensitivity_Basecase_HF';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper03_Sensitivity_Basecase_HF';
% Filename='Paper03_Sensitivity_Basecase_HF2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper03_Sensitivity_Basecase_HF2';
% Filename='Paper03_Sensitivity_Basecase_HF3';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Paper03_Sensitivity_Basecase_HF3';
% Filename='Paper03_Sensitivity_Basecase_HF3';Work_Dirctory='D:\PhiPsi fortran work_c\PhiPsi work\Paper03_Sensitivity_Basecase_HF3';
% Filename='Fatigue_Compression';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Fatigue_Compression';
% Filename='exa_tension';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\exa_tension';
% Filename='Hole';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Hole';
% Filename='Holes_and_cracks';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Holes_and_cracks';
% Filename='exa_tension';Work_Dirctory='D:\PhiPsi work\exa_tension';
% ---------------------以下是场问题相关-------------------------
% Filename='Static_Field_test_1_fine';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Static_Field_test_1_fine';
% Filename='Static_Field_shale_gas';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Static_Field_shale_gas';
% Filename='Transient_Field_shale_gas';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_shale_gas';
% Filename='Transient_Field_shale_gas2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_shale_gas2';
% Filename='Transient_Field_shale_gas3';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_shale_gas3';
% Filename='Transient_Field_book_analytical';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_book_analytical';
% Filename='Transient_Field_shale_paper04';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_shale_paper04';
% Filename='Transient_Field_shale_paper04-1';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_shale_paper04-1';
% Filename='Transient_Field_shale_paper04-2';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_shale_paper04-2';
% Filename='Transient_Field_shale_paper04-3';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_shale_paper04-3';
%Filename='Transient_Field_thermal';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Transient_Field_thermal';

% ---------------------以下是复合材料问题相关-------------------------
% Filename='compos_16mmx4mm_all_fixed';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_16mmx4mm_all_fixed';
% Filename='compos_16mmx4mm_free';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_16mmx4mm_free';
% Filename='compos_16mmx4mm_uni_tension';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_16mmx4mm_uni_tension';
% Filename='compos_16mmx4mm_uni_tens_fine';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_16mmx4mm_uni_tens_fine';
% Filename='compos_10mmx10mm_uni_tension';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_10mmx10mm_uni_tension';
% Filename='compos_10mmx10mm_free';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_10mmx10mm_free';
% Filename='compos_10mmx10mm_uni_tension_fin';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_10mmx10mm_uni_tension_fin';
% Filename='compos_1mx1m_uni_tension';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_1mx1m_uni_tension';
% Filename='compos_4mmx8mm_uni_tens';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\compos_4mmx8mm_uni_tens';
% ---------------------以下是动态分析问题相关-------------------------
% Filename='beam';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\beam';
% Filename='Dynamic_3_points_beam_Initial_V';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Dynamic_3_points_beam_Initial_V';
% Filename='Dynamic_3_points_beam_Initial_V_cor';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\Dynamic_3_points_beam_Initial_V_cor';
% Filename='EQ_dam_test';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\EQ_dam_test';
% Filename='EQ_dam_test_fine1';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\EQ_dam_test_fine1';
% ---------------------以下是PhiPsi网站算例相关-------------------------
% Filename='exa_inclusions';Work_Dirctory='D:\PhiPsi work\exa_inclusions';
% Filename='exa_tension';Work_Dirctory='D:\PhiPsi work\exa_tension';
% Filename='exa_earthquake';Work_Dirctory='D:\PhiPsi work\exa_earthquake';
% Filename='exa_hydraulic_fracturing';Work_Dirctory='D:\PhiPsi work\exa_hydraulic_fracturing';
% ---------------------分子动力学模拟相关-------------------------
Filename='MD_test1';Work_Dirctory='D:\PhiPsi fortran work\PhiPsi work\MD_test1';

Num_Step_to_Plot      = -999             ;%后处理结果计算步号或者破裂步号(对于水力压裂分析),若为-999,则全部绘制
Defor_Factor          = 1                ;%变形放大系数
Key_TipEnrich         = 1                ;%裂尖增强方案：1,标准；2,仅F1; 3,光滑过渡Heaviside
Key_HF_Analysis       = 0                ;%水力压裂分析
%-------------------------------
Key_Animation= [1 1 0 1 1];           % 1:displacement(2,Gauss);2:stress(2,Gauss);3:deformation;4:场变量(1:仅场变量,2:仅流量矢量,3:场变量和流量矢量);5:MD
Key_Ani_Ave  = [0 0 0 0 0];           % Key for uniform maxima and minima(1:displacement;2:stress;3:Blank;4:场变量(仅支持平均显示,即Key_Ani_Ave(4)==1));5:Blank 
Time_Delay   = 0.025;                 % Delay time of each frame of the gif animation,default: 0.025
Key_Time_String = 1;                  %时间的单位: =1,则为s;=2,min;=3,hour;=4,day;=5,month;=6,year
%-------------------------------
% 第1行,有限元网格: Mesh(1),Node(2),El(3),Gauss poin ts(4),
%                   5: 裂缝及裂缝坐标点(=1,绘制裂缝;=2,绘制裂缝及坐标点),
%                   6: 计算点及其编号(=1,计算点;=2,计算点和编号),
%                   7: 裂缝节点(计算点)相关(=1,节点集增强节点载荷;=2,计算点净水压;=3,计算点流量;=4,计算点开度),
%                   增强节点(8),网格线(9),
%                   支撑剂(10),单元应力状态是否σ1-σ3>Tol(11),天然裂缝(12),单元接触状态(13),裂缝编号(14),Fracture zone(15)
% 第2行,网格变形图: Deformation(1),Node(2),El(3),Gauss points(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   FsBs(7=1or2or3),Deformed and undefor(8),Blank(9),支撑剂(10),Blank(11),Blank(12),
%                   单元接触状态(13),增强节点(14),Fracture zone(15)
% 第3行,应力云图:   Stress Contour(1,2:Gauss points),(2:1,Only Mises stress;2,仅x应力;3,仅y应力;4,仅剪应力),主应力(3:1,主应力;2,主应力+方向;3,仅最大主应力),
%                   Crack(5:1,line;2,shape),Scaling Factor(6),
%                   undeformed or Deformed(8),mesh(9),支撑剂(10)Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
% 第4行,位移云图:   Plot Dis-Contour(1,2:Gauss points),Blank(2),Blank(3),Blank(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   Blank(7),undeformed or Deformed(8),mesh(9),支撑剂(10),Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
% 第5行,场问题云图: Plot Contour(1:场值,2:流量矢量,3:场值+流量矢量),Blank(2),Blank(3),Blank(4),Crack(5:1,line;2,shape),Scaling Factor(6),
%                   Blank(7),undeformed or Deformed(8),mesh(9),支撑剂(10),Blank(11),Blank(12),Blank(13),Blank(14),Fracture zone(15)
% 第6行,分子动力学: Plot Contour(1:位置,2:速度,3:),轨迹(2=1,全部轨迹;>1,轨迹包括的计算步数),Blank(3),Blank(4),Blank(4),Scaling Factor(6),
%                   Blank(7),Original location(8),plot a mesh(9),Blank(10),Blank(11),Blank(12),Blank(13),Blank(14),Box(15)
%                         1   2   3   4   5   6              7   8   9  10  11  12  13  14   15
Key_PLOT(1,:)         = [ 0,  0,  0,  0,  1,  0,             4,  0,  1  ,1  ,0  ,1  ,1  ,0  ,1];  
Key_PLOT(2,:)         = [ 0,  0,  0,  0,  2,  Defor_Factor,  3,  0,  1  ,1  ,1  ,1  ,1  ,0  ,1];  
Key_PLOT(3,:)         = [ 0,  1,  0,  0,  1,  Defor_Factor,  0,  1,  1  ,0  ,0  ,1  ,0  ,0  ,1];  
Key_PLOT(4,:)         = [ 0,  0,  0,  0,  1,  Defor_Factor,  0,  1,  1  ,1  ,0  ,1  ,0  ,0  ,1];
Key_PLOT(5,:)         = [ 0,  0,  0,  0,  1,  Defor_Factor,  0,  0,  1  ,1  ,0  ,1  ,0  ,0  ,1];   
Key_PLOT(6,:)         = [ 1, 50,  0,  0,  0,  1,             0,  0,  0  ,0  ,0  ,0  ,0  ,0  ,1];  
%##########################################################################################################
%##########################            End of user defined part        #####################################
%###########################################################################################################

PhiPsi_Post_2_Go
