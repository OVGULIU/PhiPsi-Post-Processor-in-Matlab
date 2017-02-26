% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

% This  subroutine defines controlling parameters of PhiPsi.

global Filename Work_Dirctory Key_Dynamic
global Key_Problem Num_Ini_Crack
global Num_Substeps Gravity Reduc_Factor_Kill
global Key_PLOT Key_Animation Key_Ani_Ave Time_Delay
global Size_Font Color_Mesh Color_Vector 
global Color_outline_Udefor Color_Backgro_Defor_1 Elem_Fontsize Node_Fontcolor
global Node_Fontsize Elem_Fontcolor Num_Contourlevel
global POST_Substep Num_all_Iteras Num_force_Iteras delt_time_NewMark
global Key_Initiation Crack Color_Contourlevel
global Color_Crack Width_Crack Key_Contour_Metd
global Key_Parallel Key_Figure_off Key_Integral_Sol
global Key_HF Key_Propagation CFCP Num_Accuracy_Contour
global Num_Divis_Elment Key_Gravity Initial_Try_Pressure
global Key_Frictional_H Key_Symm_Ele_Bore
global Output_Freq Inject_Bore_Quantity Key_Plot_Pressure Key_Plot_Quantity
global Viscosity Alpha_Picard Picard_Tol Edge_Ele_Num Num_Ele_Bore
global Fac_Ini_Crack Fac_Pro_Crack Key_Stop_Ini Key_Flipped_Gray
global Color_Backgro_Mesh_1 Color_Backgro_Mesh_2 Color_Backgro_Mesh_3 Color_Backgro_Mesh_4
global Color_Backgro_Mesh_5 Color_Backgro_Mesh_6 Color_Backgro_Mesh_7
global Color_Backgro_Mesh_8 Color_Backgro_Mesh_9 Color_Backgro_Mesh_10
global Color_Backgro_Defor_1 Color_Backgro_Defor_2 Color_Backgro_Defor_3 Color_Backgro_Defor_4
global Color_Backgro_Defor_5 Color_Backgro_Defor_6 Color_Backgro_Defor_7
global Color_Backgro_Defor_8 Color_Backgro_Defor_9 Color_Backgro_Defor_10
global Material_Type Material_Para Key_Force_Control
global k_tt d_elplosive Key_Crush Color_Crushed_ele
global Key_BB Radius_Borehole Max_Blast_Pressure ANSYS_Pressure 
global Ele_Initial_Crack Angle_Initial_Crack L_Initial_Crack
global Weibull_Para Key_Weibull Key_Weibull_type Num_Weibull_Points
global Min_L_Pro_Crack Key_Gas_Flow Key_FD_Curves Node_Number_FD Num_Force_Divs
global a_Weight Key_Pore_Pre Coff_a_AMPT Key_SIFs_Method
global Color_Inclusion
 
%---------------------------------------------------------------------------------
%----------------------- Analysis type and control -------------------------------
%---------------------------------------------------------------------------------
Key_Parallel     = 0;                                      % Key for parallel computing.
Key_Dynamic      = 0;                                      % 0:Static analysis; 1:Implicit dynamic analysis,2:Explicit dynamic analysis.
Key_Initiation   = 0;                                      % 0:No new crack will initiate; 1:New cracks will initiate.
Key_Crush        = 0;                                      % If Key_Crush=1, then rock will crush if σ > σc.           
Num_Ini_Crack    = 1;                                      % The maximum number of produced cracks. 
Fac_Ini_Crack    = 3;                                      % Length of the initial crack, default: 3, 3*length_of_element_side.
Key_Stop_Ini     = 0;                                      % Stop calculating if new crack is produced, only for static analysis.
Key_Propagation  = 1;                                      % Key for crack propagation(calculate KI and KII).  
Fac_Pro_Crack    = 2;                                      % Length of the propagation increment, available for static analysis, default: 2.
Key_Pore_Pre     = 0;                                      % Consider pore pressure.
%-----Frictional crack-------
Key_Frictional_H = 0;                                      % Key for frictional crack.
k_tt             = 0;                                      % k_tt, frictionless.
% k_tt             = 10000e9;                              % k_tt, stiffness of the crack faces.
%------Force-Displacement------
Key_Force_Control = 1;                                     % 1: Force factor equals 1 and remains unchanged(default);
                                                           % 2: Force factor increases linearly;
                                                           % 3: Reduce force factor when crack propagate.
