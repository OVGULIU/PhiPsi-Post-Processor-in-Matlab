% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function [Disp_x,Disp_y] = Cal_Anypoint_Disp_Coor(iElem,Enriched_Node_Type,POS,isub,DISP,Kesi,Yita,...
					                                              Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
					                                              Coors_Vertex,Coors_Junction,Coors_Tip)

global Node_Coor Elem_Node Elem_Material
global Num_Elem num_Crack
global Material_Para Key_Problem
global Key_Frictional_H Material_Type
global G_NN G_X_NODES G_Y_NODES G_X_Min G_X_Max G_Y_Min G_Y_Max
global Key_TipEnrich
global num_Hole Hole_Coor Enriched_Node_Type_Hl POS_Hl Elem_Type_Hl
global num_Poly_Inclusion Poly_Incl_Coor_x Poly_Incl_Coor_y

% Calculate the displacement of the points of the crack. 
n1  = Elem_Node(iElem,1);                                                  
n2  = Elem_Node(iElem,2);                                                  
n3  = Elem_Node(iElem,3);                                                  
n4  = Elem_Node(iElem,4);

% Material number of the current element.
mat_num    = Elem_Material(iElem);
% Material type of the current element.
c_mat_type = Material_Type(mat_num);

% Four nodes of the current element
NODES_iElem = G_NN(:,iElem)';
                                           
U = [DISP(n1,2) DISP(n1,3) DISP(n2,2) DISP(n2,3)...
	 DISP(n3,2) DISP(n3,3) DISP(n4,2) DISP(n4,3)];

% Coordinates of the four nodes of the current element
X_NODES = G_X_NODES(:,iElem);
Y_NODES = G_Y_NODES(:,iElem);

% Calculates N, dNdkesi, J and the determinant of Jacobian matrix.
[N,dNdkesi,J,detJ]  = Cal_N_dNdkesi_J_detJ(Kesi,Yita,X_NODES,Y_NODES);

% The inverse matrix of J.
% Inverse_J = inv(J);

% Calculate dNdx.
% dNdx = dNdkesi * Inverse_J;
% size(dNdx)
% Disp_x = U(1)*N(1,1) + U(3)*N(1,3) + U(5)*N(1,5) + U(7)*N(1,7);
% Disp_y = U(2)*N(1,1) + U(4)*N(1,3) + U(6)*N(1,5) + U(8)*N(1,7);  
Disp_x = U(1:2:7)*N(1,1:2:7)';
Disp_y = U(2:2:8)*N(1,1:2:7)';

tem_N(1:4) = N(1,1:2:7);

% Global coordinates of the gauss point.
% Global_coor_Gauss(1) = N(1,1)*X_NODES(1)+N(1,3)*X_NODES(2)+N(1,5)*X_NODES(3)+N(1,7)*X_NODES(4);
% Global_coor_Gauss(2) = N(1,1)*Y_NODES(1)+N(1,3)*Y_NODES(2)+N(1,5)*Y_NODES(3)+N(1,7)*Y_NODES(4);
Global_coor_Gauss(1) = N(1,1:2:7)*X_NODES(1:4);
Global_coor_Gauss(2) = N(1,1:2:7)*Y_NODES(1:4);
c_G_x = Global_coor_Gauss(1);
c_G_y = Global_coor_Gauss(2);

