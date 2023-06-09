clear
spm_ch_360 = load('spmch360.mat');
spm_ch_360 = struct2cell(spm_ch_360);
sizech360= size(spm_ch_360{1,1});
spm_rch_360_array =[];
spm_lch_360_array =[];
for j =2:sizech360(2)-1
% spm_360_array =[spm_360_array;cat(1,spm_360{1,1}{1,j},spm_360{1,1}{1,j+1})];
spm_rch_360_array =[spm_rch_360_array;cat(1,spm_ch_360{1,1}{1,j},spm_ch_360{1,1}{1,j+1})];
spm_lch_360_array =[spm_lch_360_array;cat(1,spm_ch_360{1,1}{2,j},spm_ch_360{1,1}{2,j+1})];
end
spm_ch_360_array =[spm_rch_360_array;spm_lch_360_array];

spm_ncv_360 = load('spmncv360.mat');
spm_ncv_360 = struct2cell(spm_ncv_360);
sizencv360= size(spm_ncv_360{1,1});
spm_ncv_360_array =[];
for j =1:sizencv360(2)-1
% spm_360_array =[spm_360_array;cat(1,spm_360{1,1}{1,j},spm_360{1,1}{1,j+1})];
spm_ncv_360_array =[spm_ncv_360_array;cat(1,spm_ncv_360{1,1}{1,j},spm_ncv_360{1,1}{1,j+1})];
end

spm_cv_360 = load('spmcv360.mat');
spm_cv_360 = struct2cell(spm_cv_360);
sizecv360= size(spm_cv_360{1,1});
spm_cv_360_array =[];

for j =1:sizecv360(2)-1
% spm_360_array =[spm_360_array;cat(1,spm_360{1,1}{1,j},spm_360{1,1}{1,j+1})];
spm_cv_360_array =[spm_cv_360_array;cat(1,spm_cv_360{1,1}{1,j},spm_cv_360{1,1}{1,j+1})];

end
spm_cv_360_array =[spm_cv_360_array];
spm_c_360_array = [spm_ch_360_array;spm_cv_360_array];
% spm_360 = load('spmnch360.mat');
% spm_360 = struct2cell(spm_360);
% size360= size(spm_360{1,1});
% spm_360_array =[];
% for j =1:size360(2)-2
% % spm_360_array =[spm_360_array;cat(1,spm_360{1,1}{1,j},spm_360{1,1}{1,j+1})];
% spm_360_array =[spm_360_array;cat(1,spm_360{1,1}{2,j},spm_360{1,1}{2,j+1})];
% end

snake_spm =load('spm_nc_hr_ccw_snake.mat');
snake_spm =struct2cell(snake_spm);
sizesnake= size(snake_spm {1,1});
snake_spm_array=[];
for j =1:sizesnake(2)-1
snake_spm_array =[snake_spm_array;cat(1,snake_spm{1,1}{1,j},snake_spm{1,1}{1,j+1})];
end
% for j=1:21
% snake_spm_array =[snake_spm_array;cat(1,snake_spm_array{1,1}{1,j},snake_spm_array{1,1}{1,j+1})];
% end
workspace_spm_tri1=load('spm_nc_hr_ccw90.mat');%load('spm_nc_hr.mat');%load('pacerspm.mat');
workspace_spm_tri2=load('spmnchY105z10.mat');
workspace_spm_tri2 =struct2cell(workspace_spm_tri2);
workspace_spm_tri1 =struct2cell(workspace_spm_tri1);
w_spm = cat(2,workspace_spm_tri1,workspace_spm_tri2);
sizecell = size(workspace_spm_tri1{1,1});
sizecell2 = size(workspace_spm_tri2{1,1});
workspace_spm_1 =[];
workspace_spm_2  =[];
for j=3:sizecell(2)-1
workspace_spm_1 =[workspace_spm_1;cat(1,workspace_spm_tri1{1,1}{1,j},workspace_spm_tri1{1,1}{1,j+1})];
end
for j=3:sizecell2(2)-1
workspace_spm_2=[workspace_spm_2;cat(1,workspace_spm_tri2{1,1}{1,j},workspace_spm_tri2{1,1}{1,j+1})];
end
% workspace_spm_tri = spm_360_array;%workspace_spm_1;
workspace_spm_c_tri = spm_c_360_array;
%%
% workspace_spm_tri1 = cell2mat(struct2cell(workspace_spm_tri1));
% workspace_spm_nc = [workspace_spm_tri(:,2),workspace_spm_tri(:,3),workspace_spm_tri(:,4)];