% follow available only when Key_Force_Control=3												   
Num_Force_Divs   = 20;                                     % Number of divisions of the Force.
Key_FD_Curves    = 0;                                      % Plot Force-Displacement curve.
Node_Number_FD   = 58;                                     % Node number for Force-Displacement curve.
%------Hydraulic fracturing------
Key_HF           = 0;                                      % Key for fluid-solid-coupling.
Key_Symm_Ele_Bore= 1;                                      % Key for hydraulic fracturing symmetry model.
Inject_Bore_Quantity = 0.001;                              % Quantity of flow of the injection bore hole(ignore *Inject_Bore_Pressure).
Num_Divis_Elment = 10;
Initial_Try_Pressure = 1e6;
Key_Gravity      = 0;       
Viscosity        = 1;                                      % Viscosity of Water.   
Alpha_Picard     = 0.25;                                   % Parameter of Picard iteration.
Picard_Tol        = 0.01;                                  % Tolerance of Picard iteration.
%------Borehole Blasting---------                            % Borehole blasting
Key_BB           =0;                                       % Key for borehole blasting analysis.
Key_Gas_Flow     =1;                                       % If Key_Gas_Flow=0, then only consider dynamic stress wave.
Radius_Borehole  = 40e-3/2;
Max_Blast_Pressure = 53.6e6;
ANSYS_Pressure    = 200e6;
L_Initial_Crack   = 0.03;                                  % Length of the initial crack(necessary for non-uniform-size mesh).
Min_L_Pro_Crack   = 0.022;                                 % Min length of the crack segment(necessary for non-uniform-size mesh).
Key_Plot_Curves   = 1;                                     % Plot curves of the SIFs, Principal Stress, velocity of crack growth.
%------------------------------
Num_Substeps     = [1 2 2];                                % Number of substeps (1)predicted value; (2)min value;(3)max value
Key_Figure_off   = 0;                                      % Key for close the graphics window.
Key_Integral_Sol = 2;                                      % 1: Subtriangle; 2: 64 gauss points.
Key_Contour_Metd = 2;                                      % 1: Slow and fine(not available for animation); 2: fast but coarse(default).
%--------Implicit dynamic------	
Num_all_Iteras   = 80;                                    % Total number of iterations
Num_force_Iteras = 0;                                     % Number of iterations with force applied
delt_time_NewMark= 1e-6;                                  % Delta time of Newmark
%---------------------------------------------------------------------------------
%------------------------------ MATERIAL PARAMETERS ------------------------------
%---------------------------------------------------------------------------------
Key_Problem      = 2;                                      % 1:plane stress; 2:plane strain.		
Material_Type    = [1,1,1,1,1,1,1,1,1,1];                  % 1:ISO; 
                                                           % 2:Orthotropic;
														   % 3:Orthotropic and axial symmetry(then the mat matrix should be transform);	
                                                           % 4:Mises yield criterion;
                                                           % 5:Mohr-coulomb yield criterion.	
Key_SIFs_Method  = 1;                                      % 1: Interaction integral method;
                                                           % 2: Displacement interpolation method.                                 														   
CFCP             = 1;                                      % Criterion for Crack Propagation:
                                                           % 1, the weighted average of maximum principal tensile stress criterion;
														   % 2, the maximum circumferential tensile stress criterion.	
Coff_a_AMPT       = 0.1;                                   % Coefficient a of the weighted average of maximum principal 
                                                           % tensile stress criterion, default to 1, see my doctoral 
														   % dissertation at page 25.  
														   
a_Weight         = 1;
%------------------------------														   
Key_Weibull      = 0;														   
Num_Weibull_Points  =100;				                   										   
%------------------------------ 
%      1      2      3      4      5      6      7      8     9     10    11        12    13    14    15
% Isotropic material,if thiness<>1,then F should be changed to get the same stress
%     (E,     v,    ρ,  thiness, σt,   KIc,   σc,Pore Pre,Biot coef ,blank,blank,blank,blank,blank,blank)
% Orthotropic plane stress material
%     (E1,    E2,   v12,   G12,   ρ,  thiness, σt1,  σt2, KIc_1,KIc_2,alpha(°),σc1, σc2,   blank,blank)
% Orthotropic plane strain material
%     (E1,    E2,   E3,    v12,   v23,   v13,    G12,  ρ,   σt1, σt2, KIc_1,    KIc_2, alpha(°),σc1, σc2)
% ------------------------------                               
% Material_Para    =[31.6e9,0.18,2170,1,0.1e6,0.01e6,200e6,0,0,0,0,0,0,0,0];
%------------------------------  
% 1                               2          3                              4
% Tensile(1),Compress(2),both(3); m;Aver tensile strength;Ave compress strength
%------------------------------  				   
% Weibull_Para     =[1,    3, 4.5e6,    200e6;
                   % 0,    3, 4.5e6,    200e6];   
