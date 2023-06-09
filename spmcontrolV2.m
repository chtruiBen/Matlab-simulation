ModelName = 'spm_pacer';
open_system(ModelName);
rla = 212.8;
rua = 172;
c=24;
dir1 = 1;dir2=1;dir3=1;
% 
SPMc360 = SPMc360;
SPMnc360 = SPMnc360;
for i = 60:5:300
   startloop= 0+i;
   endloop = 180-i;
   set_param(ModelName,'BlockReduction','off');
   set_param(ModelName,'StopTime','400');
   set_param(ModelName,'StartFcn','1');
   set_param(ModelName,'SimulationCommand','start');
   set_param(ModelName,'EnablePacing','on');
   c=1+c;
   %rotate along Z axis 0-180
   for deltaY = 80:5:180
       QZ = i;QY = deltaY;
       if QY < 80
        Qz = -QZ;
       elseif QY >= 80
           if (QZ>=-60)&&(QZ<0)
            dir1 = -1;dir2=0;dir3=0;
             Qz = i;
           elseif (QZ>=0)&&(QZ<60)
            dir1 = 1;dir2=0;dir3=0;
             Qz = i;
           elseif (QZ>=60)&&(QZ<120)
            dir1 = 0;dir2=-1;dir3=0;
            Qz = -120+((i/5)-24)*5;
            elseif (QZ>=120)&&(QZ<180)
            dir1 = 0;dir2=1;dir3=0;
            Qz = -120+((i/5)-24)*5;
            elseif (QZ>=180)&&(QZ<240)
            dir1 = 0;dir2=0;dir3=-1;
            Qz = -240+((i/5)-48)*5;
            elseif (QZ>=240)&&(QZ<=300)
            dir1 = 0;dir2=0;dir3=1;
            Qz = -240+((i/5)-48)*5;
           end
       end
       [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,detJq,detJx] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
       control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,QZ,QY,Qz); 
   end
   set_param(ModelName,'SimulationCommand','stop');
    pause(1)
     
    SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
    SPMcollide = out.forcedetect(:,2:10);
    r=1;
    [iscollide,id_collide] = find(SPMcollide>25);
    nocollide=SPMcollide<10;
    [nr nc] =size(nocollide);
    n=[];
    for ni= 1: nr
           a= length(find(nocollide(1,:))>0);
          if length(find(nocollide(ni,:))>0) ==9
              n = [n,ni];
            disp(n)
          end
    end
    mincollide = min(iscollide);
    
    SPMc360{r,c} = [SPMoutworkspace,SPMcollide];
     save('SPMcv360.mat','SPMc360');
    if isempty(mincollide)==1
        
        SPMnc360{r,c}=[SPMoutworkspace,SPMcollide];
         save('spmncv360.mat','SPMnc360');
    else
    SPMnc360{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
    save('spmncv360.mat','SPMnc360');
    thetancZ = -SPMoutworkspace(mincollide,16)-8;
    thetancY = SPMoutworkspace(mincollide,15);
    thetancz = SPMoutworkspace(mincollide,14);
    end
    
   
end

%% swing
c=3;
for i = 15:5:80
   startloop= 0+i;
   endloop = 180-i;
   set_param(ModelName,'BlockReduction','off');
   set_param(ModelName,'StopTime','400');
   set_param(ModelName,'StartFcn','1');
   set_param(ModelName,'SimulationCommand','start');
   set_param(ModelName,'EnablePacing','on');
   c=1+c;
   %rotate along Z axis 0-180
   for deltaz = 0:5:180
       QZ = deltaz;QY = i;
       if QY < 80
        Qz = -QZ;
       elseif QY >= 80
           if (QZ>=0)&&(QZ<120)
            dir1 = 1;dir2=0;dir3=0;
            Qz = -QZ+((deltaz/5))*10;
           elseif (QZ>=120)&&(QZ<240)
            dir1 = 0;dir2=1;dir3=0;
            Qz = -QZ+((deltaz/5)-24)*10;
            elseif (QZ>=240)&&(QZ<=360)
            dir1 = 0;dir2=0;dir3=1;
            Qz = -QZ+((deltaz/5)-48)*10;
           end
       end
       [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,detJq,detJx] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
       control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,QZ,QY,Qz); 
   end
   set_param(ModelName,'SimulationCommand','stop');
    pause(1)
     
    SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
    SPMcollide = out.forcedetect(:,2:10);
    r=1;
    [iscollide,id_collide] = find(SPMcollide>10);
    nocollide=SPMcollide<10;
    [nr nc] =size(nocollide);
    n=[];
    for ni= 1: nr
           a= length(find(nocollide(1,:))>0);
          if length(find(nocollide(ni,:))>0) ==9
              n = [n,ni];
            disp(n)
          end
    end
    mincollide = min(iscollide);
    
    SPMc360{r,c} = [SPMoutworkspace,SPMcollide];
     save('SPMch360.mat','SPMc360');
    if isempty(mincollide)==1
        
        SPMnc360{r,c}=[SPMoutworkspace,SPMcollide];
         save('spmnch360.mat','SPMnc360');
    else
    SPMnc360{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
    save('spmnch360.mat','SPMnc360');
    thetancZ = -SPMoutworkspace(mincollide,16)-8;
    thetancY = SPMoutworkspace(mincollide,15);
    thetancz = SPMoutworkspace(mincollide,14);
    end
    set_param(ModelName,'BlockReduction','off');
   set_param(ModelName,'StopTime','400');
   set_param(ModelName,'StartFcn','1');
   set_param(ModelName,'SimulationCommand','start');
   set_param(ModelName,'EnablePacing','on');
    %rotate along Z axis 180-360
   for deltaz = 180:5:360
       QZ = deltaz;QY = i;
       if QY < 80
        Qz = -QZ;
       elseif QY >= 80
           if (QZ>=0)&&(QZ<120)
            dir1 = 1;dir2=0;dir3=0;
            Qz = -QZ+((deltaz/5))*10;
           elseif (QZ>=120)&&(QZ<240)
            dir1 = 0;dir2=1;dir3=0;
            Qz = -QZ+((deltaz/5)-24)*10;
            elseif (QZ>=240)&&(QZ<=360)
            dir1 = 0;dir2=0;dir3=1;
            Qz = -QZ+((deltaz/5)-48)*10;
           end
       end
       [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,detJq,detJx] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
       control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,QZ,QY,Qz); 
   end
   set_param(ModelName,'SimulationCommand','stop');
    pause(1)
     
    SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
    SPMcollide = out.forcedetect(:,2:10);
    r=2;
    [iscollide,id_collide] = find(SPMcollide>10);
    nocollide=SPMcollide<10;
    [nr nc] =size(nocollide);
    n=[];
    for ni= 1: nr
           a= length(find(nocollide(1,:))>0);
          if length(find(nocollide(ni,:))>0) ==9
              n = [n,ni];
            disp(n)
          end
    end
    mincollide = min(iscollide);
    
    SPMc360{r,c} = [SPMoutworkspace,SPMcollide];
     save('SPMch360.mat','SPMc360');
    if isempty(mincollide)==1
        
        SPMnc360{r,c}=[SPMoutworkspace,SPMcollide];
         save('spmnch360.mat','SPMnc360');
    else
    SPMnc360{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
    save('spmnch360.mat','SPMnc360');
    thetancZ = -SPMoutworkspace(mincollide,16)-8;
    thetancY = SPMoutworkspace(mincollide,15);
    thetancz = SPMoutworkspace(mincollide,14);
    end
end
%%
% for i = 0:5:180
%    startloop= 0+i;
%    endloop = 180-i;
%    set_param(ModelName,'BlockReduction','off');
%    set_param(ModelName,'StopTime','400');
%    set_param(ModelName,'StartFcn','1');
%    set_param(ModelName,'SimulationCommand','start');
%    set_param(ModelName,'EnablePacing','on');
%    c=1+c;
%    Qz =-40;
%    for deltaY = 0:5:180
%        QZ = i;QY = 0+deltaY;
%        
%        if Dcheck ==0
%             Qz = Qz -20;
%             disp('d=0')
%        else
%            Qz = -10-QZ;
%              disp('d=1')
%        end
%        
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_360(QZ,QY,Qz,dir1,dir2,dir3);
%        if (abs(au3)<5)&&(abs(au3)>0)
%            dir3 = -dir3;
%        end
%        control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,QZ,QY,Qz);
%    end
%     set_param(ModelName,'SimulationCommand','stop');
%     pause(1)
%      
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect(:,2:10);
%     r=1;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     
%     SPMc360{r,c} = [SPMoutworkspace,SPMcollide];
%      save('SPMc360.mat','SPMc360');
%     if isempty(mincollide)==1
%         
%         SPMnc360{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_360.mat','SPMnc360');
%     else
%     SPMnc360{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_360.mat','SPMnc360');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
%     set_param(ModelName,'BlockReduction','off');
%      set_param(ModelName,'StopTime','400');
%     set_param(ModelName,'StartFcn','1');
%     set_param(ModelName,'SimulationCommand','start');
%      set_param(ModelName,'EnablePacing','on');
%      DZ=0;
%      dir1= 1 ;dir2 =1 ; dir3 =1;
%     for deltaZ = 0:5:180
%         
%        QZ = 180+deltaZ;QY = 0+i;
%        
%        if Dcheck ==0
%             Qz = 40;%85
%             DZ=5;
%             disp('---d=0---')
%             
%        else
%            Qz = 10-QZ; %-CONE-0-80
%            %Qz = QZ+10;
%            DZ=0;
%              disp('---d=1---')
%              AU = [au1,au2,au3];
%              AW = [aw1,aw2,aw3];
%              
%        end
%        if QZ ==180
%            du1 = 0;
%            du2 = 0;
%            du3 = 0;
%        else
%            du1 = au1;
%            du2 = au2;
%            du3 = au3;
%            dw1 = aw1;
%            dw2 = aw2;
%            dw3 = aw3;
%        end 
%        
% %        if QY>80
% %          dir1 =-1;dir2 =-1;dir3 =-1;
% %        else
% %          dir1 =1;dir2 =1;dir3 =1;
% %        end
% %        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_360(QZ,QY,Qz,dir1,dir2,dir3);
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(QZ,QY,Qz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 = AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 = AW(1);aw2 = AW(2);aw3 = AW(3);
%            
%             disp('---dc=0---')
%        else
%            
% %            Qz = -10-QZ;
%              disp('---dc=1---')
%        end
%        control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,QZ,QY,Qz);
%    end
%     set_param(ModelName,'SimulationCommand','stop');
%     pause(1)
%      
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect(:,2:10);
%     r=2;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     
%     SPMc360{r,c} = [SPMoutworkspace,SPMcollide];
%      save('SPMc360.mat','SPMc360');
%     if isempty(mincollide)==1
%         
%         SPMnc360{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_360.mat','SPMnc360');
%     else
%     SPMnc360{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_360.mat','SPMnc360');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
% end
% 
% %% spmchess
% c=0;
% dir1 = 1;dir2=1;dir3=1;
% 
% for i = 0:5:180
%    startloop= 0+i;
%    endloop = 180-i;
%    set_param(ModelName,'BlockReduction','off');
%   set_param(ModelName,'StopTime','400');
%   set_param(ModelName,'StartFcn','1');
%   set_param(ModelName,'SimulationCommand','start');
%   set_param(ModelName,'EnablePacing','on');
%   c=1+c;
%    thetaz =-40;
%    %to bottom
%    for deltaY = 0:5:180
%         thetaZ = startloop; thetaY = 0+deltaY;
%        fprintf('to bottom');
%        if thetaY==60
%           thetaz = thetaz+50;
%           disp('rotatez')
%        elseif thetaY>60
%            thetaz= -20;
%        end
%        if deltaY==0
%         du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         dw1 = aw1;
%         dw2 = aw2;
%         dw3 = aw3;
% %         if (dw1>-10)&&(dw1<10)
% %         dir1 =-1;
% %         
% %         end
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%        end
%         
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 =AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%             thetaz = thetaz -10;
%             disp('d=0')
%         else
%     
%              disp('d=1')
%        end
%          control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz);
% 
%          
%     end
%     set_param(ModelName,'SimulationCommand','stop');
%     pause(1)
%      
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect(:,2:10);
%     r=1;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     fprintf('iscollide: %d\n',mincollide);
%     SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
%      save('spm_c_hr_ccw_snake.mat','SPMcccwz');
%     if isempty(mincollide)==1
%         thetancZ =184;
%         SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     else
%     SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
%     set_param(ModelName,'BlockReduction','off');
%     set_param(ModelName,'StopTime','400');
%     set_param(ModelName,'StartFcn','1');
%     set_param(ModelName,'SimulationCommand','start');
%     set_param(ModelName,'EnablePacing','on');
%     %to right
%     thetaz =10;
%     for deltaZ = startloop:5:180
%         thetaY = 180-i; thetaZ = 0+deltaZ;
%         
%         fprintf('to ritght');
%         fprintf("thetaZ:%d thetaY:%d\n",thetaZ,thetaY);
%          if deltaZ==0
%          du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%         end
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 =AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%             thetaz = thetaz -10;
%             disp('d=0')
%         else
%     
%              disp('d=1')
%        end
%         control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz);
%     
%     end
%     set_param(ModelName,'SimulationCommand','stop');
%     pause(1)
% 
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect(:,2:10);
%     r=2;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     fprintf('iscollide: %d\n',mincollide);
%     SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
%      save('spm_c_hr_ccw_snake.mat_ccw','SPMcccwz');
%     if isempty(mincollide)==1
%         thetancZ =184;
%         SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     else
%     SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
%     
% 
%     set_param(ModelName,'BlockReduction','off');
%      set_param(ModelName,'StopTime','400');
%     set_param(ModelName,'StartFcn','1');
%     set_param(ModelName,'SimulationCommand','start');
%      set_param(ModelName,'EnablePacing','on');
%      thetaz=10;
%      %to top
%      for deltaY = 0:5:180
%         thetaZ = 180-i; thetaY = 180-deltaY;
%         
%         fprintf('to top')
%         if deltaY==180
%          du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%         end
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 =AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%             thetaz = thetaz -5;
%             disp('d=0')
%         else
%     
%              disp('d=1')
%        end
%             control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz);
%     end
%     set_param(ModelName,'SimulationCommand','stop');
%     pause(1)
% 
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect(:,2:10);
%     r=3;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     fprintf('iscollide: %d\n',mincollide);
%     SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
%      save('spm_c_hr_ccw_snake.mat_ccw','SPMcccwz');
%     if isempty(mincollide)==1
%         thetancZ =184;
%         SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     else
%     SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
% 
%      set_param(ModelName,'BlockReduction','off');
%      set_param(ModelName,'StopTime','400');
%      set_param(ModelName,'StartFcn','1');
%      set_param(ModelName,'SimulationCommand','start');
%      set_param(ModelName,'EnablePacing','on');
%      thetaz =10;
%      %to left
%      for deltaZ = 0:5:180
%          thetaY = 180-i;thetaZ = 180-deltaZ;
%         
%         fprintf('to left')
%         if deltaZ==180
%          du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%         end
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 =AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%             thetaz = thetaz +10;
%             disp('d=0')
%         else
%     
%              disp('d=1')
%        end
%         control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz);
%     end
%     set_param(ModelName,'SimulationCommand','stop');
%    pause(1)
% 
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect(:,2:10);
%     r=4;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     fprintf('iscollide: %d\n',mincollide);
%     SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
%      save('spm_c_hr_chess.mat','SPMcccwz');
%     if isempty(mincollide)==1
%         thetancZ =184;
%         SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_hr_chess.mat','SPMnchrccwz');
%     else
%     SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
% end
% 
% %%  SPMnchr
% thetaz=-40;
% %%spmsnake
% z= [];
% y=[];
% c=0;
% dir1 = 1;dir2=1;dir3=1;
% 
% for i = 0:5:180
%    startloop= 0+i;
%    endloop = 180-i;
%    set_param(ModelName,'BlockReduction','off');
%   set_param(ModelName,'StopTime','400');
%   set_param(ModelName,'StartFcn','1');
%   set_param(ModelName,'SimulationCommand','start');
%   set_param(ModelName,'EnablePacing','on');
%   c=1+c;
%    thetaz =10;
% 
%    for deltaY = startloop:5:endloop
%         thetaZ = startloop; thetaY = 0+deltaY;
%        fprintf('to bottom');
%        if deltaY==startloop
%          du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%         end
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 =AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%             thetaz = thetaz -10;
%             disp('d=0')
%         else
%     
%              disp('d=1')
%        end
%          control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz);
% 
%          
%     end
%     set_param(ModelName,'SimulationCommand','stop');
%     pause(1)
% 
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect{1}.Values.Data;
%     r=1;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     fprintf('iscollide: %d\n',mincollide);
%     SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
%      save('spm_c_hr_ccw_snake.mat','SPMcccwz');
%     if isempty(mincollide)==1
%         thetancZ =184;
%         SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     else
%     SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
%     set_param(ModelName,'BlockReduction','off');
%     set_param(ModelName,'StopTime','400');
%     set_param(ModelName,'StartFcn','1');
%     set_param(ModelName,'SimulationCommand','start');
%     set_param(ModelName,'EnablePacing','on');
%     for deltaZ = startloop:5:endloop
%         thetaY = endloop; thetaZ = 0+deltaZ;
%         thetaz =10;
%         fprintf('to ritght');
%         fprintf("thetaZ:%d thetaY:%d\n",thetaZ,thetaY);
%          if deltaZ==startloop
%          du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%         end
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 =AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%             thetaz = thetaz -10;
%             disp('d=0')
%         else
%     
%              disp('d=1')
%        end
%         control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz);
%     
%     end
%     set_param(ModelName,'SimulationCommand','stop');
%     pause(1)
% 
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect{1}.Values.Data;
%     r=2;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     fprintf('iscollide: %d\n',mincollide);
%     SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
%      save('spm_c_hr_ccw_snake.mat_ccw','SPMcccwz');
%     if isempty(mincollide)==1
%         thetancZ =184;
%         SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     else
%     SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
%     
% 
%     set_param(ModelName,'BlockReduction','off');
%      set_param(ModelName,'StopTime','400');
%     set_param(ModelName,'StartFcn','1');
%     set_param(ModelName,'SimulationCommand','start');
%      set_param(ModelName,'EnablePacing','on');
%      thetaz=10;
%      for deltaY = startloop:5:endloop
%         thetaZ = 180-i; thetaY = 180-deltaY;
%         
%         fprintf('to top')
%         if deltaY==endloop
%          du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%         end
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 =AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%             thetaz = thetaz +10;
%             disp('d=0')
%         else
%     
%              disp('d=1')
%        end
%             control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz);
%     end
%     set_param(ModelName,'SimulationCommand','stop');
%     pause(1)
% 
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect{1}.Values.Data;
%     r=3;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     fprintf('iscollide: %d\n',mincollide);
%     SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
%      save('spm_c_hr_ccw_snake.mat_ccw','SPMcccwz');
%     if isempty(mincollide)==1
%         thetancZ =184;
%         SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     else
%     SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
% 
%      set_param(ModelName,'BlockReduction','off');
%      set_param(ModelName,'StopTime','400');
%      set_param(ModelName,'StartFcn','1');
%      set_param(ModelName,'SimulationCommand','start');
%      set_param(ModelName,'EnablePacing','on');
%      thetaz =10;
%      for deltaZ = startloop:5:endloop
%         thetaY = startloop;thetaZ = 180-deltaZ;
%         
%         fprintf('to left')
%         if deltaZ==endloop
%          du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%         end
%        [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
%        if Dcheck ==0
%             au1 =AU(1);au2 = AU(2);au3 = AU(3);
%             aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%             thetaz = thetaz +10;
%             disp('d=0')
%         else
%     
%              disp('d=1')
%        end
%         control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz);
%     end
%     set_param(ModelName,'SimulationCommand','stop');
%    pause(1)
% 
%     SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values); 
%     SPMcollide = out.forcedetect{1}.Values.Data;
%     r=4;
%     [iscollide,id_collide] = find(SPMcollide>10);
%     nocollide=SPMcollide<10;
%     [nr nc] =size(nocollide);
%     n=[];
%     for ni= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(ni,:))>0) ==9
%               n = [n,ni];
%             disp(n)
%           end
%     end
%     mincollide = min(iscollide);
%     fprintf('iscollide: %d\n',mincollide);
%     SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
%      save('spm_c_hr_ccw_snake.mat','SPMcccwz');
%     if isempty(mincollide)==1
%         thetancZ =184;
%         SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
%          save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     else
%     SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
%     end
% end
% 
% %%
% for deltaY = 0:5:180
% set_param(ModelName,'BlockReduction','off');
% set_param(ModelName,'StopTime','400');
% set_param(ModelName,'StartFcn','1');
% set_param(ModelName,'SimulationCommand','start');
% set_param(ModelName,'EnablePacing','on');
%  thetaz =-90;
% for deltaZ=0:4:180
% 
% thetaZ =0+deltaZ;thetaY =60+deltaY;
% dir1 = 1;dir2 = 1;dir3 = 1;
% % if thetaY >62
% %     dir1 = 1;dir2 = -1;dir3 = -1;
% % end
% 
% if thetaZ==0
%     du1 = 0;
%     du2 = 0;
%     du3 = 0;
% else
%     du1 = au1;
%     du2 = au2;
%     du3 = au3;
%     AU= [au1,au2,au3];
%     AW = [aw1,aw2,aw3];
%     AQ =Q;
% end
% % if thetaZ<90
% %     thetaz =10;
% % end
% pZ = thetaZ ; pY = thetaY;pz = thetaz;
% [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
% 
% 
% if Dcheck ==0
%  au1 =AU(1);au2 = AU(2);au3 = AU(3);
%  aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
%  thetaz = thetaz +10;
%  disp('d=0')
% else
%     
%     disp('d=1')
% end
% 
%    ModelName = 'spm_pacer';
%     set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
%     set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
%     set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
%     set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))
% 
%     set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
%     set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
%     set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))
% 
%     set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
%     set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
%     set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
%     
%     set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
%     set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
%     set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
%     
%     set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
%      set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
%      set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
%     set_param([ModelName '/SU1'],'Gain',num2str(au1))
%     set_param([ModelName '/SU2'],'Gain',num2str(au2))
%     set_param([ModelName '/SU3'],'Gain',num2str(au3))
%     
%     set_param([ModelName '/SW1'],'Gain',num2str(aw1))
%     set_param([ModelName '/SW2'],'Gain',num2str(aw2))
%     set_param([ModelName '/SW3'],'Gain',num2str(aw3))
%  fprintf('theZ: %f they: %f thez:%f\n',thetaZ,thetaY, thetaz);
%  fprintf('au1: %f au2: %f au3:%f\n',au1,au2, au3);
%   fprintf('aw1: %f aw2: %f aw3:%f\n',aw1,aw2, aw3);
% %   disp('forcedetect')
%   pause(1)
%  
% end
% set_param(ModelName,'SimulationCommand','stop');
% 
% pause(1)
% 
%  j=j+1;
% disp(j)
% SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values);
% SPMcollide = out.forcedetect{1}.Values.Data;
% [iscollide,id_collide] = find(SPMcollide>10);
% nocollide=SPMcollide<10;
% [nr nc] =size(nocollide);
% n=[];
% for i= 1: nr
%            a= length(find(nocollide(1,:))>0);
%           if length(find(nocollide(i,:))>0) ==9
%               n = [n,i];
%             disp(n)
%           end
% end
% mincollide = min(iscollide);
% fprintf('iscollide: %d\n',mincollide);
% SPMcccwz90{j} = [SPMoutworkspace,SPMcollide];
%  save('spm_c_hr_ccw90.mat_ccw','SPMcccwz90');
% if isempty(mincollide)==1
%      thetancZ =184;
%      SPMnchrccwz90{j}=[SPMoutworkspace,SPMcollide];
%      save('spm_nc_hr_ccw90.mat','SPMnchrccwz90');
% else
%     SPMnchrccwz90{j}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
%     save('spm_nc_hr_ccw90.mat','SPMnchrccwz90');
%     thetancZ = -SPMoutworkspace(mincollide,16)-8;
%     thetancY = SPMoutworkspace(mincollide,15);
%     thetancz = SPMoutworkspace(mincollide,14);
% end
% end
% %  fprintf('thencZ: %d thency: %d thencz:%d\n',thetancZ,thetancY, thetancz);
% %  set_param(ModelName,'BlockReduction','off');
% % set_param(ModelName,'StopTime','400');
% % set_param(ModelName,'StartFcn','1');
% % set_param(ModelName,'SimulationCommand','start');
% % set_param(ModelName,'EnablePacing','on');
% % for deltaZ=0:4: 60
% %     thetaz = -20;
% %     thetaZ =thetancZ+deltaZ;thetaY =90+deltaY;
% %       [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3);
% %       ModelName = 'spm_pacer';
% %     set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
% %     set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
% %     set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
% %     set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))
% % 
% %     set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
% %     set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
% %     set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))
% % 
% %     set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
% %     set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
% %     set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
% %     
% %     set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
% %     set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
% %     set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
% %     
% %     set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
% %      set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
% %      set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
% %     set_param([ModelName '/SU1'],'Gain',num2str(au1))
% %     set_param([ModelName '/SU2'],'Gain',num2str(au2))
% %     set_param([ModelName '/SU3'],'Gain',num2str(au3))
% %     
% %     set_param([ModelName '/SW1'],'Gain',num2str(aw1))
% %     set_param([ModelName '/SW2'],'Gain',num2str(aw2))
% %     set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% %     fprintf('Dcheck_:%d\n',Dcheck)
% %     fprintf('theZ_: %d they_: %d thez_:%d\n',thetaZ,thetaY, thetaz);
% %     fprintf('au1: %d au2: %d au3:%d\n',au1,au2, au3);
% %     fprintf('aw1: %d aw2: %d aw3:%d\n',aw1,aw2, aw3);
% % end 
% % 
% % set_param(ModelName,'SimulationCommand','stop');
% % SPMoutworkspace_= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values);
% % SPMcollide_ = out.forcedetect{1}.Values.Data;
% 
% %%
% % for deltaZ = 0:5:180
% % set_param(ModelName,'BlockReduction','off');
% % set_param(ModelName,'StopTime','400');
% % set_param(ModelName,'StartFcn','1');
% % set_param(ModelName,'SimulationCommand','start');
% % set_param(ModelName,'EnablePacing','on');
% % 
% % thetaz=10;
% % 
% % for deltaY=0:4:180
% %  fprintf('thetancZ:%f\n',thetancZ)
% % 
% % thetaZ =-100-deltaZ;thetaY =0+deltaY;
% % 
% % % if thetaY >62
% % %     dir1 = 1;dir2 = -1;dir3 = -1;
% % % end
% % 
% % if thetaY==0
% % du1 = 0;
% % du2 = 0;
% % du3 = 0;
% % else
% % du1 = au1;
% % du2 = au2;
% % du3 = au3;
% % AU= [au1,au2,au3];
% % AW = [aw1,aw2,aw3];
% % AQ =Q;
% % end
% % if thetaY<90
% % dir1 = 1;dir2 = 1;dir3 = 1;
% % else
% %     dir1 = 1;dir2 = 1;dir3 = 1;
% %     
% % end
% % pZ = thetaZ ; pY = thetaY;pz = thetaz;
% % [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
% % 
% % 
% % if Dcheck ==0
% %  au1 =AU(1);au2 = AU(2);au3 = AU(3);
% %  aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
% %   thetaZ = thetaZ;
% %  thetaz = thetaz -20;
% %  fprintf('thetaz:%f\n',thetaz)
% % 
% %  disp('d=0')
% % else
% %     disp(au3)
% %     disp('d=1')
% % end
% %    ModelName = 'spm_pacer';
% %     set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
% %     set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
% %     set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
% %     set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))
% % 
% %     set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
% %     set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
% %     set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))
% % 
% %     set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
% %     set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
% %     set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
% %     
% %     set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
% %     set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
% %     set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
% %     
% %     set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
% %      set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
% %      set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
% %     set_param([ModelName '/SU1'],'Gain',num2str(au1))
% %     set_param([ModelName '/SU2'],'Gain',num2str(au2))
% %     set_param([ModelName '/SU3'],'Gain',num2str(au3))
% %     
% %     set_param([ModelName '/SW1'],'Gain',num2str(aw1))
% %     set_param([ModelName '/SW2'],'Gain',num2str(aw2))
% %     set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% %   
% %  fprintf('theZ: %f they: %f thez:%f\n',thetaZ,thetaY, thetaz);
% %  fprintf('au1: %f au2: %f au3:%f\n',au1,au2, au3);
% %   fprintf('aw1: %f aw2: %f aw3:%f\n',aw1,aw2, aw3);
% % %   disp('forcedetect')
% %   pause(1)
% %  
% % end
% % set_param(ModelName,'SimulationCommand','stop');
% % 
% % pause(1)
% % 
% % j=j+1;
% % disp(j)
% % SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values);
% % SPMcollide = out.forcedetect{1}.Values.Data;
% % [iscollide,id_collide] = find(SPMcollide>10);
% % nocollide=SPMcollide<10;
% % [nr nc] =size(nocollide);
% % n=[];
% % for i= 1: nr
% %            a= length(find(nocollide(1,:))>0);
% %           if length(find(nocollide(i,:))>0) ==9
% %               n = [n,i];
% %             disp(n)
% %           end
% % end
% % mincollide = min(iscollide);
% % fprintf('iscollide: %d\n',mincollide);
% % SPMczv10{j} = [SPMoutworkspace,SPMcollide];
% % 
% % if isempty(mincollide)==1
% %      thetancZ =184;
% %    
% %      SPMncvz10{j}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
% % else
% %     SPMncvz10{j}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
% %  
% %     thetancZ = -SPMoutworkspace(mincollide,16)-8;
% %     thetancY = SPMoutworkspace(mincollide,15);
% %     thetancz = SPMoutworkspace(mincollide,14);
% % end
% % %  fprintf('thencZ: %d thency: %d thencz:%d\n',thetancZ,thetancY, thetancz);
% % %  set_param(ModelName,'BlockReduction','off');
% % % set_param(ModelName,'StopTime','400');
% % % set_param(ModelName,'StartFcn','1');
% % % set_param(ModelName,'SimulationCommand','start');
% % % set_param(ModelName,'EnablePacing','on');
% % % for deltaZ=0:4: 60
% % %     thetaz = -20;
% % %     thetaZ =thetancZ+deltaZ;thetaY =90+deltaY;
% % %       [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3);
% % %       ModelName = 'spm_pacer';
% % %     set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
% % %     set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
% % %     set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
% % %     set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))
% % % 
% % %     set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
% % %     set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
% % %     set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))
% % % 
% % %     set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
% % %     set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
% % %     set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
% % %     
% % %     set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
% % %     set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
% % %     set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
% % %     
% % %     set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
% % %      set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
% % %      set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
% % %     set_param([ModelName '/SU1'],'Gain',num2str(au1))
% % %     set_param([ModelName '/SU2'],'Gain',num2str(au2))
% % %     set_param([ModelName '/SU3'],'Gain',num2str(au3))
% % %     
% % %     set_param([ModelName '/SW1'],'Gain',num2str(aw1))
% % %     set_param([ModelName '/SW2'],'Gain',num2str(aw2))
% % %     set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% % %     fprintf('Dcheck_:%d\n',Dcheck)
% % %     fprintf('theZ_: %d they_: %d thez_:%d\n',thetaZ,thetaY, thetaz);
% % %     fprintf('au1: %d au2: %d au3:%d\n',au1,au2, au3);
% % %     fprintf('aw1: %d aw2: %d aw3:%d\n',aw1,aw2, aw3);
% % % end 
% % % 
% % % set_param(ModelName,'SimulationCommand','stop');
% % % SPMoutworkspace_= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values);
% % % SPMcollide_ = out.forcedetect{1}.Values.Data;
% % end
% %%
% 
% 
% % for deltaY = 0:5:70
% % set_param(ModelName,'BlockReduction','off');
% % set_param(ModelName,'StopTime','400');
% % set_param(ModelName,'StartFcn','1');
% % set_param(ModelName,'SimulationCommand','start');
% % set_param(ModelName,'EnablePacing','on');
% % 
% % thetaz=10;
% % 
% % for deltaZ=0:4:184
% %  fprintf('thetancZ:%f\n',thetancZ)
% % 
% % thetaZ =4-deltaZ;thetaY =110+deltaY;
% % dir1 = 1;dir2 = 1;dir3 = 1;
% % % if thetaY >62
% % %     dir1 = 1;dir2 = -1;dir3 = -1;
% % % end
% % 
% % if thetaZ==4
% % du1 = 0;
% % du2 = 0;
% % du3 = 0;
% % else
% % du1 = au1;
% % du2 = au2;
% % du3 = au3;
% % AU= [au1,au2,au3];
% % AW = [aw1,aw2,aw3];
% % AQ =Q;
% % end
% % pZ = thetaZ ; pY = thetaY;pz = thetaz;
% % [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
% % 
% % 
% % if Dcheck ==0
% %  au1 =AU(1);au2 = AU(2);au3 = AU(3);
% %  aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
% %   thetaZ = thetaZ;
% %  thetaz = thetaz +20;
% %  fprintf('thetaz:%f\n',thetaz)
% % 
% %  disp('d=0')
% % else
% %     disp(au3)
% %     disp('d=1')
% % end
% %    ModelName = 'spm_pacer';
% %     set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
% %     set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
% %     set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
% %     set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))
% % 
% %     set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
% %     set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
% %     set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))
% % 
% %     set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
% %     set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
% %     set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
% %     
% %     set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
% %     set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
% %     set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
% %     
% %     set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
% %      set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
% %      set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
% %     set_param([ModelName '/SU1'],'Gain',num2str(au1))
% %     set_param([ModelName '/SU2'],'Gain',num2str(au2))
% %     set_param([ModelName '/SU3'],'Gain',num2str(au3))
% %     
% %     set_param([ModelName '/SW1'],'Gain',num2str(aw1))
% %     set_param([ModelName '/SW2'],'Gain',num2str(aw2))
% %     set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% %   
% %  fprintf('theZ: %f they: %f thez:%f\n',thetaZ,thetaY, thetaz);
% %  fprintf('au1: %f au2: %f au3:%f\n',au1,au2, au3);
% %   fprintf('aw1: %f aw2: %f aw3:%f\n',aw1,aw2, aw3);
% % %   disp('forcedetect')
% %   pause(1)
% %  
% % end
% % set_param(ModelName,'SimulationCommand','stop');
% % 
% % pause(1)
% % 
% % j=j+1;
% % disp(j)
% % SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values);
% % SPMcollide = out.forcedetect{1}.Values.Data;
% % [iscollide,id_collide] = find(SPMcollide>10);
% % nocollide=SPMcollide<10;
% % [nr nc] =size(nocollide);
% % n=[];
% % for i= 1: nr
% %            a= length(find(nocollide(1,:))>0);
% %           if length(find(nocollide(i,:))>0) ==9
% %               n = [n,i];
% %             disp(n)
% %           end
% % end
% % mincollide = min(iscollide);
% % fprintf('iscollide: %d\n',mincollide);
% % SPMcz20{j} = [SPMoutworkspace,SPMcollide];
% % 
% % if isempty(mincollide)==1
% %      thetancZ =184;
% %      SPMnch2z10{j}=[SPMoutworkspace,SPMcollide];
% % 
% % else
% %     SPMnch2z10{j}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
% %  
% %     thetancZ = -SPMoutworkspace(mincollide,16)-8;
% %     thetancY = SPMoutworkspace(mincollide,15);
% %     thetancz = SPMoutworkspace(mincollide,14);
% % end
% % %  fprintf('thencZ: %d thency: %d thencz:%d\n',thetancZ,thetancY, thetancz);
% % %  set_param(ModelName,'BlockReduction','off');
% % % set_param(ModelName,'StopTime','400');
% % % set_param(ModelName,'StartFcn','1');
% % % set_param(ModelName,'SimulationCommand','start');
% % % set_param(ModelName,'EnablePacing','on');
% % % for deltaZ=0:4: 60
% % %     thetaz = -20;
% % %     thetaZ =thetancZ+deltaZ;thetaY =90+deltaY;
% % %       [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3);
% % %       ModelName = 'spm_pacer';
% % %     set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
% % %     set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
% % %     set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
% % %     set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))
% % % 
% % %     set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
% % %     set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
% % %     set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))
% % % 
% % %     set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
% % %     set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
% % %     set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
% % %     
% % %     set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
% % %     set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
% % %     set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
% % %     
% % %     set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
% % %      set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
% % %      set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
% % %     set_param([ModelName '/SU1'],'Gain',num2str(au1))
% % %     set_param([ModelName '/SU2'],'Gain',num2str(au2))
% % %     set_param([ModelName '/SU3'],'Gain',num2str(au3))
% % %     
% % %     set_param([ModelName '/SW1'],'Gain',num2str(aw1))
% % %     set_param([ModelName '/SW2'],'Gain',num2str(aw2))
% % %     set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% % %     fprintf('Dcheck_:%d\n',Dcheck)
% % %     fprintf('theZ_: %d they_: %d thez_:%d\n',thetaZ,thetaY, thetaz);
% % %     fprintf('au1: %d au2: %d au3:%d\n',au1,au2, au3);
% % %     fprintf('aw1: %d aw2: %d aw3:%d\n',aw1,aw2, aw3);
% % % end 
% % % 
% % % set_param(ModelName,'SimulationCommand','stop');
% % % SPMoutworkspace_= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values);
% % % SPMcollide_ = out.forcedetect{1}.Values.Data;
% % end
% % 
% % %%
% % thetaz=-20;
% % for deltaY = 0:5:180
% % set_param(ModelName,'BlockReduction','off');
% % set_param(ModelName,'StopTime','400');
% % set_param(ModelName,'StartFcn','1');
% % set_param(ModelName,'SimulationCommand','start');
% % set_param(ModelName,'EnablePacing','on');
% % 
% % thetaz=-20;
% % 
% % for deltaZ=0:4: thetancZ
% %  fprintf('thetancZ:%d\n',thetancZ)
% % 
% % thetaZ =-4+deltaZ;thetaY =135+deltaY;
% % dir1 = 1;dir2 = 1;dir3 = 1;
% % % if thetaY >62
% % %     dir1 = 1;dir2 = -1;dir3 = -1;
% % % end
% % 
% % AU= [au1,au2,au3];
% % AW = [aw1,aw2,aw3];
% % AQ =Q;
% % if thetaZ==-4
% % du1 = 0;
% % du2 = 0;
% % du3 = 0;
% % else
% % du1 = au1;
% % du2 = au2;
% % du3 = au3;
% % end
% % pZ = thetaZ ; pY = thetaY;pz = thetaz;
% % [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3,du1,du2,du3);
% % 
% % 
% % if Dcheck ==0
% %  au1 =AU(1);au2 = AU(2);au3 = AU(3);
% %  aw1 =AW(1); aw2 =AW(2);aw3=AW(3);
% %   thetaZ = thetaZ;
% %  thetaz = thetaz -20;
% %  fprintf('thetaz:%d\n',thetaz)
% % 
% %  disp('d=0')
% % else
% %     disp('d=1')
% % end
% %    ModelName = 'spm_pacer';
% %     set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
% %     set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
% %     set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
% %     set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))
% % 
% %     set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
% %     set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
% %     set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))
% % 
% %     set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
% %     set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
% %     set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
% %     
% %     set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
% %     set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
% %     set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
% %     
% %     set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
% %      set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
% %      set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
% %     set_param([ModelName '/SU1'],'Gain',num2str(au1))
% %     set_param([ModelName '/SU2'],'Gain',num2str(au2))
% %     set_param([ModelName '/SU3'],'Gain',num2str(au3))
% %     
% %     set_param([ModelName '/SW1'],'Gain',num2str(aw1))
% %     set_param([ModelName '/SW2'],'Gain',num2str(aw2))
% %     set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% %   
% %  fprintf('theZ: %d they: %d thez:%d\n',thetaZ,thetaY, thetaz);
% %  fprintf('au1: %d au2: %d au3:%d\n',au1,au2, au3);
% %   fprintf('aw1: %d aw2: %d aw3:%d\n',aw1,aw2, aw3);
% % %   disp('forcedetect')
% %   pause(1)
% %  
% % end
% % set_param(ModelName,'SimulationCommand','stop');
% % 
% % pause(1)
% % 
% % j=j+1;
% % disp(j)
% % SPMoutworkspace= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values);
% % SPMcollide = out.forcedetect{1}.Values.Data;
% % [iscollide,id_collide] = find(SPMcollide>10);
% % mincollide = min(iscollide);
% % fprintf('iscollide: %d\n',mincollide);
% % SPMcz_20{j} = [SPMoutworkspace,SPMcollide];
% % 
% % if isempty(mincollide)==1
% %      thetancZ =184;
% %      SPMncz_20{j}=[SPMoutworkspace,SPMcollide];
% % else
% %     SPMncz_20{j}=[SPMoutworkspace(1:mincollide,:),SPMcollide(1:mincollide,:)];
% %  
% %     thetancZ = SPMoutworkspace(mincollide,16)+8;
% %     thetancY = SPMoutworkspace(mincollide,15);
% %     thetancz = SPMoutworkspace(mincollide,14);
% % end
% %  fprintf('thencZ: %d thency: %d thencz:%d\n',thetancZ,thetancY, thetancz);
% % %  set_param(ModelName,'BlockReduction','off');
% % % set_param(ModelName,'StopTime','400');
% % % set_param(ModelName,'StartFcn','1');
% % % set_param(ModelName,'SimulationCommand','start');
% % % set_param(ModelName,'EnablePacing','on');
% % % for deltaZ=0:4: 60
% % %     thetaz = -20;
% % %     thetaZ =thetancZ+deltaZ;thetaY =90+deltaY;
% % %       [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(thetaZ,thetaY,thetaz,dir1,dir2,dir3);
% % %       ModelName = 'spm_pacer';
% % %     set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
% % %     set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
% % %     set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
% % %     set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))
% % % 
% % %     set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
% % %     set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
% % %     set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))
% % % 
% % %     set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
% % %     set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
% % %     set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
% % %     
% % %     set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
% % %     set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
% % %     set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
% % %     
% % %     set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
% % %      set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
% % %      set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
% % %     set_param([ModelName '/SU1'],'Gain',num2str(au1))
% % %     set_param([ModelName '/SU2'],'Gain',num2str(au2))
% % %     set_param([ModelName '/SU3'],'Gain',num2str(au3))
% % %     
% % %     set_param([ModelName '/SW1'],'Gain',num2str(aw1))
% % %     set_param([ModelName '/SW2'],'Gain',num2str(aw2))
% % %     set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% % %     fprintf('Dcheck_:%d\n',Dcheck)
% % %     fprintf('theZ_: %d they_: %d thez_:%d\n',thetaZ,thetaY, thetaz);
% % %     fprintf('au1: %d au2: %d au3:%d\n',au1,au2, au3);
% % %     fprintf('aw1: %d aw2: %d aw3:%d\n',aw1,aw2, aw3);
% % % end 
% % % 
% % % set_param(ModelName,'SimulationCommand','stop');
% % % SPMoutworkspace_= cat(2,out.workspace,out.uw123,out.outthetaZ.signals.values);
% % % SPMcollide_ = out.forcedetect{1}.Values.Data;
% % end

