classdef MPAD%Mixed partial automatic derivative
    %二元函数的混合一阶偏导数，为求Hessian矩阵定制
    %由Taylor级数与偏导数的关系，f(dx,dy)等于Taylor级数
    properties
        m%m-by-4 matrix,[1 dx dy dxdy]
    end
    methods
        function obj = MPAD(varargin)%初始化n维向量
            if isempty(varargin)
                obj.m = zeros(1,4);
            else
                obj.m = varargin{1};
            end
        end
        function matrix = double(a)
            matrix = a.m;
        end
        function c = plus(a,b)
            if ~isa(a,'MPAD')
                c = bsxfun(@plus,[a,0,0,0],b.m);
            elseif ~isa(b,'MPAD')
                c = bsxfun(@plus,a.m,[b,0,0,0]);
            else
                c = a.m + b.m;
            end
            c = MPAD(c);
        end
        function c = uminus(a)
            c = MPAD(-a.m);
        end
        function c = minus(a,b)
            if ~isa(a,'MPAD')
                c = bsxfun(@minus,[a,0,0,0],b.m);
            elseif ~isa(b,'MPAD')
                c = bsxfun(@minus,a.m,[b,0,0,0]);
            else
                c = a.m - b.m;
            end
            c = MPAD(c);
        end
        function c = mtimes(a,b)%times数值乘法
            if ~isa(a,'MPAD')
                c = bsxfun(@times,a,b.m);
            elseif ~isa(b,'MPAD')
                c = bsxfun(@times,a.m,b);
            else
                c = [
                    a.m(:,1) .* b.m(:,1), ...
                    a.m(:,1) .* b.m(:,2) + a.m(:,2) .* b.m(:,1), ...
                    a.m(:,1) .* b.m(:,3) + a.m(:,3) .* b.m(:,1), ...
                    a.m(:,1) .* b.m(:,4) + a.m(:,2) .* b.m(:,3) + a.m(:,3) .* b.m(:,2) + a.m(:,4) .* b.m(:,1)
                    ];
            end
            c = MPAD(c);
        end
        function c = mrdivide(a,b)%rdivide数值除法
            if ~isa(b,'MPAD')
                c = MPAD(bsxfun(@rdivide,a.m,b));
            else
                c = nan(size(b.m));
                if ~isa(a,'MPAD')
                    c(:,1) = a ./ b.m(:,1);
                    c(:,2) = -b.m(:,2) .* c(:,1) ./ b.m(:,1);
                    c(:,3) = -b.m(:,3) .* c(:,1) ./ b.m(:,1);
                    c(:,4) = -(b.m(:,4) .* c(:,1) + b.m(:,3) .* c(:,2) + b.m(:,2) .* c(:,3)) ./ b.m(:,1);
                else
                    c(:,1) = a.m(:,1) ./ b.m(:,1);
                    c(:,2) = (a.m(:,2) - b.m(:,2) .* c(:,1)) ./ b.m(:,1);
                    c(:,3) = (a.m(:,3) - b.m(:,3) .* c(:,1)) ./ b.m(:,1);
                    c(:,4) = (a.m(:,4) - b.m(:,4) .* c(:,1) - b.m(:,3) .* c(:,2) - b.m(:,2) .* c(:,3)) ./ b.m(:,1);
                end
                c = MPAD(c);
            end
        end
        function c = sqrt(a)
            c = nan(size(a.m));
            c(:,1) = sqrt(a.m(:,1));
            c(:,2) = a.m(:,2) ./ c(:,1) ./ 2;
            c(:,3) = a.m(:,3) ./ c(:,1) ./ 2;
            c(:,4) = (a.m(:,4) - c(:,2) .* c(:,3) .* 2) ./ c(:,1) ./ 2;
            c = MPAD(c);
        end
        function c = exp(a)
            n = size(a.m,1);
            c = [ones(n,1), a.m(:,2), a.m(:,3), a.m(:,2) .* a.m(:,3) + a.m(:,4)];
            c = bsxfun(@times,c,exp(a.m(:,1)));
            c = MPAD(c);
        end
        function c = log(a)
            c = [
                log(a.m(:,1)), ...
                a.m(:,2) ./ a.m(:,1), ... 
                a.m(:,3) ./ a.m(:,1), ...
                (a.m(:,1) .* a.m(:,4) - a.m(:,2) .* a.m(:,3)) ./ a.m(:,1).^2
                ];
            c = MPAD(c);
        end
        function c = mpower(a,b)
            if ~isa(b,'MPAD')
                c = [
                    a.m(:,1).^b, ...
                    b .* a.m(:,1).^(b-1) .* a.m(:,2), ...
                    b .* a.m(:,1).^(b-1) .* a.m(:,3), ...
                    b .* ((b-1) .* a.m(:,1).^(b-2) .* a.m(:,2) .* a.m(:,3) + a.m(:,1).^(b-1) .* a.m(:,4))
                    ];
            elseif ~isa(a,'MPAD')
                c = exp(b) .* log(a);  
            else
                n = size(a.m,1);
                c = nan(n,4);
                c(:,1) = a.m(:,1).^b.m(:,1);
                c(:,2) = (log(a.m(:,1)) .* b.m(:,2) + b.m(:,1) .* a.m(:,2) ./ a.m(:,1)) .* c(:,1);
                c(:,3) = (log(a.m(:,1)) .* b.m(:,3) + b.m(:,1) .* a.m(:,3) ./ a.m(:,1)) .* c(:,1);
                c(:,4) = c(:,3) .* (log(a.m(:,1)) .* b.m(:,2) + a.m(:,2) .* b.m(:,1) ./ a.m(:,1)) + ...
                    c(:,1) .* (a.m(:,3) .* b.m(:,2) ./ a.m(:,1) + log(a.m(:,1)) .* b.m(:,4) + ...
                    (b.m(:,3) .* a.m(:,1) - b.m(:,1) .* a.m(:,3)) ./ a.m(:,1).^2 + b.m(:,1) ./ a.m(:,1) .* a.m(:,4));
            end
            c = MPAD(c);
        end
        function c = sin(a)
            c = [
                sin(a.m(:,1)), ...
                cos(a.m(:,1)) .* a.m(:,2), ...
                cos(a.m(:,1)) .* a.m(:,3), ...
                -sin(a.m(:,1)) .* a.m(:,2) .* a.m(:,3) + cos(a.m(:,1)) .* a.m(:,4) 
                ];
            c = MPAD(c);
        end
        function c = cos(a)
            c = [
                cos(a.m(:,1)), ...
                -sin(a.m(:,1)) .* a.m(:,2), ...
                -sin(a.m(:,1)) .* a.m(:,3), ...
                -cos(a.m(:,1)) .* a.m(:,2) .* a.m(:,3) - sin(a.m(:,1)) .* a.m(:,4)
                ];
            c = MPAD(c);
        end
        function c = tan(a)%sin(a)/cos(a)
            c = [
                tan(a.m(:,1)), ...
                (tan(a.m(:,1)).^2 + 1) .* a.m(:,2), ...
                (tan(a.m(:,1)).^2 + 1) .* a.m(:,3), ...
                (tan(a.m(:,1)).^2 + 1) .* (2 .* tan(a.m(:,1)) .* a.m(:,2) .* a.m(:,3) + a.m(:,4))
                ];
            c = MPAD(c);
        end
        function c = cot(a)%cos(a)/sin(a) 1/tan(a)
            c = [
                cot(a.m(:,1)), ...
                -(cot(a.m(:,1)) + 1) .* a.m(:,2), ...
                -(cot(a.m(:,1)) + 1) .* a.m(:,3), ...
                (cot(a.m(:,1)).^2 + 1) .* (2 .* cot(a.m(:,1)) .* a.m(:,2) .* a.m(:,3) - a.m(:,4))
                ];
            c = MPAD(c);
        end
        function c = sec(a)
            c = 1 / cos(a);
        end
        function c = csc(a)
            c = 1 / sin(a);
        end
        function c = asin(a)
            c = [
                asin(a.m(:,1)), ...
                (1 - a.m(:,1)).^(-0.5) .* a.m(:,2), ...
                (1 - a.m(:,1)).^(-0.5) .* a.m(:,3), ...
                a.m(:,1) .* (1 - a.m(:,1).^2).^(-1.5) .* a.m(:,2) .* a.m(:,3) + (1 - a.m(:,1).^2).^(-0.5) .* a.m(:,4)
                ];
            c = MPAD(c);
        end
        function c = acos(a)
            c = [
                acos(a.m(:,1)), ...
                -(1 - a.m(:,1)).^(-0.5) .* a.m(:,2), ...
                -(1 - a.m(:,1)).^(-0.5) .* a.m(:,3), ...
                -(a.m(:,1) .* (1 - a.m(:,1).^2).^(-1.5) .* a.m(:,2) .* a.m(:,3) + (1 - a.m(:,1).^2).^(-0.5) .* a.m(:,4))
                ];
            c = MPAD(c);
        end
        function c = atan(a)
            c = [
                atan(a.m(:,1)), ...
                a.m(:,2) ./ (a.m(:,1).^2 + 1), ...
                a.m(:,3) ./ (a.m(:,1).^2 + 1), ...
                ((a.m(:,1).^2 + 1) .* a.m(:,4) - 2 .* a.m(:,1) .* a.m(:,2) .* a.m(:,3)) ./ (a.m(:,1).^2 + 1).^2
                ];
            c = MPAD(c);
        end
        function c = acot(a)
            c = [
                acot(a.m(:,1)), ...
                -a.m(:,2) ./ (a.m(:,1).^2 + 1), ...
                -a.m(:,3) ./ (a.m(:,1).^2 + 1), ...
                -((a.m(:,1).^2 + 1) .* a.m(:,4) - 2 .* a.m(:,1) .* a.m(:,2) .* a.m(:,3)) ./ (a.m(:,1).^2 + 1).^2
                ];
            c = MPAD(c);
        end
        function c = asec(a)
            c = acos(1/a);
        end
        function c = acsc(a)
            c = asin(1/a);
        end
    end
end