ttt=0;
% Loop through each crack.
for iCrack=1:num_Crack(isub)
												
    % Conventional element.
	if any(Enriched_Node_Type(NODES_iElem,iCrack)) ==0
	    Disp_x = Disp_x;
	    Disp_y = Disp_y;
	% Enriched elements.
	elseif any(Enriched_Node_Type(NODES_iElem,iCrack)) ~=0
		% Loop through each node.
		for iNode = 1:4
			%-----------------------------------------------------------
			%----------- Case 1: Heaviside enriched node ---------------
			%-----------------------------------------------------------
			if Enriched_Node_Type(NODES_iElem(iNode),iCrack) ==2        % Heaviside enriched node
			    % Get the number of the current enriched node.
				Num_Enriched_Node = POS(NODES_iElem(iNode),iCrack);
				% if 2:fully cracked element without kink point or 3:fully cracked element with kink point, then:
				if Elem_Type(iElem,iCrack) == 2 || Elem_Type(iElem,iCrack) == 3
					ref_elem = iElem;
					% Coordinates of the 2 intersections(A,B) of the crack segment and these 4 element(fully cracked) lines.
					Coor_AB = [Coors_Element_Crack(ref_elem,1) Coors_Element_Crack(ref_elem,2);
							   Coors_Element_Crack(ref_elem,3) Coors_Element_Crack(ref_elem,4)];
					% if 3:fully cracked element with kink point, then:
					if Elem_Type(iElem,iCrack) == 3
						% Calculates the distance of the kink point(K) to the line(AB) composed of the 2 intersections(A,B).
						distance_Vertex = Cal_Signed_Distance(Coor_AB,Coors_Vertex(ref_elem,:));	
						H_Vertex = sign(distance_Vertex);	
						% Calculates the distance of the gauss point to the line(AB) composed of the 2 intersections(A,B).
						distance_Gauss = Cal_Signed_Distance(Coor_AB,Global_coor_Gauss);	
						H_gp = sign(distance_Gauss);	
						% Gauss point is under the triangle KAB. 
						if H_Vertex*H_gp <= 0
							H_gp = H_gp;
						else
							% The triangle KAB.
							Tri_KAB = [Coor_AB(1,:); Coor_AB(2,:);Coors_Vertex(ref_elem,:)];
							% Judge if the gauss point is inside the triangle KAB.
							Yes_in_KAB = inpolygon(Global_coor_Gauss(1),Global_coor_Gauss(2), ...
												   Tri_KAB(:,1),Tri_KAB(:,2));
							% If the gauss point is inside the triangle KAB, then:
							if Yes_in_KAB == 1
								H_gp = -H_gp;
							else
								H_gp =  H_gp;
							end
						end
						% Calculate gama for frictional crack.
						if Key_Frictional_H==1
							gama = atan2(Coor_AB(2,2)-Coor_AB(1,2),Coor_AB(2,1)-Coor_AB(1,1));
						end
						% Calculates the distance of the node to the line(AB).
						distance_Node = Cal_Signed_Distance(Coor_AB,[X_NODES(iNode),Y_NODES(iNode)]);
						H_i = sign(distance_Node);
					% if 2:fully cracked element without kink point, then:
					else
						distance_Gauss = Cal_Signed_Distance(Coor_AB,Global_coor_Gauss);
						H_gp = sign(distance_Gauss);	
						distance_Node = Cal_Signed_Distance(Coor_AB,[X_NODES(iNode),Y_NODES(iNode)]);
						H_i = sign(distance_Node);
						% Calculate gama for frictional crack.
						if Key_Frictional_H==1
							gama = atan2(Coor_AB(2,2)-Coor_AB(1,2),Coor_AB(2,1)-Coor_AB(1,1));
						end
					end
					% Calculate displacements.
					if Key_Frictional_H ~=1
						Disp_x = Disp_x + (H_gp-H_i)*tem_N(iNode)*DISP(Num_Enriched_Node,2);
						Disp_y = Disp_y + (H_gp-H_i)*tem_N(iNode)*DISP(Num_Enriched_Node,3);
						ttt=ttt+(H_gp-H_i)*tem_N(iNode)*DISP(Num_Enriched_Node,2);
						% iNode
						% tem_N(iNode)
						% DISP(Num_Enriched_Node,3)
					end
					% Calculate displacements for frictional crack.
					if Key_Frictional_H==1
					    % Attention:DISP(Num_Enriched_Node,3), rather than DISP(Num_Enriched_Node,2)!!!!!!
						Disp_x = Disp_x + (H_gp-H_i)*tem_N(iNode)*cos(gama)*DISP(Num_Enriched_Node,3);   
						Disp_y = Disp_y + (H_gp-H_i)*tem_N(iNode)*sin(gama)*DISP(Num_Enriched_Node,3);
				    end
					
				else
				    Disp_x = Disp_x;
					Disp_y = Disp_y;
				end

			%-----------------------------------------------------------
			%----------- Case 2: Junction enriched node ----------------
			%-----------------------------------------------------------	
			elseif Enriched_Node_Type(NODES_iElem(iNode),iCrack) ==3    % Junction enriched node
				% Get the number of the current enriched node.
				Num_Enriched_Node = POS(NODES_iElem(iNode),iCrack);
		        % Get the number of the Junction element.
			    %%% [~,Domain_El] = Cal_Support_Domain_of_Node(NODES_iElem(iNode),iElem);
			    %%% Jun_elem = Domain_El(find(Elem_Type(Domain_El,iCrack)==4));
				Jun_elem = Node_Jun_elem(NODES_iElem(iNode),iCrack);
				% Coordinates of the 2 intersections(A,B) of the main crack segment and these 4 element(fully cracked) lines.
				Coor_AB = [Coors_Element_Crack(Jun_elem,1) Coors_Element_Crack(Jun_elem,2);
						   Coors_Element_Crack(Jun_elem,3) Coors_Element_Crack(Jun_elem,4)];
				% Coordinates of the 2 intersections(C,D) of the minor crack segment and these 4 element(fully cracked) lines.
				Coor_CD = [Coors_Junction(Jun_elem,1) Coors_Junction(Jun_elem,2);
						   Coors_Junction(Jun_elem,3) Coors_Junction(Jun_elem,4)];
				x0 = [Coors_Junction(Jun_elem,1) Coors_Junction(Jun_elem,2)];
				
				% Calculates the distance of nodes and the gauss point to the main crack segment.
				distance_Node_M  = Cal_Signed_Distance(Coor_AB,[X_NODES(iNode),Y_NODES(iNode)]);
				distance_Gauss_M = Cal_Signed_Distance(Coor_AB,Global_coor_Gauss);
				% Calculates the distance of nodes and the gauss point to the minor crack segment.
				distance_Node_m  = Cal_Signed_Distance(Coor_CD,[X_NODES(iNode),Y_NODES(iNode)]);
				distance_Gauss_m = Cal_Signed_Distance(Coor_CD,Global_coor_Gauss);
				% Calculates the distance of x0 to the main crack segment.
				distance_x0  = Cal_Signed_Distance(Coor_AB,x0);
				H_gp_M = sign(distance_Gauss_M);
				H_i_M  = sign(distance_Node_M); 
				H_gp_m = sign(distance_Gauss_m);
				H_i_m  = sign(distance_Node_m); 
				H_x0   = sign(distance_x0);
				if H_gp_M*H_x0 > 0
					if H_gp_m > 0
						J_gp=  1;
					else
						J_gp= -1;		
					end
				else
					J_gp=  0;
				end
				
				
				if H_i_M*H_x0 > 0
					if H_i_m > 0
						J_i=  1;
					else
						J_i= -1;
					end
				else
					J_i=  0;
				end
				% Calculate displacements.
				Disp_x = Disp_x + (J_gp-J_i)*tem_N(iNode)*DISP(Num_Enriched_Node,2);
				Disp_y = Disp_y + (J_gp-J_i)*tem_N(iNode)*DISP(Num_Enriched_Node,3);

			%-----------------------------------------------------------
			%----------- Case 3: Tip enriched node ---------------------
			%-----------------------------------------------------------
			elseif Enriched_Node_Type(NODES_iElem(iNode),iCrack) ==1    % Tip enriched node
				% Find the fully tip enriched element which the current tip enriched node attached to. 
				% Fully tip enriched element.
				if Elem_Type(iElem,iCrack) == 1
					ref_elem = iElem;
					ref_elem_1=ref_elem;
				% Partly tip enriched element.
				else
					[find_element,xx] = find(Elem_Node == NODES_iElem(iNode));
					[find_location,xx] = find(Elem_Type(find_element,:) ==1);
					if isempty(find_location) ~=1
						ref_elem = find_element(find_location);
					else
						[find_element_1,xx1] = find(Enriched_Node_Type(NODES_iElem(find_element,:),iCrack) == 1);
						node_p = [];
						for i =1:size(find_element_1,1);
							node_p = [node_p; NODES_iElem(find_element_1,xx1(i))]
						end
						for i =1:size(node_p,1)
							[find_element,xx] = find(Elem_Node == node_p(i));
							[find_location,xx] = find(Elem_Type(find_element,:) ==1);
							ref_elem = find_element(find_location);
						end
					end
					ref_elem_2=ref_elem;
				end

				% Coordinates of the 2 intersections(A,B) of the main crack segment and these 4 element(fully cracked) lines
				% and the coordinates of the tip.
				% Coors_Element_Crack(47,:)
				% Coors_Element_Crack(93,:)
				Coor_AB = [Coors_Element_Crack(ref_elem,1) Coors_Element_Crack(ref_elem,2);
						   Coors_Element_Crack(ref_elem,3) Coors_Element_Crack(ref_elem,4)];
				Segment     = Coor_AB(2,:) - Coor_AB(1,:);
				% The angle of the crack tip segment.
				omega   = atan2(Segment(2),Segment(1));
				% Coordinates of the tip.
				Coor_Tip = [Coor_AB(2,1) Coor_AB(2,2)];
				% The transformation matrix from the local tip coordinates to the global coordinates. 
				Trans_Matrix = [cos(omega) sin(omega);
							   -sin(omega) cos(omega)];
				% Calculate the value(r,theta) of the gauss point in the local tip coordinates.
				xp_Gauss = Trans_Matrix*(Global_coor_Gauss-Coor_Tip)';
				r_Gauss  =    sqrt(xp_Gauss(1)^2 + xp_Gauss(2)^2);
				theta_Gauss = atan2(xp_Gauss(2),xp_Gauss(1));
				% Check theta.
				if (theta_Gauss >pi  | theta_Gauss < -pi)
					disp('    Error :: Angle is wrong when calculates r and theta!') 
					Error_Message
				end
				
				% Calculate mu of orthotropic material.
				if c_mat_type ==1   % ISO material.
					mu =[];
				elseif c_mat_type ==2 |  c_mat_type ==3
					[mu,p1,p2,q1,q2] = Cal_Orth_mu(omega,mat_num);
				end
			
				% Calculate the tip enrichment functions F and their derivative, dFdx and dFdy.
				[F_Gauss,~,~] = Cal_F_dFdx_dFdy(r_Gauss,theta_Gauss,omega,mu,c_mat_type);
				
				% Calculate the value(r,theta) of node in the local tip coordinates.
				xp_Node = Trans_Matrix*([X_NODES(iNode),Y_NODES(iNode)]-Coor_Tip)';
				r_Node  =    sqrt(xp_Node(1)^2 + xp_Node(2)^2);
				theta_Node = atan2(xp_Node(2),xp_Node(1)); 
				[F_Node,~,~] = Cal_F_dFdx_dFdy(r_Node,theta_Node,omega,mu,c_mat_type);
				
				BI_enr = [];
				% for i_F =1:4
					% Num_Enriched_Node = POS(NODES_iElem(iNode),iCrack)+i_F-1;
                    % F = F_Gauss(i_F)-F_Node(i_F);			
					% Disp_x = Disp_x + F*tem_N(iNode)*DISP(Num_Enriched_Node,2);
					% Disp_y = Disp_y + F*tem_N(iNode)*DISP(Num_Enriched_Node,3);
				% end
				
				
				% Calculate displacements for conventional crack.
				if Key_Frictional_H~=1
				    %普通裂尖增强方案
				    if Key_TipEnrich ==1
						for i_F =1:4
							% Get the number of the current enriched node.
							Num_Enriched_Node = POS(NODES_iElem(iNode),iCrack)+i_F-1;
							F = F_Gauss(i_F)-F_Node(i_F);		
							Disp_x = Disp_x + F*tem_N(iNode)*DISP(Num_Enriched_Node,2);
							Disp_y = Disp_y + F*tem_N(iNode)*DISP(Num_Enriched_Node,3);
						end
                    %裂尖增强方案2和方案3						
					elseif Key_TipEnrich ==2 || Key_TipEnrich ==3
						% Get the number of the current enriched node.
						Num_Enriched_Node = POS(NODES_iElem(iNode),iCrack);
						F = F_Gauss(1)-F_Node(1);		
						Disp_x = Disp_x + F*tem_N(iNode)*DISP(Num_Enriched_Node,2);
						Disp_y = Disp_y + F*tem_N(iNode)*DISP(Num_Enriched_Node,3);
					end	
					
				% Calculate displacements for frictional crack.	
				elseif Key_Frictional_H==1
                    gama = omega;
					for i_F =1:4
						% Get the number of the current enriched node.
						Num_Enriched_Node = POS(NODES_iElem(iNode),iCrack)+i_F-1;
						F = F_Gauss(i_F)-F_Node(i_F);		
                        % Attention:DISP(Num_Enriched_Node,3), rather than DISP(Num_Enriched_Node,2)!!!!!!						
						Disp_x = Disp_x + F*tem_N(iNode)*cos(gama)*DISP(Num_Enriched_Node,3);
						Disp_y = Disp_y + F*tem_N(iNode)*sin(gama)*DISP(Num_Enriched_Node,3);
					end
				end
				
			end
		end
	end