function control(au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,thetaZ,thetaY,thetaz)
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
    
    set_param([ModelName '/SrZ'],'Gain',num2str(thetaZ))
     set_param([ModelName '/Sry'],'Gain',num2str(thetaY))
     set_param([ModelName '/Srz'],'Gain',num2str(thetaz))
    set_param([ModelName '/SU1'],'Gain',num2str(au1))
    set_param([ModelName '/SU2'],'Gain',num2str(au2))
    set_param([ModelName '/SU3'],'Gain',num2str(au3))
    
    set_param([ModelName '/SW1'],'Gain',num2str(aw1))
    set_param([ModelName '/SW2'],'Gain',num2str(aw2))
    set_param([ModelName '/SW3'],'Gain',num2str(aw3))
    disp('---Euler Rotation Angle----')
    fprintf('theZ: %f they: %f thez:%f\n',thetaZ,thetaY, thetaz);
%          fprintf('au1: %f au2: %f au3:%f\n',au1,au2, au3);
%          fprintf('aw1: %f aw2: %f aw3:%f\n',aw1,aw2, aw3);
        
        pause(1)
end


function collidedata (r,c,SPMoutworkspace,SPMcollide);
 SPMoutworkspace= SPMoutworkspace;
SPMcollide = SPMcollide;
[iscollide,id_collide] = find(SPMcollide>10);
nocollide=SPMcollide<10;
[nr nc] =size(nocollide);
n=[];
for i= 1: nr
           a= length(find(nocollide(1,:))>0);
          if length(find(nocollide(i,:))>0) ==9
              n = [n,i];
            disp(n)
          end
end
mincollide = min(iscollide);
fprintf('iscollide: %d\n',mincollide);
SPMcccwz{r,c} = [SPMoutworkspace,SPMcollide];
 save('spm_c_hr_ccw_snake.mat_ccw','SPMcccwz');
if isempty(mincollide)==1
     thetancZ =184;
     SPMnchrccwz{r,c}=[SPMoutworkspace,SPMcollide];
     save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
else
    SPMnchrccwz{r,c}=[SPMoutworkspace(n,:),SPMcollide(n,:)];
    save('spm_nc_hr_ccw_snake.mat','SPMnchrccwz');
    thetancZ = -SPMoutworkspace(mincollide,16)-8;
    thetancY = SPMoutworkspace(mincollide,15);
    thetancz = SPMoutworkspace(mincollide,14);
end
end