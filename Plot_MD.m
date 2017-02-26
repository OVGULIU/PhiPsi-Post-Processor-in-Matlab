% Written By: Shi Fang, 2017
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_MD
% 分子动力学模拟相关.
global Key_PLOT
global Size_Font 
global Full_Pathname Num_Step_to_Plot
global Color_Backgro_Mesh_1 Color_Backgro_Mesh_2 Color_Backgro_Mesh_3 Color_Backgro_Mesh_4
global Color_Backgro_Mesh_5 Color_Backgro_Mesh_6 Color_Backgro_Mesh_7
global Color_Backgro_Mesh_8 Color_Backgro_Mesh_9 Color_Backgro_Mesh_10
global box_zone_min_x box_zone_max_x box_zone_min_y box_zone_max_y


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% Preparing.
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp(['      ----- Read files......'])

% if Num_Step_to_Plot == -999
    % for i_Check =1:5000
	    % if exist([Full_Pathname,'.mdco_',num2str(i_Check)], 'file') ==2 
	        % Num_Step_to_Plot = i_Check;
	    % end
	% end
% end

% if Num_Step_to_Plot==-999
	% disp(' >> Error :: No result files found, post-processor terminated.') 
	% Error_Message
% end



% 读取Box文件
if exist([Full_Pathname,'.mdbx'], 'file') ==2
    Yes_has_FZ = 1;
	disp('    > Reading mdbx file....') 
	namefile= [Full_Pathname,'.mdbx'];
	data=fopen(namefile,'r'); 
	lineNum =0;
	while ~feof(data)
		lineNum = lineNum+1;
		TemData = fgetl(data);    
		if lineNum==2   %第2行
			ttt_DATA(1:2)  = str2num(TemData);
		end
	end
	fclose(data); 
	box_zone_min_x = 0; 
	box_zone_max_x = ttt_DATA(1);
	box_zone_min_y = 0; 
	box_zone_max_y = ttt_DATA(2);
end

% 如果存在时间步文件
if  exist([Full_Pathname,'.hftm'], 'file') ==2 
	%读取水力压裂分析各破裂步对应的总的迭代次数
	disp('    > Reading hftm file....') 
	namefile= [Full_Pathname,'.hftm'];
	data=fopen(namefile,'r'); 
	lineNum = 0;
	num_Iter = 0;
	while ~feof(data)
		lineNum = lineNum+1;
		TemData = fgetl(data);    
		if lineNum>=2   %第一行是文件标识行,不予读取
			num_Iter = num_Iter+1;                     %总的迭代步数
			c_num   = size(str2num(TemData),2); 	   
			ttt_DATA(num_Iter,1:4)  = str2num(TemData);
		end
	end
	fclose(data); 
	%最大破裂步数
	Max_Frac = max(ttt_DATA(1:num_Iter,2));
	%提取每个破裂步对应的迭代步号
	for i_Fra = 1:Max_Frac
		Itera_Num(i_Fra) = 0;
		%所有破裂步间循环
		for i_ter = 1:num_Iter
			if ttt_DATA(i_ter,2)== i_Fra &&  ttt_DATA(i_ter,3) > Itera_Num(i_Fra)
				Itera_Num(i_Fra) = ttt_DATA(i_ter,3);
				Itera_HF_Time(i_Fra) = ttt_DATA(i_ter,4);
			end
		end
	end
% 如果不存在时间步文件
else
    for iii = 1:Num_Step_to_Plot
        Itera_Num(iii) = iii;
	end
end

num_Iter = num_Iter +1;
%Itera_Num

%-999
if Num_Step_to_Plot == -999
    Num_Step_to_Plot = Itera_Num(num_Iter);
end

%检查要绘制的是否存在
if exist([Full_Pathname,'.mdco_',num2str(Num_Step_to_Plot)], 'file') ~=2  
	disp(' >> Error :: No result files found, post-processor terminated.') 
	Error_Message
end

%获取分子数目
MD_Coor = load([Full_Pathname,'.mdco_',num2str(Num_Step_to_Plot)]);
num_molecule = size(MD_Coor,1);
disp(['    Number of molecules:',num2str(num_molecule)]);

