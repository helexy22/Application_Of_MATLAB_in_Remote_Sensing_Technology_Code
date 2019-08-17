classdef valder < handle
   %针对向量形式的未知数，数量式的已知数
   %或者，向量式的已知数，数量式的未知数
    
   % VALDER class implementing Automatic Differentiation by operator overloading.
   % Computes first order derivative or multivariable gradient vectors by
   % starting with a known simple valder such as x=valder(3,1) and 
   % propagating it through elementary functions and operators. 
   % by Richard D. Neidinger 10./23./08
   properties
      val  %function value
      der  %derivative value or gradient vector
   end 
   methods
      function obj = valder(a,b)
         %VALDER class constructor; only the bottom case is needed.
         if nargin == 0 %never intended for use.
            obj.val = [];
            obj.der = [];
         elseif nargin == 1 %c=valder(a) for constant w./ derivative 0.
            obj.val = a;
            obj.der = 0;
         else
            obj.val = a; %given function value
            obj.der = b; %given derivative value or gradient vector
         end
      end
      function vec = double(obj)
         %VALDER./DOUBLE Convert valder object to vector of doubles.
         vec = [ obj.val, obj.der ];
      end
      function h = plus(u,v)
         %VALDER./PLUS overloads addition + with at least one valder object argument
         if ~isa(u,'valder') %u is a scalar
            h = valder(u+v.val, v.der);
         elseif ~isa(v,'valder') %v is a scalar
            h = valder(u.val+v, u.der);
         else
            h = valder(u.val+v.val, u.der+v.der);
         end
      end
      function h = uminus(u)
         %VALDER./UMINUS overloads negation - with a valder object argument
         h = valder(-u.val, -u.der);
      end
      function h = minus(u,v)
         %VALDER./MINUS overloads subtraction - with at least one valder object argument
         if ~isa(u,'valder') %u is a scalar
            h = valder(u-v.val, -v.der);
         elseif ~isa(v,'valder') %v is a scalar
            h = valder(u.val-v, u.der);
         else
            h = valder(u.val-v.val, u.der-v.der);
         end
      end
      function h = mtimes(u,v)
         %VALDER./MTIMES overloads multiplication .* with at least one valder object argument
         if ~isa(u,'valder') %u is a scalar
            h = valder(u.*v.val, u.*v.der);
         elseif ~isa(v,'valder') %v is a scalar
            h = valder(v.*u.val, v.*u.der);
         else
            h = valder(u.val.*v.val, bsxfun(@times,u.der,v.val) + bsxfun(@times,u.val,v.der));
         end
      end
      function h = mrdivide(u,v)
         %VALDER./MRDIVIDE overloads division ./ with at least one valder object argument
         if ~isa(u,'valder') %u is a scalar
            h = valder(u./v.val, (-u.*v.der)./(v.val).^2);
         elseif ~isa(v,'valder') %v is a scalar
            h = valder(u.val./v, u.der./v);
         else
            h = valder(u.val./v.val, bsxfun(@rdivide,(bsxfun(@times,u.der,v.val)-bsxfun(@times,u.val,v.der)),(v.val).^2));
         end
      end
      function h = mpower(u,v)
         %VALDER./MPOWER overloads power .^ with at least one valder object argument
         if ~isa(u,'valder') %u is a scalar
            h = valder(u.^v.val, bsxfun(@times,u.^v.val.*log(u),v.der));
         elseif ~isa(v,'valder') %v is a scalar
            h = valder(u.val.^v, bsxfun(@times,v.*u.val.^(v-1),u.der));
         else
            h = exp(v*log(u)); %call overloaded log, .* and exp
         end
      end
      function h = exp(u)
         %VALDER./EXP overloads exp of a valder object argument
         h = valder(exp(u.val), bsxfun(@times,exp(u.val),u.der));
      end
      function h = log(u)
         %VALDER./LOG overloads natural logarithm of a valder object argument
         h = valder(log(u.val), bsxfun(@rdivide,u.der,u.val));
      end
      function h = sqrt(u)
         %VALDER./SQRT overloads square root of a valder object argument
         h = valder(sqrt(u.val), bsxfun(@rdivide,u.der,2.*sqrt(u.val)));
      end
      function h = sin(u)
         %VALDER./SIN overloads sine with a valder object argument
         h = valder(sin(u.val), bsxfun(@times,cos(u.val),u.der));
      end
      function h = cos(u)
         %VALDER./COS overloads cosine of a valder object argument
         h = valder(cos(u.val), -bsxfun(@times,sin(u.val),u.der));
      end
      function h = tan(u)
         %VALDER./TAN overloads tangent of a valder object argument
         h = valder(tan(u.val), bsxfun(@times,(sec(u.val)).^2,u.der));
      end
      function h = asin(u)
         %VALDER./ASIN overloads arcsine of a valder object argument
         h = valder(asin(u.val), bsxfun(@rdivide,u.der,sqrt(1-u.val.^2)));
      end
      function h = atan(u)
         %VALDER./ATAN overloads arctangent of a valder object argument
         h = valder(atan(u.val), bsxfun(@rdivide,u.der,(1+u.val.^2)));
      end
   end
end