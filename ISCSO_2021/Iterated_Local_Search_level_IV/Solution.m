classdef Solution
  properties
   StressV, DisV, W, X, model
   StressP=1, DisP=1; %% stress penalization, displacement penalization
   %%%%% problem definition, note that it might be apart
   dim=345;
   opt=37;
   lower= ones(1,345);
   upper=37*ones(1,345);
   NeighbourSize=1;
   file;
   maxeval=200000;
  end
  methods
     function res=restart(obj) %% I miss passing by reference!!! :'(
        obj.X = obj.lower + floor(rand(1,obj.dim).*(obj.upper-obj.lower));
	res=obj.evaluate();
     end
     function res=partialRestart(obj)
        sizes=[4, 4,4,4,4,10,3,1,2,3];
        N = sizes(randi([1, 10]));
        idxBar = randi([1,obj.opt]);
        for k=1:N
          idx = randi([1,obj.dim]);
          obj.X(idx)=idxBar;
        end
      res= obj.evaluate();
     end
     function res=evaluate(obj)
        res=obj;
	[res.model, res.W, res.StressV, res.DisV] = fitness(obj.X, obj.StressP, obj.DisP, obj.dim);
     end
     function cmp = isBest(obj1, obj2)
       if obj1.StressV < obj2.StressV
	  cmp = true;
       elseif obj1.StressV > obj2.StressV
	  cmp = false;
       else
	  if obj1.DisV < obj2.DisV
	     cmp = true;
          elseif obj1.DisV > obj2.DisV
	     cmp = false;
          else 
             if obj1.W < obj2.W
		cmp = true;
	     elseif obj1.W > obj2.W
		cmp = false;
	     else
		cmp = false;
	     end
	  end
       end 
     end %%%!end function
  end
end
