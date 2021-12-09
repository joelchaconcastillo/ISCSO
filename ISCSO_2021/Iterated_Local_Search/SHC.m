function [lBest, feval] = SHC(obj, maxeval, feval)
   lBest=obj;
   rep=35;
   improved=true;
   while improved && feval < maxeval
      improved=false;
      for k=1:rep
        for i=1:obj.opt
          idx = randi([1,obj.dim]);
          idxBar = randi([1,obj.opt]);
          obj.X(idx)=i; %idxBar;
          obj = obj.evaluate();
          feval = feval+1;
          if obj.isBest(lBest)
             lBest=obj;
             improved=true;
	     rep=rep*2;
             disp([lBest.StressV, lBest.DisV, lBest.W, feval])
          else
             obj=lBest;
          end
          if feval==maxeval
             break;
          end
        end 
      end
   end
end
