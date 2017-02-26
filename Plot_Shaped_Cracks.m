% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_Shaped_Cracks(Shaped_Crack_Points)
% This function plots the shaped cracks.

	for i = 1:length(Shaped_Crack_Points)
	        c_Last_Shaped_Points = Shaped_Crack_Points{i};
			
			% Plot the division points
			% plot(c_Last_Shaped_Points(:,1),c_Last_Shaped_Points(:,2),'o','Color','r','MarkerSize',5)

			% Patch the shaped crack.
			patch(c_Last_Shaped_Points(:,1),c_Last_Shaped_Points(:,2),'white','edgecolor','black','LineWidth',1.0)	
			
			% patch(c_Last_Shaped_Points(:,1),c_Last_Shaped_Points(:,2),'white','edgecolor','white','LineWidth',0.1)	
			
			% patch(c_Last_Shaped_Points(:,1),c_Last_Shaped_Points(:,2),'red','edgecolor','black','LineWidth',0.1)	
			
			% if i==1
			    % patch(c_Last_Shaped_Points(:,1),c_Last_Shaped_Points(:,2),[128/255,138/255,135/255],'edgecolor','black','LineWidth',0.1)	
			% end
			% if i==2
			    % patch(c_Last_Shaped_Points(:,1),c_Last_Shaped_Points(:,2),'white','edgecolor','black','LineWidth',0.1)	
				% patch(c_Last_Shaped_Points(:,1),c_Last_Shaped_Points(:,2),[41/255,167/255,225/255],'edgecolor','black','LineWidth',0.1)
			% end			
			% patch(c_Last_Shaped_Points(:,1),c_Last_Shaped_Points(:,2),'white','edgecolor','black','LineWidth',0.1)
		% end
		    % n=size(c_Last_Shaped_Points,1)
		    % for i=1:(n+1)/2
		    % length_q = length(Shaped_Crack_Points)
		     % aperture=sqrt((c_Last_Shaped_Points(i,1) - c_Last_Shaped_Points(n+1-i,1))^2+(c_Last_Shaped_Points(i,2) - c_Last_Shaped_Points(n+1-i,2))^2)
			% aperture2=sqrt((c_Last_Shaped_Points(2,1) - c_Last_Shaped_Points(14,1))^2+(c_Last_Shaped_Points(2,2) - c_Last_Shaped_Points(14,2))^2)
	end 
end	
	
