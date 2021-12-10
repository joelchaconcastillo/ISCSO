function [lBest, feval] = warmup(obj, feval)
   lBest=obj;
   initial=obj;
   maxite=1;
   for ite=1:maxite
    obj=initial;%obj.restart();
%    feval=feval+1;
    llBest=obj;
    for in=1:1000
     idxBar = randi([1,obj.opt]);
     for k=1:obj.NeighbourSize
%     for k=1: %randi([1,obj.dim])
      idx = randi([1,obj.dim]);
      obj.X(idx)=idxBar;
     end
     obj = obj.evaluate();
     feval = feval+1;
     if obj.isBest(llBest)
         llBest=obj;
%         disp([llBest.StressV, llBest.DisV, llBest.W, feval])
     else
         obj=llBest;
     end
    end %for
    if llBest.isBest(lBest)
         lBest=llBest;
         disp([lBest.StressV, lBest.DisV, lBest.W, feval])
    end
   end
end
