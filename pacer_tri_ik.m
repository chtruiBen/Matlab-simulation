function [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,detJq,detJx] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3)
syms theta1 theta2 theta3 phi1 phi2 phi3 u
rla = 212.8;
rua = 172;
d2r = pi/180;
nv = [0 120 240];
n = [0, 120, 240];
u_init = [90 90 90];
w_init = [-180 -180 -180];
v_init = [0 0 0];
theta_init =[theta1 theta2 theta3];
phi_init =[phi1 phi2 phi3];

AV = [54.7356 54.7356 54.7356];
Au = 180-54.7356;
Aw = -75;
Av = -75;
% Qr = input('angle:');
thetaZ = QZ ;thetaY = QY;thetaz = Qz ;
dir1 =dir1;
q = eul2quat([thetaZ ,thetaY ,thetaz ]*d2r,"ZYZ");
qw = q(1);qx = q(2);qy = q(3);qz = q(4);
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
w{1,j} = U{1,j}*W{1,j};
Wrz{1,j}  = Wr{1,j}(1:3,3);
dwv{1,j} = dot(vrz{1,j},Wrz{1,j})-cosd(75);
dwv{1,j}= subs(dwv{1,j},sin((pi*theta_init(j)/180)),(2*u)/(1+u^2));
dwv{1,j}= subs(dwv{1,j},cos((pi*theta_init(j)/180)),(1-u^2)/(1+u^2));
dwv{1,j} = vpa(simplify(dwv{1,j}*(1+u^2)),5);
dwv{1,j} = simplify(dwv{1,j});
% dwv{1,j} = dwv{1,j}-cosd(75);
[UU{1,j},uu{1,j}]  = coeffs(dwv{1,j},u);
end

for j=1:3
if uu{1,j}(1,2)==1
A{1,j} = UU{1,j}(1,1);
B{1,j} = 0;
C{1,j} = UU{1,j}(1,2);
else
A{1,j} = UU{1,j}(1,1);
B{1,j} = UU{1,j}(1,2);
C{1,j} = UU{1,j}(1,3);
end

uu{1,j} = [A{1,j} B{1,j} C{1,j}];
ut{1,j} =roots(uu{1,j});
theta{1,j}= double(vpa(atan(ut{1,j})*2/d2r,5));
D{1,j} = double(vpa(B{1,j}*B{1,j}-4*A{1,j}*C{1,j},3));
end
D = [D{1,1},D{1,2},D{1,3}];
Dcheck = isempty(find(D<0));
fprintf('discriminant check:%d\n',Dcheck)
if Dcheck ==0
     thetaz =  thetaz -10;
     disp('------theta is not real---------')
     detJq = Dcheck;
     detJx = Dcheck;
     au1 = 0;au2=0;au3=0;
     aw1=0;aw2=0;aw3=0;
     vr1 = vr{1,1} ;
     vr2 = vr{1,2};
     vr3 = vr{1,3};
     return 
%      error('输入不符合要求')
end
for j=1:3
wja{1,j}= U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j};
wjb{1,j}= U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j};
vja{1,j}= U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*V{1,j};
vjb{1,j}= U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*V{1,j};

dvjvra{1,j} = dot(vja{1,j}(1:3,3),vrz{1,j});
dvjvrb{1,j} = dot(vjb{1,j}(1:3,3),vrz{1,j});
aphi_a{1,j} = acosd(dvjvra{1,j});
aphi_b{1,j} = acosd(dvjvrb{1,j});
Bphi_a{1,j} = acosd(tand(aphi_a{1,j}/2)*tand(90+Aw));
Bphi_b{1,j} = acosd(tand(aphi_b{1,j}/2)*tand(90+Aw));
Aphi_a{1,j} = acosd(cosd(aphi_a{1,j}/2)*sind(Bphi_a{1,j} ))*2;
Aphi_b{1,j} = acosd(cosd(aphi_b{1,j}/2)*sind(Bphi_b{1,j} ))*2;
end

