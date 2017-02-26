% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function [N,dNdkesi,J,detJ] = Cal_N_dNdkesi_J_detJ(kesi,yita,X_NODES,Y_NODES)
% This function calculates N, dNdkesi, J and the determinant of Jacobian matrix.
% This function is called by Stiffness_Matrix_XFEM and Cal_B_Matrix_XFEM. 



% Only calculate N if X_NODES is empty.
if isempty(X_NODES) == 1
	% Calculate N.
	N1 = (1-kesi)*(1-yita)/4;
	N2 = (1+kesi)*(1-yita)/4;
	N3 = (1+kesi)*(1+yita)/4;
	N4 = (1-kesi)*(1+yita)/4;
	N = [N1 0 N2 0 N3 0 N4 0;
		 0 N1 0 N2 0 N3 0 N4];
	dNdkesi = [];
    J=[];
    detJ=[];	
else
	% Coordinates of the element.
	Coor = [X_NODES(1),X_NODES(2),X_NODES(3),X_NODES(4);
			Y_NODES(1),Y_NODES(2),Y_NODES(3),Y_NODES(4)];
			
	% Calculate N.
	N1 = (1-kesi)*(1-yita)/4;
	N2 = (1+kesi)*(1-yita)/4;
	N3 = (1+kesi)*(1+yita)/4;
	N4 = (1-kesi)*(1+yita)/4;
	N = [N1 0 N2 0 N3 0 N4 0;
		 0 N1 0 N2 0 N3 0 N4];

	% Calculate dNdkesi.
	JM=[0,            1-yita,      yita-kesi,     kesi-1    ;...
		yita-1,       0,           1+kesi,       -kesi-yita ;...
		kesi-yita,    -kesi-1,     0,             yita+1    ;...
		1-kesi,       yita+kesi,  -yita-1,        0         ];
	dNdkesi =[(yita-1)/4,(-yita+1)/4,(yita+1)/4,(-yita-1)/4;
			  (kesi-1)/4,(-kesi-1)/4,(kesi+1)/4,(-kesi+1)/4];
	dNdkesi = dNdkesi';

	% Calculate the Jacobian matrix.
	J = Coor*dNdkesi;

	% Calculate the determinant of Jacobian matrix.
	detJ = det(J);
end

	



