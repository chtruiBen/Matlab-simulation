clear
syms theta1 theta2 theta3 phi1 phi2 phi3 u
rla = 212.7979;
rua = 172;
d2r = pi/180;
nv = [30 150 270];
n = [0, 120, 240];
u_init = [0 0 0];
w_init = [90 90 90];
v_init = [0 0 0];
theta_init =[theta1 theta2 theta3];
phi_init =[phi1 phi2 phi3];
% theta_init =[30 20 20];
AV = [54.735 54.735 54.735];
Au = 180-54.735;
Aw = -75;
Av = -75;
Qr = input('angle:');
thetaZ = Qr(1);thetaY = Qr(2);
q = eul2quat([thetaZ ,thetaY ,0]*d2r,"ZYX");
qw = q(1);qx = q(2);qy = q(3);qz = q(4);
Qz = [qw^2+qx^2-qy^2-qz^2, 2*qx*qy+2*qw*qz, 2*qx*qz-2*qw*qy; 
           2*qx*qy-2*qw*qz, qw^2-qx^2+qy^2-qz^2, 2*qy*qz+2*qw*qx;
           2*qx*qz+2*qw*qy, 2*qy*qz-2*qw*qx,qw^2-qx^2-qy^2+qz^2;
           ];
Q = [qw^2+qx^2-qy^2-qz^2, 2*qx*qy-2*qw*qz, 2*qx*qz+2*qw*qy;
           2*qx*qy+2*qw*qz, qw^2-qx^2+qy^2-qz^2, 2*qy*qz-2*qw*qx;
           2*qx*qz-2*qw*qy, 2*qy*qz+2*qw*qx,qw^2-qx^2-qy^2+qz^2;
           ];

for j = 1:3
RZU{1,j}= [cosd(n(j)), -sind(n(j)), 0; 
            sind(n(j)), cosd(n(j)), 0;
            0, 0, 1];
RYU{1,j}= [cosd(Au),0,sind(Au);
                0,1,0;
                -sind(Au),0,cosd(Au)];
RZUinit{1,j}= [cosd(u_init(j)), -sind(u_init(j)), 0; 
            sind(u_init(j)), cosd(u_init(j)), 0;
            0, 0, 1];

U{1,j} = RZU{1,j}*RYU{1,j}*RZUinit{1,j};

Rut{1,j} = [cosd(theta_init (j)), -sind(theta_init (j)),0; 
            sind(theta_init (j)), cosd(theta_init (j)), 0;
            0, 0, 1];
RXW{1,j} = [1,0 ,0;
               0,cosd(Aw),-sind(Aw);
               0,sind(Aw),cosd(Aw)];
RZWinit{1,j}= [cosd(w_init(j)), -sind(w_init(j)), 0; 
            sind(w_init(j)), cosd(w_init(j)), 0;
            0, 0, 1];
W{1,j} = RXW{1,j}*RZWinit{1,j};
W{1,j} = double(W{1,j});
Rwt{1,j} = [cosd(phi_init(j)), -sind(phi_init(j)),0; 
            sind(phi_init(j)), cosd(phi_init(j)), 0;
            0, 0, 1];
RXV{1,j} = [1,0 ,0;
               0,cosd(Av),-sind(Av);
               0,sind(Av),cosd(Av)];
RZVinit{1,j}= [cosd(v_init(j)), -sind(v_init(j)), 0; 
            sind(v_init(j)), cosd(v_init(j)), 0;
            0, 0, 1];
V{1,j} = RXV{1,j}*RZVinit{1,j};
% V{1,j} = double(V{1,j});
end
U1 = U{1,1};
U2 = U{1,2};
U3 = U{1,3};
W1 =W{1,1};
W2 = W{1,2};
W3 = W{1,3};
V1 =V{1,1};
V2 = V{1,2};
V3 = V{1,3};

for j=1:3
RZv{1,j} = [cosd(nv(j)), -sind(nv(j)), 0; 
            sind(nv(j)), cosd(nv(j)), 0;
            0, 0, 1];
RYv{1,j}  = [cosd(AV(j)),0,sind(AV(j));
                0,1,0;
                -sind(AV(j)),0,cosd(AV(j))];
v{1,j}  = RZv{1,j} * RYv{1,j} ;
vr{1,j}  = Q*v{1,j} ;
vrz{1,j}  = vr{1,j}(1:3,3);
vry{1,j}  = vr{1,j}(1:3,2);
Wr{1,j} =U{1,j}*Rut{1,j}*W{1,j};