end
% ttt
% Loop through each crack.
if num_Hole ~=0
	for iHole=1:num_Hole									
		% Conventional element.
		if any(Enriched_Node_Type_Hl(NODES_iElem,iHole)) ==0
			Disp_x = Disp_x;
			Disp_y = Disp_y;
		% Enriched elements.
		elseif any(Enriched_Node_Type_Hl(NODES_iElem,iHole)) ~=0
            c_Hole_x = Hole_Coor(iHole,1);
            c_Hole_y = Hole_Coor(iHole,2);
            c_Hole_r = Hole_Coor(iHole,3);
			c_Dis_G = sqrt((c_G_x-c_Hole_x)^2+(c_G_y-c_Hole_y)^2);
			if c_Dis_G<=c_Hole_r 
				Hl_gp = 0.0;
			else
				Hl_gp = 1.0;
			end
			% Loop through each node.
			for iNode = 1:4
				%----------------------------------------------
				%----------- Hole enriched node ---------------
				%----------------------------------------------
				if Enriched_Node_Type_Hl(NODES_iElem(iNode),iHole) ==1       
					% Get the number of the current enriched node.
					Num_Enriched_Node = POS_Hl(NODES_iElem(iNode),iHole);
					c_Dis_N = sqrt((X_NODES(iNode)-c_Hole_x)^2+(Y_NODES(iNode)-c_Hole_y)^2);
				    if c_Dis_N<=c_Hole_r
					    Hl_i = 0.0;
				    else
					    Hl_i = 1.0;
				    end
					Disp_x = Disp_x + (Hl_gp-Hl_i)*tem_N(iNode)*DISP(Num_Enriched_Node,2);
					Disp_y = Disp_y + (Hl_gp-Hl_i)*tem_N(iNode)*DISP(Num_Enriched_Node,3);
				end
			end
		end
	end
end