%                              
Material_Para    =[30e9,0.2,2000,20e-3,-100e6,-100e6,5e6,1,0,0,0,0,0,0,0];                                     % ISO
% Material_Para    =[10e9,0.2,2000,20e-3,1e6,1e6,0,0,0,0,0,0,0,0,0];                                     % ISO
% Material_Para    =[41.4e9,23.5e9,0.3,12e9,2000,25e-3,1e6,1e6,1.2e6,10.8e6,90,200e6,100e6,0,0];         % Orth_Plane_Stress
% Material_Para    =[114.8e9,11.7e9,11.7e9,0.21,0.21,0.21,5.99e9,2000,1e6,1e6,1.2e6,10.8e6,0,0,0];       % Orth_Plane_Strain
%------------------------------mining_1
% Material_Para    = [37.5e9,0.17,2650,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;
					% 36.9e9,0.18,2570,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;
					% 10.4e9,0.30,1300,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;
					% 17.0e9,0.18,2650,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;
					% 18.6e9,0.19,2600,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0];    % ISO
					
% Material_Para    = [37.5e9,0.17,2650,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;
					% 37.5e9,0.17,2650,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;
					% 37.5e9,0.17,2650,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;
					% 37.5e9,0.17,2650,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;
					% 37.5e9,0.17,2650,20e-3,0.1e6,0.1e6,0,0,0,0,0,0,0,0,0;];   % ISO
%------------------------------
Gravity          = [9.8 1];                                % Acceleration of gravity (1)value; (2)direction
%------------------------------
Reduc_Factor_Kill= 1e-6;                                   % Reduction factor of stiffness matrix of killed elements
%---------------------------------------------------------------------------------
%------------------------- Post processing control parameters --------------------
%---------------------------------------------------------------------------------
Output_Freq   = 1;                                         % Frequency of output: every n iterations(includes the first) or 0: only last
POST_Substep  = 'last';                                    % The number of substep to be post processed('last','first',or a num)
%------------------------------
Key_PLOT      = zeros(4,9);                                % Initialize the Key_PLOT
%------------------------------
% ---- Line #1 ----
% Plot mesh(1),Node(2),El(3),Gauss points(4),Crack(5),Blank(6),Blank(7),Blank(8),Blank(9)
% ---- Line #2 ----
% Plot deformation(1),Node(2),El(3),Gauss points(4),Crack(5:1,line;2,shape),Scaling Factor(6),FsBs(7=1or2or3),
%                                                                         Deformed and undefor(8),Blank(9)
% ---- Line #3 ----
% Plot Stress Contour(1,2:Gauss points),Only Mises stress(2=1),Principle stress(3=1;3=2,contour and direction),blank,
%                              Crack(5:1,line;2,shape),Scaling Factor(6),,undeformed or Deformed(8),mesh line(9)
% ---- Line #4 ----
% Plot Dis-Contour(1,2:Gauss points),bl,bl,bl,Crack(5:1,line;2,shape),Scaling Factor(6),,undeformed or Deformed(8),mesh line(9)
%                         1   2   3   4   5  6    7   8   9
% Key_PLOT(1,:)         = [ 1,  1,  1,  1,  1, 0,   0,  0,  0];  
% Key_PLOT(2,:)         = [ 0,  0,  0,  0,  2, 1, 3,  0,  0]; 
% Key_PLOT(3,:)         = [ 0,  0,  1,  0,  1, 1, 1,  1,  1];  
% Key_PLOT(4,:)         = [ 0,  0,  0,  0,  1, 1, 0,  1,  1];  
%------------------------------        
Key_Animation         = [0 0 0 0];                         % 1: displacement(2,Gauss); 2: stress(2,Gauss); 3: deformation; 4: Blank
Key_Ani_Ave           = [1 0 0 0];                         % Key for uniform maxima and minima(1: displacement; 2: stress; 3: Blank; 4: Blank)
Time_Delay            = 0.25;                             % Delay time of each frame of the gif animation,default: 0.025
%------------ HF --------------
Key_Plot_Pressure     = 1;                                 % Plot water pressure.
Key_Plot_Quantity     = 0;                                 % Plot quantity of flow.   
%------------------------------
Size_Font             = 12;                                % Front size, Default=12; 
Color_Crack           = 'black';                           % Color of cracks
Width_Crack           = 2.0 ;                              % Width of lines of cracks
Color_Mesh            = 'black';                           % Color of mesh of the contours and vectors display,default:'black'
Color_Vector          = 'blue';                            % Color of the vectors
% Color_Backgro_Mesh_1  = [0.92,0.92,0.92];                % Color of mesh background of material 1,[0.49,1.00,0.83]
% Color_Backgro_Mesh_1  = [0.49,1.00,0.83];                % Color of mesh background of material 1,[0.49,1.00,0.83]
% Color_Backgro_Mesh_1  = [30/255,144/255,1];
% Color_Backgro_Mesh_1  = [30/255,144/255,1];
Color_Backgro_Mesh_1  = [245/255,245/255,245/255];

