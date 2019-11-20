
Nsections = 314;
Ncoordinates = 14;
Sections = randi(37,1, Nsections);
Coordinates = 9000 + randi(11000,1, Ncoordinates);
lower = [ ones(1,Nsections),  9000*ones(1,Ncoordinates)];
upper = [ 37*ones(1,Nsections), 20000*ones(1,Ncoordinates)];
Flag = 10;
maxeval = 200000;
N = 10;
dim = Nsections + Ncoordinates;
p1 = 100000;
p2 = 100000;
%[Weight,  Const_Vio_Stress,  Const_Vio_Disp] = ISCSO_2018(Sections,  Coordinates,  Flag)
Population = zeros(N, dim)
F = zeros(N, 3)
%%initialization..
for i = 1:N
    Population(i,:) = [ randi(37,1, Nsections),  9000 + randi(11000,1, Ncoordinates) ];
    [Weight,  Const_Vio_Stress,  Const_Vio_Disp] = ISCSO_2018(Population(i,1:Nsections),  Population(i, Nsections+1:Nsections+Ncoordinates),  0);
    F(i,:) = [Weight, Const_Vio_Stress, Const_Vio_Disp];
end


for gen = 1:1000%(maxeval/N)
    for i = 1:N
       %%select tree random indexes...
       idx1 = randi(N);
       while i == idx1
           idx1 = randi(N);
       end
       
       idx2 = randi(N);
       while i == idx2
           idx2 = randi(N);
       end
       
       idx3 = randi(N);
       while i == idx3
           idx3 = randi(N);
       end
       Trial = zeros(1, dim);
       for d = 1:dim
           if rand() < 0.9
             Trial(d) = round(Population(idx1,d) + 0.5*(Population(idx2,d) - Population(idx3,d)));
           else
             Trial(d) = Population(i,d);
           end
           Trial(d) = min(Trial(d), upper(d));
           Trial(d) = max(Trial(d), lower(d));
       end
       [Weight,  Const_Vio_Stress,  Const_Vio_Disp] = ISCSO_2018(Trial(1:Nsections),  Trial(Nsections+1:Nsections+Ncoordinates),  0);
       fTrial = [Weight,  Const_Vio_Stress,  Const_Vio_Disp];
       fitnessF = F(i,1)+p1*F(i,2) + p2*F(i,3);
       fitnesstrial = fTrial(1)+p1*fTrial(2) + p2*fTrial(3);
       if fitnesstrial < fitnessF
          Population(i,:) = Trial;
          F(i,:) = fTrial;
       end
    end
   gen
end

F
