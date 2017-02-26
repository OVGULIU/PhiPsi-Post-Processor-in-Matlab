% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

%-------------------------------------------------------------------
%--------------------- PhiPsi_Post_Plot ----------------------------
%-------------------------------------------------------------------

%---------------- Start and define global variables ----------------
global Key_Dynamic Version Num_Gauss_Points 
global Filename Work_Dirctory Full_Pathname num_Crack
global Num_Processor Key_Parallel Max_Memory POST_Substep
global tip_Order split_Order vertex_Order junction_Order    
global Key_PLOT Key_POST_HF Num_Crack_HF_Curves
global Plot_Aperture_Curves Plot_Pressure_Curves Num_Step_to_Plot
global Key_TipEnrich Key_HF

% 如果Num_Step_to_Plot = -999,则程序自动寻找最后一步的稳定计算结果并后处理
if Num_Step_to_Plot == -999
    for i_Check =1:1000
	    if exist([Full_Pathname,'.disn_',num2str(i_Check)], 'file') ==2 
	        Num_Step_to_Plot = i_Check;
	    end
	end
end

%如果Num_Step_to_Plot=-999,且没有计算结果,则终止程序
if Num_Step_to_Plot==-999
	disp(' >> Error :: No result files found, post-processor terminated.') 
	Error_Message
end

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

% Read input geometry files.
Read_Geo3D
disp(['  '])    

% Check if result files exist.
if exist([Full_Pathname,'.disn_',num2str(Num_Step_to_Plot)], 'file') ~=2
    disp(' >> Error :: No result files found, post-processor terminated.') 
	Error_Message
end

% Get the number of cracks if crack file exists.
if exist([Full_Pathname,'.crax_',num2str(Num_Step_to_Plot)], 'file') ==2  
	file_Crack_X = fopen([Full_Pathname,'.crax_',num2str(Num_Step_to_Plot)]);
	row=0;
	while ~feof(file_Crack_X)
		row=row+sum(fread(file_Crack_X,10000,'*char')==char(10));
	end
	fclose(file_Crack_X);
	num_Crack(Num_Step_to_Plot) = row;
else
    num_Crack(Num_Step_to_Plot) = 0;
end

% Plot.
Plot_Main3D(Num_Step_to_Plot) 

% 绘制HF曲线
if Plot_Aperture_Curves == 1 || Plot_Pressure_Curves==1
    Plot_curves(Num_Step_to_Plot) 
end

Cclock=clock;
% Display end time.
disp([' >> End time is ',num2str(Cclock(2)),'/',num2str(Cclock(3)),'/',num2str(Cclock(1))...
     ,' ',num2str(Cclock(4)),':',num2str(Cclock(5)),':',num2str(round(Cclock(6))),'.'])
	 
% Stop log file.
diary off;

