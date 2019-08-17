function vec = fmf(a0,v0,h0)
num = length(a0);
%��a,vΪ������hΪ����
a = MPAD([a0,  ones(num,1), zeros(num,1), zeros(num,1)]);
v = MPAD([v0, zeros(num,1),  ones(num,1), zeros(num,1)]);
h = MPAD([h0, zeros(num,1), zeros(num,1), zeros(num,1)]);

rad = a * pi / 180;
tana = tan(rad);
vhor = (v * cos(rad)) ^ 2;
f = (vhor / 32) * (tana + sqrt(tana ^ 2 + 64 * h / vhor));

vec = double(f);
end