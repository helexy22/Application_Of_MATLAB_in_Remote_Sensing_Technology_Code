function f = TennisFunction(a,v,h)
rad = a * pi / 180;
tana = tan(rad);
vhor = (v * cos(rad)) ^ 2;
f = (vhor / 32) * (tana + sqrt(tana ^ 2 + 64 * h / vhor));
end