workspace_tbspm_motor_y115 = find((spm_c_360_array(:,5)>110));
spm_c_360_array = workspace_spm_c_tri(workspace_tbspm_motor_y115,:);
workspace_tbspm_motor_y115_135=find((spm_c_360_array(:,5)<140));
spm_c_360_array = spm_c_360_array(workspace_tbspm_motor_y115_135,:);
workspace_tbspm_motor_1=find((spm_c_360_array(:,6)<20)&(spm_c_360_array(:,6)>-20));
workspace_tbspm_motor_2=find((spm_c_360_array(:,6)<140)&(spm_c_360_array(:,6)>100));
workspace_tbspm_motor_3=find((spm_c_360_array(:,6)<260)&(spm_c_360_array(:,6)>220));
workspace_tbspm_motor = [workspace_tbspm_motor_1;workspace_tbspm_motor_2;workspace_tbspm_motor_3];
workspace_tbspm_motor = reshape(workspace_tbspm_motor,210,1);
spm_c_360_array = spm_c_360_array(workspace_tbspm_motor,:);
workspace_motor_c = [spm_c_360_array(:,2),spm_c_360_array(:,3),spm_c_360_array(:,4)];

workspace_spm_c = [workspace_spm_c_tri(:,2),workspace_spm_c_tri(:,3),workspace_spm_c_tri(:,4)];
% workspace_spm_tri1 = transpose(workspace_spm_nc);
% workspace_spm_tri2 = rotz(120,"deg")*workspace_spm_tri1;
% workspace_spm_tri3 = rotz(240,"deg")*workspace_spm_tri1;
% workspace_spm_tri =cat(2,workspace_spm_tri1,workspace_spm_tri2);
% workspace_spm_tri =cat(2,workspace_spm_tri,workspace_spm_tri3);
% workspace_spm_tri =transpose(workspace_spm_tri );
% 
pacer_mm(:,:) = [workspace_motor_c(:,1),workspace_motor_c(:,2),workspace_motor_c(:,3)]*1000;
pacer_mm_c(:,:) = [workspace_spm_c(:,1),workspace_spm_c(:,2),workspace_spm_c(:,3)]*1000;
spmpoints = array2table(pacer_mm) ;
spmcpoints = array2table(pacer_mm_c) ;
spmcpoints.Properties.VariableNames{1} = 'X';
spmcpoints.Properties.VariableNames{2} = 'Y';
spmcpoints.Properties.VariableNames{3} = 'Z';

spmpoints.Properties.VariableNames{1} = 'X';
spmpoints.Properties.VariableNames{2} = 'Y';
spmpoints.Properties.VariableNames{3} = 'Z';
figure
% spm =scatter3(spmpoints,"X","Y","Z",'Marker','.');

spm =scatter3(spmpoints,"X","Y","Z",'Marker','.');
spm.SizeData = 200;
spm.CData = [1 0 0];
% caxis([-72 -70])
% scolor = [0 0.9 0.3 
%     0.1 0 0.6];
% colormap(scolor)
% 
% colorbar
hold on
spmc =scatter3(spmcpoints,"X","Y","Z",'Marker','.');
spmc.SizeData = 20;
spmc.CData = [0 1 0];
hold on
plot3([0;100],[0;0],[0;0],'-','LineWidth',3,'Color','r');
hold on
plot3([0;0],[0;100],[0;0],'-','LineWidth',3,'Color','g');
hold on
plot3([0;0],[0;0],[0;100],'-','LineWidth',3,'Color','b');
grid on
hold off

rot=load('pacerspm.mat');
rot=cell2mat(struct2cell(rot));

