function h = myHessianMatrix(a0,v0,h0)
seriesParamNum = 3;
mpadParamNum = 4;
mx = [a0,v0,h0];
groupNum = size(mx,1);
xNum = size(mx,2);
h = nan([xNum,xNum,groupNum]);
%计算二阶导数
m0 = zeros(groupNum, seriesParamNum - 1);
cx = cell(xNum,1);
for k = 1:xNum
    cx{k} = series(mx(:,k),m0);
end
for k = 1:xNum
    m1 = m0;
    m1(:,1) = ones(groupNum,1);
    temp = cx{k}; 
    cx{k} = series(mx(:,k),m1);
    f = TennisFunction(cx{1},cx{2},cx{3});
    vec = double(f);
    h(k,k,:) = vec(:,seriesParamNum) * 2;
    cx{k} = temp;
end
%计算二阶混合偏导数
m0 = zeros(groupNum, mpadParamNum - 1);
for k = 1:xNum
    cx{k} = MPAD([mx(:,k),m0]);
end
cmb = nchoosek(1:xNum,2);
cmbNum = size(cmb,1);
for k = 1:cmbNum
    id1 = cmb(k,1);
    id2 = cmb(k,2);
    temp1 = cx{id1};
    temp2 = cx{id2};
    m1 = m0;
    m1(:,id1) = ones(groupNum,1);
    cx{id1} = MPAD([mx(:,id1),m1]);
    m1 = m0;
    m1(:,id2) = ones(groupNum,1);
    cx{id2} = MPAD([mx(:,id2),m1]);
    f = TennisFunction(cx{1},cx{2},cx{3});
    vec = double(f);
    h(id1,id2,:) = vec(:,mpadParamNum);
    h(id2,id1,:) = vec(:,mpadParamNum);
    cx{id1} = temp1;
    cx{id2} = temp2;
end
end

function f = TennisFunction(a,v,h)
rad = a * pi / 180;
tana = tan(rad);
vhor = (v * cos(rad)) ^ 2;
f = (vhor / 32) * (tana + sqrt(tana ^ 2 + 64 * h / vhor));
end