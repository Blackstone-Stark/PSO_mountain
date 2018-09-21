clear all
clc
%     for o=1:4
        tic
%         for u=1:50
          %% ���ø�����ֵ
                startX=0;startY=0;                            %��ʼ����                          
                endX=700;endY=700;                            %��������
                c1=2;
                c2=2;                     %ѧϰ����
                w=0.7;  %����Ȩ��
                pop=20;               %������
                N_gen=500;
                popmax=700;
                popmin=0;              %λ�÷�Χ�����ݲ��Ժ�������
                Vmax=20;
                Vmin=-20;                 %�ٶȷ�Χ�����ݲ��Ժ�������
                gridCount=30;
                %% ����ɽ��
          threat=[304 400 0;404 320 0;440 500 0;279 310 0;560 220 0;172 527 0;....
                194 220 0;272 522 0;350 200 0;....
                 650 400 0;740 250 0;540 375 0;510 600 0];
            r=[45 50 55 10 70 65 55 25 50 30 40 40 35];

        for i=1:length(r)
              figure(1)
              [x,y,z]=sphere;
              mesh(threat(i,1)+r(i)*x,threat(i,2)+r(i)*y,abs(threat(i,3)+r(i)*z));
              hold on
        end
        view([-30,-30,70])
           %% ��ʼ������
                    for i=1:pop
                        for j=1:gridCount
                                X(i,j)=startX+j*(endX-startX)/(gridCount+1);
                                Y(i,j)=startY+rand()*(endY-startY);
                                path(i,2*j-1)=X(i,j);
                                path(i,2*j)=Y(i,j);
                        end
                    end
                     for i=1:pop
                         [distance,pathpoint,positionPoint]=verify(path(i,:),threat,....
                                         r,startX,startY,endX,endY,gridCount);
                        fitness(i)=distance;
                            V(i,:)=5*rands(1,gridCount*2);  %�ֲ����ٶȷ�Χ��
                    end
                    [bestFitness,bestindex]=min(fitness);
                    bestpath=path(bestindex,:);
                    pbest=path;  
                    T=std(fitness); 
                    BestFitness=Inf;
                    globalFitness=Inf;
                    pathRecord=zeros(1,gridCount+1); bestRecord=zeros(1,gridCount+1);
                    position=zeros(gridCount+1,2);

                %% ����ȡ��
                for i=1:N_gen
                    for j=1:pop
                        V(j,:)=w*V(j,:)+c1*rand*(pbest(j,:)-path(j,:))+c2*rand*(bestpath-path(j,:));  %���ݹ�ʽ�����ٶ�
                        V(j,find(V(j,:)>Vmax))=Vmax;  %�����ٶȴ�С
                        V(j,find(V(j,:)<Vmin))=Vmin;

                        path(j,:)=path(j,:)+V(j,:);  %���ݹ�ʽ����λ��
                        path(j,find(path(j,:)>popmax))=popmax;  %����λ�ô�С
                        path(j,find(path(j,:)<popmin))=popmin;
                           [distance,pathpoint,positionPoint]=verify(path(j,:),threat,....
                                 r,startX,startY,endX,endY,gridCount);
                             fmin=distance;
                        if fmin<fitness(j)
                            fitness(j)=fmin;  %���¸���������Ӧ��
                            pbest(j,:)=path(j,:);  %���¸�������ֵ
                        end

                        if fmin<bestFitness
                            bestFitness=fmin;  %����ȫ��������Ӧ��
                            bestpath=path(j,:);  %����ȫ������ֵ
                            pathRecord=pathpoint;  
                            position=positionPoint;
                        end 
                    end
                    Fmin(i)=bestFitness;
                end
%         end
%     end
            %% ����ʵ��ͼ
                record=[];                                                              
                count=1;
                i=gridCount+1;
                while i>1
                j=pathRecord(i);
                record(count,1)=position(i,1); record(count,2)=position(i,2);
                count=count+1;
                plot([position(i,1),position(j,1)],[position(i,2),position(j,2)],'Linewidth',2)
                axis([0,700,0,700]);
                i=j;
                end
                record(count,1)=position(i,1); record(count,2)=position(i,2);

                text(position(1,1)',position(1,2)','S');
                text(position(gridCount+1,1)',position(gridCount+1,2)','T');
                figure(2)
                plot(Fmin);
                % title(['��Ѹ�����Ӧ�ȱ仯����,�����Ӧֵ=' num2str(BestFitness)])
                title(['�����Ӧֵ =' num2str(min(Fmin))]);
                xlabel('��������')
                ylabel('��Ӧ��ֵ')
%% �������
% plot(yy);
% title(['��Ӧ������    ������Ӧ��ֵ��' num2str(yy(500))]);
% xlabel('��������');
% ylabel('��Ӧ��');