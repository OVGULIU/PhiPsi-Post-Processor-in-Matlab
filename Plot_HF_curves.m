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

function Plot_HF_curves(POST_Substep)
%ˮ��ѹ�ѷ������߻������.

global Key_PLOT Full_Pathname Num_Node Num_Foc_x Num_Foc_y Foc_x Foc_y
global num_Crack Key_Dynamic Real_Iteras Real_Sub Key_Contour_Metd
global Output_Freq num_Output_Sub Key_Crush Num_Crack_HF_Curves Size_Font 
global Plot_Aperture_Curves Plot_Pressure_Curves Num_Step_to_Plot 
global Plot_Velocity_Curves Plot_Quantity_Curves Plot_Concentr_Curves
global Plot_Tan_Aper_Curves  Plot_Wpnp_Curves Plot_Wphp_Curves

%���ж�ȡ�ļ��������ڶ������ƣ�
if Plot_Pressure_Curves==1
    if exist([Full_Pathname,'.cpre_',num2str(Num_Step_to_Plot)], 'file') ==2 
		disp('    > Read *.cpre file....') 
		namefile= [Full_Pathname,'.cpre_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Pressure(lineNum,1:c_num)  = str2num(TemData);   
			average_pres=sum(Pressure(lineNum,1:c_num))/c_num;  %ƽ��ˮѹ
			num_CalP_each_Crack(lineNum) = c_num;  %ÿ�����Ƶļ������Ŀ
		end
		fclose(data); 
	else
	    return
	end
end
if Plot_Tan_Aper_Curves==1
    if exist([Full_Pathname,'.ctap_',num2str(Num_Step_to_Plot)], 'file') ==2 
		disp('    > Read *.ctap file....'); 
		namefile= [Full_Pathname,'.ctap_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Tan_Aperture(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %ÿ�����Ƶļ������Ŀ
		end
		fclose(data); 
	else
	    return
	end
end
if Plot_Velocity_Curves==1
    if exist([Full_Pathname,'.cvel_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp('    > Read *.cvel file....'); 
		namefile= [Full_Pathname,'.cvel_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Velocity(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %ÿ�����Ƶļ������Ŀ
		end
		fclose(data); 
	else
	    return
	end
end

if Plot_Quantity_Curves==1
	if exist([Full_Pathname,'.cqua_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp('    > Read *.cqua file....'); 
		namefile= [Full_Pathname,'.cqua_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Quantity(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %ÿ�����Ƶļ������Ŀ
		end
		fclose(data); 
	else
	    return
	end
end

if Plot_Concentr_Curves==1
	if exist([Full_Pathname,'.ccon_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp('    > Read *.ccon file....'); 
		namefile= [Full_Pathname,'.ccon_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Concentr(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %ÿ�����Ƶļ������Ŀ
		end
		fclose(data); 
	else
	    return
	end
end

if Plot_Wpnp_Curves==1
	if exist([Full_Pathname,'.wpnp_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp('    > Read *.wpnp file....'); 
		namefile= [Full_Pathname,'.wpnp_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			wpnp(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %ÿ�����Ƶļ������Ŀ
		end
		fclose(data); 
	else
	    return
	end
end

if exist([Full_Pathname,'.apex_',num2str(Num_Step_to_Plot)], 'file') ==2  
	disp('    > Read *.apex file....') 
	namefile= [Full_Pathname,'.apex_',num2str(POST_Substep)];
	data=fopen(namefile,'r'); 
	lineNum = 0;
	while ~feof(data)
		lineNum = lineNum+1;
		TemData = fgetl(data);              
		c_num   = size(str2num(TemData),2); 
		x(lineNum,1:c_num)  = str2num(TemData); 
	end
	fclose(data); 
else
	return
end

if exist([Full_Pathname,'.apey_',num2str(Num_Step_to_Plot)], 'file') ==2  
	disp('    > Read *.apey file....') 
	namefile= [Full_Pathname,'.apey_',num2str(POST_Substep)];
	data=fopen(namefile,'r'); 
	lineNum = 0;
	while ~feof(data)
		lineNum = lineNum+1;
		TemData = fgetl(data);              
		c_num   = size(str2num(TemData),2); 
		y(lineNum,1:c_num)  = str2num(TemData); 
	end
	fclose(data); 
else
	return
end

if Plot_Aperture_Curves==1
    if exist([Full_Pathname,'.cape_',num2str(Num_Step_to_Plot)], 'file') ==2 
		disp('    > Read *.cape file....'); 
		namefile= [Full_Pathname,'.cape_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Aperture(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %ÿ�����Ƶļ������Ŀ
		end
		fclose(data); 
	else
	    return
	end
end

%���������Ӧ�����Ƴ���
for i= 1:num_Crack(Num_Step_to_Plot)
	for j=1:num_CalP_each_Crack(i)
	    for k=1:j
		    if k==1
			    L(i,j)=0;
			else
		        L(i,j) = L(i,j) + sqrt((x(i,k)-x(i,k-1))^2+(y(i,k)-y(i,k-1))^2);
			end 
		end
	end
end

if exist([Full_Pathname,'.cpre_',num2str(Num_Step_to_Plot)], 'file') ==2  | ...
   exist([Full_Pathname,'.cape_',num2str(Num_Step_to_Plot)], 'file') ==2 
	% -----------------------------------
	% ���Ƹ������Ƶ�����(ˮ��ѹ�����)
	% -----------------------------------
	for i=1:num_Crack(Num_Step_to_Plot)
		%��鵱ǰ�����Ƿ���Ҫ����
		if ismember(i,Num_Crack_HF_Curves)==1
			%--------------------------------------
			%        ����ˮѹ
			%--------------------------------------
			if Plot_Pressure_Curves==1
				disp(['    > �������� ',num2str(i),' ˮѹ����...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Net pressure of crack 1 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Net pressure of crack 2 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Net pressure of crack 3 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Net pressure of crack 4 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Net pressure of crack 5 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Net pressure of crack 6 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Net pressure of crack 7 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Net pressure of crack 8 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Net pressure of crack 9 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Net pressure of crack 10 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Pressure(i,1:num_CalP_each_Crack(i))/1.0E6,'b-+')
				%�����ļ�
				% c_Length = (L(2,1:num_CalP_each_Crack(2)))';
				% c_Pressure = (Pressure(2,1:num_CalP_each_Crack(2))/1.0e6)';
				% save D:\paper02_crack2_c_Length.txt c_Length -ascii
				% save D:\paper02_crack2_c_Pressure.txt c_Pressure -ascii
			end
			%--------------------------------------
			%        ���ƿ���
			%--------------------------------------
			if Plot_Aperture_Curves==1
				disp(['    > �������� ',num2str(i),' ��������...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Aperture of crack 1 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Aperture of crack 2 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Aperture of crack 3 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Aperture of crack 4 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Aperture of crack 5 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Aperture of crack 6 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Aperture of crack 7 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Aperture of crack 8 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Aperture of crack 9 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Aperture of crack 10 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Aperture(i,1:num_CalP_each_Crack(i))*1000.0,'b-+')
			end
			%--------------------------------------
			%        �������򿪶�
			%--------------------------------------
			if Plot_Tan_Aper_Curves==1
			  if exist([Full_Pathname,'.ctap_',num2str(Num_Step_to_Plot)], 'file') ==2 
				disp(['    > ������������ ',num2str(i),' ��������...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Tangential aperture of crack 1 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Tangential aperture of crack 2 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Tangential aperture of crack 3 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Tangential aperture of crack 4 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Tangential aperture of crack 5 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Tangential aperture of crack 6 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Tangential aperture of crack 7 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Tangential aperture of crack 8 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Tangential aperture of crack 9 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Tangential aperture of crack 10 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Tan_Aperture(i,1:num_CalP_each_Crack(i))*1000.0,'b-+')
			  end
			end
			%--------------------------------------
			%        ��������
			%--------------------------------------
			if Plot_Velocity_Curves==1 && exist([Full_Pathname,'.cvel_',num2str(Num_Step_to_Plot)], 'file') ==2  
				disp(['    > �������� ',num2str(i),' ��������...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Velocity of crack 1 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Velocity of crack 2 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Velocity of crack 3 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Velocity of crack 4 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Velocity of crack 5 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Velocity of crack 6 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Velocity of crack 7 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Velocity of crack 8 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Velocity of crack 9 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Velocity of crack 10 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Velocity(i,1:num_CalP_each_Crack(i)),'b-+')
			end
			%--------------------------------------
			%        ��������
			%--------------------------------------
			if Plot_Quantity_Curves==1 && exist([Full_Pathname,'.cqua_',num2str(Num_Step_to_Plot)], 'file') ==2  
				disp(['    > �������� ',num2str(i),' ��������...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Quantity of crack 1 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Quantity of crack 2 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Quantity of crack 3 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Quantity of crack 4 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Quantity of crack 5 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Quantity of crack 6 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Quantity of crack 7 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Quantity of crack 8 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Quantity of crack 9 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Quantity of crack 10 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Quantity(i,1:num_CalP_each_Crack(i)),'b-+')
			end
			%--------------------------------------
			%        ����֧�ż�Ũ������
			%--------------------------------------
			if Plot_Concentr_Curves==1 && exist([Full_Pathname,'.ccon_',num2str(Num_Step_to_Plot)], 'file') ==2  
				disp(['    > ����֧�ż� ',num2str(i),' Ũ������...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Proppant concentration of crack 1','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Proppant concentration of crack 2','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Proppant concentration of crack 3','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Proppant concentration of crack 4','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Proppant concentration of crack 5','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Proppant concentration of crack 6','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Proppant concentration of crack 7','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Proppant concentration of crack 8','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Proppant concentration of crack 9','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Proppant concentration of crack 10','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Concentr(i,1:num_CalP_each_Crack(i)),'b-+')
			end
			%--------------------------------------
			%        ����wpnp�ļ�
			%--------------------------------------
			if Plot_Wpnp_Curves==1 && exist([Full_Pathname,'.wpnp_',num2str(Num_Step_to_Plot)], 'file') ==2  
				disp(['    > ����֧�ż� ',num2str(i),' ֧���ѷ쿪��(�պ�ѹ��Ϊ0)...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it wpnp of crack 1 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it wpnp of crack 2 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it wpnp of crack 3 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it wpnp of crack 4 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it wpnp of crack 5 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it wpnp of crack 6 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it wpnp of crack 7 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it wpnp of crack 8 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it wpnp of crack 9 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it wpnp of crack 10 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),wpnp(i,1:num_CalP_each_Crack(i))*1000,'b-+')
			end
		end
	end
end