for j = 1:3
vt1pa{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(Aphi_a{1,j} ,'deg')*V{1,j};
dvt1pa{1,j} = double(dot(vt1pa{1,j}(1:3,3),vrz{1,j}));

vt2pb{1,j}= U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(Aphi_b{1,j} ,'deg')*V{1,j};
dvt2pb{1,j} = double(dot(vt2pb{1,j}(1:3,3),vrz{1,j}));

vt1pa_{1,j} = U{1,j}*rotz(theta{1,j}(1,1),"deg")*W{1,j}*rotz(-Aphi_a{1,j} ,'deg')*V{1,j};
dvt1pa_{1,j} = double(dot(vt1pa_{1,j}(1:3,3),vrz{1,j}));

vt2pb_{1,j}= U{1,j}*rotz(theta{1,j}(2,1),"deg")*W{1,j}*rotz(-Aphi_b{1,j} ,'deg')*V{1,j};
dvt2pb_{1,j} = double(dot(vt2pb_{1,j}(1:3,3),vrz{1,j}));
end


% uw = []

vr1 = vr{1,1} ;
vr2 = vr{1,2};
vr3 = vr{1,3};
dvt1pa =[dvt1pa{1,1:3};dvt1pa_{1,1:3}];
dvt2pb =[dvt2pb{1,1:3};dvt2pb_{1,1:3}];
dvt1pa = double(dvt1pa);
dvt2pb = double(dvt2pb);
dvtp = [dvt1pa;dvt2pb];

vz1=[vt1pa{1,1}(1:3,3) vt1pa_{1,1}(1:3,3) vt2pb{1,1}(1:3,3) vt2pb_{1,1}(1:3,3)];
vz2=[vt1pa{1,2}(1:3,3) vt1pa_{1,2}(1:3,3) vt2pb{1,2}(1:3,3) vt2pb_{1,2}(1:3,3)];
vz3=[vt1pa{1,3}(1:3,3) vt1pa_{1,3}(1:3,3) vt2pb{1,3}(1:3,3) vt2pb_{1,3}(1:3,3)];

wz1 = [wja{1,1}(1:3,3) wja{1,1}(1:3,3) wjb{1,1}(1:3,3) wjb{1,1}(1:3,3)];
wz2 = [wja{1,2}(1:3,3) wja{1,2}(1:3,3) wjb{1,2}(1:3,3) wjb{1,2}(1:3,3)];
wz3 = [wja{1,3}(1:3,3) wja{1,3}(1:3,3) wjb{1,3}(1:3,3) wjb{1,3}(1:3,3)];

id_1= find(dvtp(:,1)>0.99999);
id_2= find(dvtp(:,2)>0.99999);
id_3= find(dvtp(:,3)>0.99999);

phidir1 = [cos(Aphi_a{1,1}),cos(Aphi_b{1,1})];
phidir2 = [cos(Aphi_a{1,2}),cos(Aphi_b{1,2})];
phidir3 = [cos(Aphi_a{1,3}),cos(Aphi_b{1,3})];

nuv1 = cross(vz1(1:3,id_1(1)),U{1,1}(1:3,3));
nuv2 = cross(vz2(1:3,id_2(1)),U{1,2}(1:3,3));
nuv3 = cross(vz3(1:3,id_3(1)),U{1,3}(1:3,3));

dnw1 = [dot(nuv1,wz1(1:3,id_1(1))) dot(nuv1,wz1(1:3,id_1(2)))];
dnw2 =[dot(nuv2,wz2(1:3,id_2(1))) dot(nuv2,wz2(1:3,id_2(2)))];
dnw3 =[dot(nuv3,wz3(1:3,id_2(1))) dot(nuv3,wz3(1:3,id_2(2)))];

acdnw1 = [acosd(dot(nuv1,wz1(1:3,id_1(1)))) acosd(dot(nuv1,wz1(1:3,id_1(2))))];
acdnw2 =[acosd(dot(nuv2,wz2(1:3,id_2(1)))) acosd(dot(nuv2,wz2(1:3,id_2(2))))];
acdnw3 =[acosd(dot(nuv3,wz3(1:3,id_2(1)))) acosd(dot(nuv3,wz3(1:3,id_2(2))))];
% 0303

% if dir1>0
%     id1 = find(phidir1>0);
% else 
%     id1 =find(phidir1<0);
% end
% if dir2>0
%     id2 = id_2(find(phidir2>0));
% else 
%     id2 = id_2(find(phidir2<0));
% end
% if dir3>0
%     id3 = id_3(find(phidir3>0));
% else 
%     id3 = id_3(find(phidir3<0));
% end

% if (dnw1(1)<0)&&(dnw1(2)<0)
%     if dir1>0
%        id1 = id_1(find(max(dnw1)));
%     else
%        id1 = id_1(find(min(dnw1)));
%     end
% elseif (dnw1(1)>0)&&(dnw1(2)> 0)
%      if dir1>0
%        id1 = id_1(find(max(dnw1)));
%     else
%        id1 = id_1(find(min(dnw1)));
%     end
% else
% if dir1>0
%     id1 = id_1(find(dnw1>0));
% elseif dir1<0
%     id1 = id_1(find(dnw1<0));
% else
%     id1 = id_1(1);
% end
% end
% 
% if (dnw2(1)<0)&&(dnw2(2)<0)
%     if dir2>0
%       id2 = id_2(find(max(dnw2)));
%     else
%      id2 = id_2(find(min(dnw2)));
%     end
% elseif (dnw2(1)>0)&&(dnw2(2)> 0)
%      if dir2>0
%       id2 = id_2(find(max(dnw2)));
%     else
%      id2 = id_2(find(min(dnw2)));
%     end
% else
% if dir2>0
%     id2 = id_2(find(dnw2>0));
% elseif dir2<0
%     id2 = id_2(find(dnw2<0));
% else
%     id2 = id_2(1);
% end
% end
%  disp('dir3')
% if (dnw3(1)>0)&&(dnw3(2)>0)
%      if dir3>0
%        id3 = id_3(find(max(dnw3)));
%        disp('dir3a')
%     else
%       id3 = id_3(find(min(dnw3)));
%        disp('dir3b')
%     end
% elseif (dnw3(1)<0)&&(dnw3(2)<0)
%     if dir3>0
%        id3 = id_3(find(min(dnw3)));%%not sure
%        disp('dir3c')
%     else
%       id3 = id_3(find(max(dnw3)));
%       disp('dir3d')
%     end
% else
% if dir3>0
%     id3 = id_3(find(dnw3>0));
%     disp('dir3e')
% elseif dir3<0
%     id3 = id_3(find(dnw3<0));
%     disp('dir3f')
% else
%     id3 = id_3(1);
%     disp('dir3g')
% end
% end
atp1 = [theta{1,1}(1,1),Aphi_a{1,1};
               theta{1,1}(1,1),-Aphi_a{1,1};
               theta{1,1}(2,1),Aphi_b{1,1};
               theta{1,1}(2,1),-Aphi_b{1,1}];
atp2 = [theta{1,2}(1,1),Aphi_a{1,2};
               theta{1,2}(1,1),-Aphi_a{1,2};
               theta{1,2}(2,1),Aphi_b{1,2};
               theta{1,2}(2,1),-Aphi_b{1,2}];
atp3 = [theta{1,3}(1,1),Aphi_a{1,3};
               theta{1,3}(1,1),-Aphi_a{1,3};
               theta{1,3}(2,1),Aphi_b{1,3};
               theta{1,3}(2,1),-Aphi_b{1,3}];

% if dir1>0
% id1 = id_1(1);
% end
% if dir1<0
% id1 = id_1(2);
% end
% 
% if dir2>0
% id2 = id_2(1);
% end
% if dir2<0
% id2 = id_2(2);
% end
% 
% if dir3>0
% id3 = id_3(1);
% end
% if dir3<0
% id3 = id_3(2);
% end
au1 = atp1(id_1,1); aw1 = atp1(id_1,2);
au1 = atp1(id_1,1); aw1 = atp1(id_1,2);
isn1 = find(au1<0);
isp1 = find(au1>0);
au1 = [au1(isp1) au1(isn1)+360];
if dir1 ==1
    [au1 aid1] = min(au1);
    aw1 = aw1(aid1);
elseif dir1 == -1
    [au1 aid1] = max(au1);
    aw1 = aw1(aid1);
elseif dir1 == 0
   [cau1 aid1] = max(cosd(au1));
  
    au1 = au1(aid1);
    aw1 = aw1(aid1);  
end
au2 = atp2(id_2,1); aw2 = atp2(id_2,2);
isn2 = find(au2<0);
isp2 = find(au2>0);
au2 = [au2(isp2) au2(isn2)+360];
if dir2 ==1
    [au2 aid2] = min(au2);
    aw2 = aw2(aid2);
elseif dir2 == -1
    [au2 aid2] = max(au2);
    aw2 = aw2(aid2);
elseif dir2 == 0
   [cau2 aid2] = max(cosd(au2));
  
    au2 = au2(aid2);
    aw2 = aw2(aid2);  

end

au3 = atp3(id_3,1); aw3 = atp3(id_3,2);
au3 = atp3(id_3,1); aw3 = atp3(id_3,2);
isn3 = find(au3<0);
isp3 = find(au3>0);
au3 = [au3(isp3) au3(isn3)+360];


if dir3 ==1
    [au3 aid3] = min(au3);
    aw3 = aw3(aid3);
elseif dir3 == -1
    [au3 aid3] = max(au3);
    aw3 = aw3(aid3);
elseif dir3 == 0
    [cau3 aid3] = max(cosd(au3));
  
    au3 = au3(aid3);
    aw3 = aw3(aid3);  
    
end
% if dir1 ==1
%     if (au1(1)<0)&&(au1(2)<0)
%     [au1 aid1]=min(au1,[],'ComparisonMethod','abs');
%      aw1 =aw1(aid1);
%     disp('au1a')
%     elseif (au1(1)>0)&&(au1(2)>0)
%      [au1 aid1] = max(au1);
%      aw1 =aw1(aid1);
%      disp('au1b')
%     else
%      [au1 aid1] = min(au1);
%      aw1 =aw1(aid1);
%      disp('au1c')
%     end
% elseif dir1 == -1
%     if (au1(1)<0)&&(au1(2)<0)
%     [au1 aid1]=min(au1,[],'ComparisonMethod','abs');
%     aw1 =aw1(aid1);
%     disp('au1d')
%     disp(au1)
%     else
%      [au1 aid1] = min(au1);
%      aw1 =aw1(aid1);
%     end
% end
% au2 = atp2(id_2,1); aw2 = atp2(id_2,2);
% if dir2 ==1
%     if (au2(1)<0)&&(au2(2)<0)
%     [au2 aid2]=min(au2,[],'ComparisonMethod','abs');
%      aw2 =aw2(aid2);
%     disp('au2a')
%     else
%      [au2 aid2] = max(au2);
%      aw2 =aw2(aid2);
%     end
% elseif dir2 == -1
%     if (au2(1)<0)&&(au2(2)<0)
%     [au2 aid2]=min(au2,[],'ComparisonMethod','abs');
%     aw2 =aw2(aid2);
%     disp('au2b')
%     disp(au2)
%     else
%      [au2 aid2] = min(au2);
%      aw2 =aw2(aid2);
%     end
% end
% 
% au3 = atp3(id_3,1); aw3 = atp3(id_3,2);
% if dir3 ==1
%     if (au3(1)<0)&&(au3(2)<0)
%     [au3 aid3]=min(au3,[],'ComparisonMethod','abs');
%      aw3 =aw3(aid3);
%     disp('au3a')
%     else
%      [au3 aid3] = max(au3);
%      aw3 =aw3(aid3);
%     end
% elseif dir3 == -1
%     if (au3(1)<0)&&(au3(2)<0)
%     [au3 aid3]=min(au1,[],'ComparisonMethod','abs');
%     aw3 =aw3(aid3);
%     disp('au3b')
%     disp(au3)
%     else
%      [au3 aid3] = min(au3);
%      aw3 =aw3(aid3);
%     end
% end
% vcheck1 = [vt1pa{1,1}(1:3,3) vt1pa_{1,1}(1:3,3) vt2pb{1,1}(1:3,3) vt2pb_{1,1}(1:3,3)];
% 
% vcheck2 = [vt1pa{1,2}(1:3,3) vt1pa_{1,2}(1:3,3) vt2pb{1,2}(1:3,3) vt2pb_{1,2}(1:3,3)];
% 
% vcheck3 = [vt1pa{1,3}(1:3,3) vt1pa_{1,3}(1:3,3) vt2pb{1,3}(1:3,3) vt2pb_{1,3}(1:3,3)];
% 
% v1v2 = acosd(dot(vcheck1(:,id1),vcheck2(:,id2)));
% v1v3 = acosd(dot(vcheck1(:,id1),vcheck3(:,id3)));
% v3v2 = acosd(dot(vcheck3(:,id3),vcheck2(:,id2)));
u1 = U{1,1}*rotz(au1,"deg");
u2 = U{1,2}*rotz(au2,"deg");
u3 = U{1,3}*rotz(au3,"deg");
w1 = U{1,1}*rotz(au1,"deg")*W{1,1}*rotz(aw1 ,'deg');
w2 = U{1,2}*rotz(au2,"deg")*W{1,2}*rotz(aw2 ,'deg');
w3 = U{1,2}*rotz(au3,"deg")*W{1,3}*rotz(aw3 ,'deg');
v1 = U{1,1}*rotz(au1,"deg")*W{1,1}*rotz(aw1 ,'deg')*V{1,1};
v2 = U{1,2}*rotz(au2,"deg")*W{1,2}*rotz(aw2 ,'deg')*V{1,2};
v3 = U{1,3}*rotz(au3,"deg")*W{1,3}*rotz(aw3 ,'deg')*V{1,3};
Jq = [dot(cross(u1(:,3),w1(:,3)),v1(:,3)) 0 0;0 dot(cross(u2(:,3),w2(:,3)),v2(:,3)) 0;0 0 dot(cross(u3(:,3),w3(:,3)),v3(:,3))];
Jx = [transpose(cross(w1(:,3),v1(:,3)));transpose(cross(w2(:,3),v2(:,3)));transpose(cross(w3(:,3),v3(:,3)))];
detJq = det(Jq);
detJx = det(Jx);
disp('.........det check............')
fprintf('detJQ:%f \n',detJq);
fprintf('detJX:%f \n',detJx);
% disp('au1:' )
% disp(au1)
% disp('au2:' )
% disp(au2)
% disp('au3:')
% disp(au3)
% disp('aw1:')
% disp(aw1)
% disp('aw2:')
% disp(aw2)
% disp('aw3:')
% disp(aw3)
disp('.........V vector check..........')
fprintf('QV1:%f QV2:%f QV3:%f\n',acosd(dot(vrz{1,3},vrz{1,2})),acosd(dot(vrz{1,1},vrz{1,3})),acosd(dot(vrz{1,1},vrz{1,2})))
% disp(acosd(dot(vrz{1,3},vrz{1,2})))
% disp(acosd(dot(vrz{1,1},vrz{1,3})))
% disp(acosd(dot(vrz{1,1},vrz{1,2})))
disp('.......Joints Angle...........')
fprintf('au1:%f aw1:%f\n',au1,aw1)
fprintf('au2:%f aw2:%f\n',au2,aw2)
fprintf('au3:%f aw3:%f\n',au3,aw3)
% disp('........................')
% disp('vcheck')
% disp(v1v2)
% disp(v1v3)
% disp(v3v2)



%  fprintf('phidir1: %d \n',phidir1);
%  fprintf('phidir2: %d \n',phidir2);
%   fprintf('phidir3: %d \n',phidir3);