% 如果需要绘制轨迹线,则很耗时间,可以先把所有位置文件读入内存
if Key_PLOT(6,2) >= 1
    % all_MD_Coor=cell(num_Iter,)
    for ii=1:num_Iter
	    all_MD_Coor(ii,1:num_molecule,1:3) = load([Full_Pathname,'.mdco_',num2str(Itera_Num(ii))]);
    end
	%获取当前步对应的c_i号
	for uuu =1:num_Iter
	    if Itera_Num(uuu)==Num_Step_to_Plot
		    c_i = uuu;
		end
	end
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% New figure.
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Tools_New_Figure
hold on;
title('\it Position of particles','FontName','Times New Roman','FontSize',Size_Font)
axis off; axis equal;
axis([box_zone_min_x box_zone_max_x box_zone_min_y box_zone_max_y]);

%<<<<<<<<<<<<<<<<<
% 绘制轨迹线.
%<<<<<<<<<<<<<<<<<
if Key_PLOT(6,2) >= 1
    disp(['      ----- Plotting moving path......'])  
	if c_i>=2
	    tem1 = 1;
	    tem2 = c_i-1;
		%如果Key_PLOT(6,2)=2,则只绘制最近 Key_PLOT(6,2)个计算步的轨迹
		if Key_PLOT(6,2) > 1
		    tem1 = tem2 - Key_PLOT(6,2);
		end
		for jjj =tem1:tem2
			% MD_Coor = load([Full_Pathname,'.mdco_',num2str(Itera_Num(jjj+1))]);
			% Old_MD_Coor = load([Full_Pathname,'.mdco_',num2str(Itera_Num(jjj))]);
			MD_Coor(1:num_molecule,1:3) = all_MD_Coor(jjj+1,1:num_molecule,1:3);
			Old_MD_Coor(1:num_molecule,1:3) = all_MD_Coor(jjj,1:num_molecule,1:3);
			all_c_x(1,1:num_molecule) = MD_Coor(1:num_molecule,2);
			all_c_x(2,1:num_molecule) = Old_MD_Coor(1:num_molecule,2);
			all_c_y(1,1:num_molecule) = MD_Coor(1:num_molecule,3);
			all_c_y(2,1:num_molecule) = Old_MD_Coor(1:num_molecule,3);
			
			line(all_c_x,all_c_y,'LineWidth',1.0,'Color','blue');
		end
	end
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% 绘制分子.
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if Key_PLOT(6,1) == 1
    if exist([Full_Pathname,'.mdco_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp(['      ----- Plotting positions of particles...'])
		% Read gauss point coordinates file.
		MD_Coor = load([Full_Pathname,'.mdco_',num2str(Num_Step_to_Plot)]);
		plot(MD_Coor(:,2),MD_Coor(:,3),'bo','MarkerSize',4,'Color','black','MarkerFaceColor','black')
		clear MD_Coor
	end
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%         绘制Box
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if Key_PLOT(6,15)==1 
	%如果定义了破裂区
	disp(['      ----- Plotting box......'])  
    c_x = [box_zone_min_x,box_zone_max_x];
	c_y = [box_zone_min_y,box_zone_min_y];
	line(c_x,c_y,'LineWidth',1.5,'Color','green')
    c_x = [box_zone_max_x,box_zone_max_x];
    c_y = [box_zone_min_y,box_zone_max_y];
	line(c_x,c_y,'LineWidth',1.5,'Color','green')
    c_x = [box_zone_max_x,box_zone_min_x];
	c_y = [box_zone_max_y,box_zone_max_y];
	line(c_x,c_y,'LineWidth',1.5,'Color','green')
    c_x = [box_zone_min_x,box_zone_min_x];
	c_y = [box_zone_max_y,box_zone_min_y];
	line(c_x,c_y,'LineWidth',1.5,'Color','green')
end


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%        Save pictures.
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Save_Picture(c_figure,Full_Pathname,'mdco')

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