Color_Backgro_Mesh_2  = [0.94,0.50,0.83];                  % Color of mesh background of material 2
Color_Backgro_Mesh_3  = [0.29,0.30,0.53];                  % Color of mesh background of material 3
Color_Backgro_Mesh_4  = [0.39,0.70,0.43];                  % Color of mesh background of material 4
Color_Backgro_Mesh_5  = [0.66,0.58,0.50];                  % Color of mesh background of material 5
Color_Backgro_Mesh_6  = [0.59,1.00,0.23];                  % Color of mesh background of material 6
Color_Backgro_Mesh_7  = [0.69,1.00,0.13];                  % Color of mesh background of material 7
Color_Backgro_Mesh_8  = [0.69,0.80,0.13];                  % Color of mesh background of material 8
Color_Backgro_Mesh_9  = [0.69,0.70,0.13];                  % Color of mesh background of material 9
Color_Backgro_Mesh_10 = [0.69,0.60,0.13];                  % Color of mesh background of material 10
Color_Backgro_Defor_1 = [0.49,1.00,0.83];                  % Color of deformation background of material 1
Color_Backgro_Defor_2 = [0.94,0.50,0.83];                  % Color of deformation background of material 2
Color_Backgro_Defor_3 = [0.29,0.30,0.53];                  % Color of deformation background of material 3
Color_Backgro_Defor_4 = [0.39,0.70,0.43];                  % Color of deformation background of material 4
Color_Backgro_Defor_5 = [0.66,0.58,0.50];                  % Color of deformation background of material 5
Color_Backgro_Defor_6 = [0.59,1.00,0.23];                  % Color of deformation background of material 6
Color_Backgro_Defor_7 = [0.69,1.00,0.13];                  % Color of deformation background of material 7
Color_Backgro_Defor_8 = [0.69,0.80,0.13];                  % Color of deformation background of material 8
Color_Backgro_Defor_9 = [0.69,0.70,0.13];                  % Color of deformation background of material 9
Color_Backgro_Defor_10= [0.69,0.60,0.13];                  % Color of deformation background of material 10
Color_outline_Udefor  = 'red';                  % Color of undeformation background
Color_Crushed_ele     = 'red';        

% Color_Inclusion       = [160/255,102/255,211/255'];         %夹杂的颜色
Color_Inclusion       = [227/255,23/255,13/255'];         %夹杂的颜色
%------------------------------
Node_Fontsize         = 8;                                % Font Size of node number,Default:8
Elem_Fontsize         = 8;                                % Font Size of element number display,Default:8
Node_Fontcolor        = 'black';                           % Font colour of node number display                                                                                            
Elem_Fontcolor        = 'black';                           % Font colour of element number display
%------------------------------
Color_Contourlevel    = 'jet';                             % ColorContourLevel,'jet','hot','cool','gray'
Key_Flipped_Gray       =   0;                              % Flipped gray contour level,more bigger,more deeper.
Num_Contourlevel      =  50;                               % Number of contour levels,Default:12  
Num_Accuracy_Contour  =  10;                               % Number of sample point every one element length for contouring.
%------------------------------------------------------------------      
%------------------  End of PhiPsi Input_Control  -----------------  
%------------------------------------------------------------------                    