Wrz{1,j}  = Wr{1,j}(1:3,3);
dwv{1,j} = dot(vrz{1,j},Wrz{1,j});
dwv{1,j}= subs(dwv{1,j},sin((pi*theta_init(j)/180)),(2*u)/(1+u^2));
dwv{1,j}= subs(dwv{1,j},cos((pi*theta_init(j)/180)),(1-u^2)/(1+u^2));
dwv{1,j} = vpa(simplify(dwv{1,j}*(1+u^2)),5);
dwv{1,j} = simplify(dwv{1,j});
dwv{1,j} = dwv{1,j}-cosd(75);
[UU{1,j},uu{1,j}]  = coeffs(dwv{1,j},u);
A{1,j} = UU{1,j}(1,1);
B{1,j} = UU{1,j}(1,2);
C{1,j} = UU{1,j}(1,3);
uu{1,j} = [A{1,j} B{1,j} C{1,j}];
ut{1,j} =roots(uu{1,j});
theta{1,j}= double(vpa(atan(ut{1,j})*2/d2r,5));

Vr{1,j} = Wr{1,j}*V{1,j};
Vr11{1,j} = vpa(subs(Vr{1,j},theta_init(j),theta{1,j}(1,1)),3);
Vr21{1,j} = vpa(subs(Vr{1,j},theta_init(j),theta{1,j}(2,1)),3);
Vrz11{1,j} =Vr11{1,j}(1:3,3);
Vrz21{1,j} =Vr21{1,j}(1:3,3);
dVv11{1,j} = dot(Vrz11{1,j},vrz{1,j});
dVv21{1,j} = dot(Vrz21{1,j},vrz{1,j});
phi11{1,j} = double(vpa(acos(dVv11{1,j})/d2r,3));
phi21{1,j} = double(vpa(acos(dVv21{1,j})/d2r,3));
end