r = zeros(949,1)+212;
polar(:,:)=[rot(:,5),rot(:,4),r(:,:)];
rmax=find(rot(:,4)==104);
% figure
% plot3(pacer_mm(:,1),pacer_mm(:,2),pacer_mm(:,3),'.');
% xlabel('x','fontsize',18)
% ylabel('y','fontsize',18)
% zlabel('z','fontsize',18)
% colorbar
% hold on
% plot3([0;100],[0;0],[0;0],'-','LineWidth',3,'Color','r');
% hold on
% plot3([0;0],[0;100],[0;0],'-','LineWidth',3,'Color','g');
% hold on
% plot3([0;0],[0;0],[0;100],'-','LineWidth',3,'Color','b');
% grid on
% hold off 
% 
% workspace_spm_tri1 =transpose(workspace_spm_tri1);
% figure
% pacer_mm1(:,:) = [workspace_spm_tri1(:,1),workspace_spm_tri1(:,2),workspace_spm_tri1(:,3)]*1000;
% plot3(pacer_mm1(:,1),pacer_mm1(:,2),pacer_mm1(:,3),'.');
% xlabel('x','fontsize',18)
% ylabel('y','fontsize',18)
% zlabel('z','fontsize',18)
% hold on
% plot3([0;100],[0;0],[0;0],'-','LineWidth',3,'Color','r');
% hold on
% plot3([0;0],[0;100],[0;0],'-','LineWidth',3,'Color','g');
% hold on
% plot3([0;0],[0;0],[0;100],'-','LineWidth',3,'Color','b');
% grid on
% 
% 
% workspace_spm_tri2 =transpose(workspace_spm_tri2);
%  
% pacer_mm2(:,:) = [workspace_spm_tri2(:,1),workspace_spm_tri2(:,2),workspace_spm_tri2(:,3)]*1000;
% plot3(pacer_mm2(:,1),pacer_mm2(:,2),pacer_mm2(:,3),'.','Color','g');
% xlabel('x','fontsize',18)
% ylabel('y','fontsize',18)
% zlabel('z','fontsize',18)
% hold on
% plot3([0;100],[0;0],[0;0],'-','LineWidth',3,'Color','r');
% hold on
% plot3([0;0],[0;100],[0;0],'-','LineWidth',3,'Color','g');
% hold on
% plot3([0;0],[0;0],[0;100],'-','LineWidth',3,'Color','b');
% grid on
% 
% 
% workspace_spm_tri3 =transpose(workspace_spm_tri3);
% 
% pacer_mm3(:,:) = [workspace_spm_tri3(:,1),workspace_spm_tri3(:,2),workspace_spm_tri3(:,3)]*1000;
% plot3(pacer_mm3(:,1),pacer_mm3(:,2),pacer_mm3(:,3),'.','Color','r');
% xlabel('x','fontsize',18)
% ylabel('y','fontsize',18)
% zlabel('z','fontsize',18)
% hold on
% plot3([0;100],[0;0],[0;0],'-','LineWidth',3,'Color','r');
% hold on
% plot3([0;0],[0;100],[0;0],'-','LineWidth',3,'Color','g');
% hold on
% plot3([0;0],[0;0],[0;100],'-','LineWidth',3,'Color','b');
% grid on
% hold off 
% [theta,rho,z]= cart2pol(pacer_mm(:,2),pacer_mm(:,1),pacer_mm(:,3));
% pacer_polar(:,:) = [theta(:,:),rho(:,:),z(:,:)];
% 
% figure
% polarplot(pacer_polar(:,1),pacer_polar(:,2))
% figure
% polarscatter(pacer_polar(:,1),pacer_polar(:,2),".")
% figure
% polarscatter(polar(:,1),polar(:,2),".")
% % figure
% % plot3([zeros(1605,1);pacer_mm(:,1)],[zeros(1605,1);pacer_mm(:,2)],[zeros(1605,1);pacer_mm(:,3)],'-b', 'LineWidth', 1);
% % figure
% % quiver3(zeros(1605,1),zeros(1605,1),zeros(1605,1),pacer_mm(:,1),pacer_mm(:,2),pacer_mm(:,3),'-b', 'LineWidth', 1);
% % figure
% plot3([zeros(1605,1);pacer_mm(1:200,1)],[zeros(1605,1);pacer_mm(1:200,2)],[zeros(1605,1);pacer_mm(1:200,3)],'-b', 'LineWidth', 1);