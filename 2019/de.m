
NSizing_variables = 260;
NShape_variables = 10;
lower = [ ones(1,NSizing_variables),  -25000*ones(1,NShape_variables)];
upper = [ 37*ones(1,NSizing_variables), 3500*ones(1,NShape_variables)];

Flag = 0;
maxeval = 200000;
N = 10;
dim = NSizing_variables + NShape_variables;
p1 = 1000000000;
p2 = 1000000000;
%[Weight,  Const_Vio_Stress,  Const_Vio_Disp] = ISCSO_2018(Sections,  Coordinates,  Flag)
Population = zeros(N, dim);
F = zeros(N, 3)
%%initialization..
for i = 1:N
    Population(i,:) = lower + floor(rand(1,dim).*(upper-lower));
%    [ randi(37,1, NSizing_variables),  9000 + randi(11000,1, NShape_variables) ];
    [Weight,  Const_Vio_Stress,  Const_Vio_Disp] = ISCSO_2018(Population(i,1:NSizing_variables),  Population(i, NSizing_variables+1:NSizing_variables+NShape_variables),  0);
    F(i,:) = [Weight, Const_Vio_Stress, Const_Vio_Disp];
end

fbest = 100000000000000
vBest = [1,2,3]

for gen = 1:(maxeval/N)
    for i = 1:N
       %%select tree random indexes...
       idx1 = randi(N);
       while i == idx1
           idx1 = randi(N);
       end
       
       idx2 = randi(N);
       while i == idx2 || idx2==idx1
           idx2 = randi(N);
       end
       
       idx3 = randi(N);
       while (i == idx3) || (idx3 == idx1) || (idx3 == idx2)
           idx3 = randi(N);
       end
       Trial = zeros(1, dim);
       dd = randi(dim);
       Fm = normrnd(0.5, 0.1);
       for d = 1:dim
           if (rand() < 0.2) || (d==dd)
             Trial(d) = Population(idx1,d) + floor(Fm*(Population(idx2,d) - Population(idx3,d)));
           else
             Trial(d) = Population(i,d);
           end
           Trial(d) = min(Trial(d), upper(d));
           Trial(d) = max(Trial(d), lower(d));
       end
       [Weight,  Const_Vio_Stress,  Const_Vio_Disp] = ISCSO_2018(Trial(1:NSizing_variables),  Trial(NSizing_variables+1:NSizing_variables+NShape_variables),  0);
       fTrial = [Weight,  Const_Vio_Stress,  Const_Vio_Disp];
       fitnessF = F(i,1)+p1*F(i,2) + p2*F(i,3);
       if fitnessF < fbest
	       fbest = fitnessF
       	       vBest = fTrial;
	end
       fitnesstrial = fTrial(1)+p1*fTrial(2) + p2*fTrial(3);
       if fitnesstrial < fitnessF
          Population(i,:) = Trial;
          F(i,:) = fTrial;
       end
    end

%   Population(1,:) = lower + floor(rand(1,dim).*(upper-lower));
%  Population
   gen
   ave = 0;%mean(mean(Population)/(upper-lower))
   for i = 1:N
     idxs = logical(zeros(1,N)+1);
     idxs(i) = false;
     diff = (Population(idxs,:) - Population(i,:)).^2;
     diff = (diff)/(upper-lower);
     diff = sum(diff, 2);
%     [k, dist] = dsearchn(Population(idxs,:), Population(i,:))
     ave = ave + min(diff);
   end
   ave =ave/N
   fbest
   vBest
end

F