for j =1:3
dUv{1,j} = double(dot(U{1,j}(1:3,3),vrz{1,j}));
auv{1,j} =  acosd(dUv{1,j});
varc11{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
duvr11{1,j} = double(dot(varc11{1,j}(1:3,3),U{1,j}(1:3,3)));
varc12{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
duvr12{1,j} = double(dot(varc12{1,j}(1:3,3),U{1,j}(1:3,3)));
varc21{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
duvr21{1,j} = double(dot(varc21{1,j}(1:3,3),U{1,j}(1:3,3)));
varc22{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
duvr22{1,j} = double(dot(varc22{1,j}(1:3,3),U{1,j}(1:3,3)));

varc11_{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
duvr11_{1,j} = double(dot(varc11_{1,j}(1:3,3),U{1,j}(1:3,3)));
varc12_{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
duvr12_{1,j} = double(dot(varc12_{1,j}(1:3,3),U{1,j}(1:3,3)));
varc21_{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
duvr21_{1,j} = double(dot(varc21_{1,j}(1:3,3),U{1,j}(1:3,3)));
varc22_{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(-phi21{1,j},'deg')*V{1,j};
duvr22_{1,j} = double(dot(varc22_{1,j}(1:3,3),U{1,j}(1:3,3)));

end

for j = 1:3
varc11{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
dvy11{1,j} = double(dot(varc11{1,j}(1:3,2),vry{1,j}));
varc12{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi21{1,j},'deg')*V{1,j};
dvy12{1,j} = double(dot(varc12{1,j}(1:3,2),vry{1,j}));
varc21{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
dvy21{1,j} = double(dot(varc21{1,j}(1:3,2),vry{1,j}));
varc22{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(phi21{1,j},'deg')*V{1,j};
dvy22{1,j} = double(dot(varc22{1,j}(1:3,2),vry{1,j}));

varc11_{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(-phi11{1,j},'deg')*V{1,j};
dvy11_{1,j} = double(dot(varc11_{1,j}(1:3,2),vry{1,j}));
varc12_{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(-phi21{1,j},'deg')*V{1,j};
dvy12_{1,j} = double(dot(varc12_{1,j}(1:3,2),vry{1,j}));
varc21_{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(-phi11{1,j},'deg')*V{1,j};
dvy21_{1,j} = double(dot(varc21_{1,j}(1:3,2),vry{1,j}));
varc22_{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(-phi21{1,j},'deg')*V{1,j};
dvy22_{1,j} = double(dot(varc22_{1,j}(1:3,2),vry{1,j}));
end

for j = 1:3
varc11{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
dvz11{1,j} = double(dot(varc11{1,j}(1:3,3),vrz{1,j}));
varc12{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(phi21{1,j},'deg')*V{1,j};
dvz12{1,j} = double(dot(varc12{1,j}(1:3,3),vrz{1,j}));
varc21{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(phi11{1,j},'deg')*V{1,j};
dvz21{1,j} = double(dot(varc21{1,j}(1:3,3),vrz{1,j}));
varc22{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(phi21{1,j},'deg')*V{1,j};
dvz22{1,j} = double(dot(varc22{1,j}(1:3,3),vrz{1,j}));

varc11_{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(-phi11{1,j},'deg')*V{1,j};
dvz11_{1,j} = double(dot(varc11_{1,j}(1:3,3),vrz{1,j}));
varc12_{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(-phi21{1,j},'deg')*V{1,j};
dvz12_{1,j} = double(dot(varc12_{1,j}(1:3,3),vrz{1,j}));
varc21_{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(-phi11{1,j},'deg')*V{1,j};
dvz21_{1,j} = double(dot(varc21_{1,j}(1:3,3),vrz{1,j}));
varc22_{1,j} = U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(-phi21{1,j},'deg')*V{1,j};
dvz22_{1,j} = double(dot(varc22_{1,j}(1:3,3),vrz{1,j}));
end
dvvyt1 =[dvy11{1,1:3};dvy12{1,1:3};dvy11_{1,1:3};dvy12_{1,1:3}];
dvvyt2 =[dvy21{1,1:3};dvy22{1,1:3};dvy21_{1,1:3};dvy22_{1,1:3}];
dvvy = [dvvyt1;dvvyt2];
m =min(dvvy);
[mx,my] = find(m==dvvy);

dvvzt1 =[dvz11{1,1:3};dvz12{1,1:3};dvz11_{1,1:3};dvz12_{1,1:3}];
dvvzt2 =[dvz21{1,1:3};dvz22{1,1:3};dvz21_{1,1:3};dvz22_{1,1:3}];
dvvz = [dvvzt1;dvvzt2];
m =max(dvvz);
[mx,my] = find(m==dvvz);
% uw = []
varc1 = U{1,1}*rotz(theta{1,1}(2,1),"deg")*W{1,1}*rotz(-phi21{1,1},'deg')*V{1,1};
varc2 = U{1,2}*rotz(theta{1,2}(2,1),"deg")*W{1,2}*rotz(-phi21{1,2},"deg")*V{1,2};
varc3 = U{1,3}*rotz(theta{1,3}(2,1),"deg")*W{1,3}*rotz(-phi21{1,3},"deg")*V{1,3};

vr1 = vr{1,1} ;
vr2 = vr{1,2};
vr3 = vr{1,3};
wr1 = Wr{1,1};
Vr1 = double(Vr21{1,1});
Vr2 = double(Vr11{1,2});

aut = [theta{1,1}(1,1),theta{1,2}(1,1),theta{1,3}(1,1);
            theta{1,1}(2,1),theta{1,2}(2,1),theta{1,3}(2,1)];
awt = [phi11{1,1},phi11{1,2},phi11{1,3};
              phi21{1,1},phi21{1,2},phi21{1,3}];
auw1 = [theta{1,1}(1,1),phi11{1,1};
              theta{1,1}(1,1),phi21{1,1};
              theta{1,1}(1,1),-phi11{1,1};
              theta{1,1}(1,1),-phi21{1,1};
              theta{1,1}(2,1),phi11{1,1};
              theta{1,1}(2,1),phi21{1,1};
              theta{1,1}(2,1),-phi11{1,1};
              theta{1,1}(2,1),-phi21{1,1}];
auw2 = [theta{1,2}(1,1),phi11{1,2};
              theta{1,2}(1,1),phi21{1,2};
              theta{1,2}(1,1),-phi11{1,2};
              theta{1,2}(1,1),-phi21{1,2};
              theta{1,2}(2,1),phi11{1,2};
              theta{1,2}(2,1),phi21{1,2};
              theta{1,2}(2,1),-phi11{1,2};
              theta{1,2}(2,1),-phi21{1,2}];
auw3 = [theta{1,3}(1,1),phi11{1,3};
              theta{1,3}(1,1),phi21{1,3};
              theta{1,3}(1,1),-phi11{1,3};
              theta{1,3}(1,1),-phi21{1,3};
              theta{1,3}(2,1),phi11{1,3};
              theta{1,3}(2,1),phi21{1,3};
              theta{1,3}(2,1),-phi11{1,3};
              theta{1,3}(2,1),-phi21{1,3}];
a =180;
b = 1;
id1 =mx(1);
% id1 =1;
au1 = auw1(id1,1); aw1 = auw1(id1,2);
id2 = mx(2);
au2 = auw2(id2,1); aw2 = auw2(id2,2);
id3 = mx(3);
au3= auw3(id3,1); aw3 = auw3(id3,2);
disp('au1:' )
disp(au1)
disp('au2:' )
disp(au2)
disp('au3:')
disp(au3)
disp('aw1:')
disp(aw1)
disp('aw2:')
disp(aw2)
disp('aw3:')
disp(aw3)
% ModelName = 'spm_uvw';
ModelName = 'spm_pacer';
    set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
    set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
    set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
    set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))

    set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
    set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
    set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))

    set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
    set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
    set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
    
    set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
    set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
    set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
    
    set_param([ModelName '/Srz'],'Gain',num2str(thetaZ))
     set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
    set_param([ModelName '/SU1'],'Gain',num2str(au1))
    set_param([ModelName '/SU2'],'Gain',num2str(au2))
    set_param([ModelName '/SU3'],'Gain',num2str(au3))
    
    set_param([ModelName '/SW1'],'Gain',num2str(aw1))
    set_param([ModelName '/SW2'],'Gain',num2str(aw2))
    set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% syms theta1 theta2 theta3 phi1 phi2 phi3 persi1 persi2 persi3  u t s 
% % Q = [qw^2+qx^2-qy^2-qz^2, 2*qx*qy+2*qw*qz, 2*qx*qz-2*qw*qy, 0; 
% %            2*qx*qy-2*qw*qz, qw^2-qx^2+qy^2-qz^2, 2*qy*qz+2*qw*qx, 0;
% %            2*qx*qz+2*qw*qy, 2*qy*qz-2*qw*qx,qw^2-qx^2-qy^2+qz^2, 0;
% %            0, 0, 0, 1];
% d2r = pi/180;
% r=50;
% n = [0, 120, 240];
% nn = [210 90 330];
% Ab =-54.75* d2r;
% Ad =90* d2r;
% Aw = -90* d2r;
% Ah = (180-54.75)* d2r;
% theta_init =[theta1 theta2 theta3];
% phi_init =[phi1 phi2 phi3];
% persi_init = [persi1 persi2 persi3] ;
% thetaZ = 0;
% thetaY = 0;
% q = eul2quat([thetaZ ,thetaY ,0]*d2r,"ZYZ");
% qw = q(1);qx=q(2);qy=q(3);qz=q(4);
% 
% disp(j)
% 
% %% tbr = cell(1,3);
% for j=1:3
% RbZ= [cos(n(j)), -sin(n(j)), 0, 0; 
%             sin(n(j)), cos(n(j)), 0, 0;
%             0, 0, 1, 0;
%             0, 0, 0, 1];
% RbY= [cos(Ab),0,sin(Ab),0;
%                 0,1,0,0;
%                 -sin(Ab),0,cos(Ab),0;
%                 0,0,0,1];
% RbZz= [cosd(45), -sind(45), 0, 0; 
%             sind(45), cosd(45), 0, 0;
%             0, 0, 1, 0;
%             0, 0, 0, 1];
% Tbr = RbZ *RbY*RbZz;         
% %% Proximal to base frame tf
% Tpb = [cos(theta_init(j)), -sin(theta_init(j)), 0, 0;
%               sin(theta_init(j)), cos(theta_init(j)), 0, 0;
%               0, 0, 1, 0;
%               0, 0, 0, 1];
% %Distal to proximal frame tf 
% RdX = [1,0 ,0,0;
%                0,cos(Ad),-sin(Ad),0;
%                0,sin(Ad),cos(Ad),0;
%                0,0,0,1];
% RdZ= [cos(phi_init(j)), -sin(phi_init(j)), 0, 0; 
%             sin(phi_init(j)), cos(phi_init(j)), 0, 0;
%             0, 0, 1, 0;
%             0, 0, 0, 1];
% Tdp = RdX*RdZ;
% %Wristal to distal frame tf
% RwX = [1,0 ,0,0;
%                0,cos(Aw),-sin(Aw),0;
%                0,sin(Aw),cos(Aw),0;
%                0,0,0,1];
% RwY= [cos(Aw),0,sin(Aw),0;
%                 0,1,0,0;
%                 -sin(Aw),0,cos(Aw),0;
%                 0,0,0,1];
% RwZz= [cosd(-45), -sind(-45), 0, 0; 
%             sind(-45), cosd(-45), 0, 0;
%             0, 0, 1, 0;
%             0, 0, 0, 1];
% RwZ = [cos(persi_init(j)), -sin(persi_init(j)), 0, 0; 
%               sin(persi_init(j)), cos(persi_init(j)), 0, 0;
%               0, 0, 1, 0;
%               0, 0, 0, 1];
% Twd =  RwX*RwY*RwZz*RwZ;
% 
% %Tool frame 
% RhY= [cos(Ah),0,sin(Ah),0;
%                 0,1,0,0;
%                 -sin(Ah),0,cos(Ah),0;
%                 0,0,0,1];
% RhZ= [cosd(90), -sind(90), 0, 0; 
%             sind(90), cos(90), 0, 0;
%             0, 0, 1, 0;
%             0, 0, 0, 1];
% Thw = RhY*RhZ;
% Tth = [cos(nn(j)), -sin(nn(j)), 0, 0;
%              sin(nn(j)), cos(nn(j)), 0, 0;
%              0, 0, 1, 0;
%              0, 0, 0, 1];
% tbr{1,j} = Tbr;
% tpb{1,j} = Tpb;
% tdp{1,j} = Tdp;
% twd{1,j} = Twd;
% thw{1,j} = Thw;
% tth{1,j} = Tth;
% %%
% % Forward mapping
% 
% Tpr = Tbr*Tpb;
% Tdr = Tpr*Tdp;
% Twr = Tdr*Twd;
% Thr = Twr*Thw;
% Ttr = Thr*Tth;
% Ttw = Thw * Tth;%
% Ttd = Twd*Thw*Tth;
% 
% Ttrt = Q;
% 
% tpr{1,j} = tbr{1,j} * tpb{1,j} ;
% tdr{1,j} = tpr{1,j} * tdp{1,j} ;
% twr{1,j} = tdr{1,j} * twd{1,j} ;
% thr{1,j} = twr{1,j} * thw{1,j} ;
% ttr{1,j} = thr{1,j} * tth{1,j} ;
% ttw{1,j} = thw{1,j} * tth{1,j};
% 
% Zwr = vpa(reshape(Twr(1:3,3),1,3),3); 
% Zdr = vpa(reshape(Tdr(1:3,3),1,3),3); 
% zbr{1,j} = vpa(reshape(tbr{1,j}(1:3,3),1,3),3);
% zwr{1,j} = vpa(reshape(twr{1,j}(1:3,3),1,3),3);
% zdr{1,j} = vpa(reshape(tdr{1,j}(1:3,3),1,3),3);
% ztr{1,j} = vpa(reshape(ttr{1,j}(1:3,3),1,3),3);
% %%
% % Backward Mapping 
% Twt = inv(Ttw);
% Tdt = inv(Ttd);
% Twrt = Ttrt * Twt;
% Tdrt = Ttrt * Tdt;
% 
% twt{1,j} = Twt;
% tdt{1,j} = Tdt;
% twrt{1,j} = Twrt;
% tdrt{1,j} = Tdrt;
% zwrt{1,j} = vpa(reshape(twrt{1,j}(1:3,3),1,3),3);
% 
% SD{1,j}=dot(zdr{1,j},zwr{1,j});
% d{1,j}=SD{1,j};
% SD{1,j}=expand(SD{1,j});
% SD{1,j}= subs(SD{1,j},sin(conj(theta_init(j))),(2*u)/(1+u^2));
% SD{1,j}= subs(SD{1,j},cos(conj(theta_init(j))),(1-u^2)/(1+u^2));
% SD{1,j} = SD{1,j} *(u^2 + 1);
% CD{1,j} = collect(SD{1,j}, u);
% % disp(CD{1,j})
% [U{1,j},uu{1,j}]  = coeffs(CD{1,j},u);
% % q = eul2quat([30 ,30 ,0]*d2r,"ZYZ");
% 
% A{1,j} = U{1,j}(1,1);
% B{1,j} = U{1,j}(1,2);
% C{1,j} = U{1,j}(1,3);
% tu{1,j} = [A{1,j} B{1,j} C{1,j}];
% ur{1,j} =roots(tu{1,j});
% theta{1,j}= vpa(atan(ur{1,j})*2/d2r,3);
% 
% end