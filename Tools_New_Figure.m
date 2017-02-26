% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

global Key_Figure_off

% New figure.
if Key_Figure_off == 0     % Visible on.
     % c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on','Renderer','OpenGL');   %采用OpenGL渲染器
     % c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');        
	 % c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on','Renderer','painters'); %默认的渲染器,最慢
	 c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on','Renderer','zbuffer'); %zbuffer渲染器
	 opengl hardware     %打开opengl硬件加速
	% c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.648],'Visible','on');
	% c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.248],'Visible','on');
	%小图片
	% c_figure = figure('units','normalized','position',[0.38,0.38,0.42,0.42],'Visible','off');
elseif Key_Figure_off == 1 % Visible off.
    c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','off');
	
	% c_figure = figure('units','normalized','position',[0.3,0.3,0.5,0.5],'Visible','off');
end