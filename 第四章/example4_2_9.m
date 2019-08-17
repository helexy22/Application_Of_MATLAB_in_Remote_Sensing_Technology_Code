clear;

[nx, ny, nz] = surfnorm(peaks);
b = reshape([nx ny nz], 49,49,3);
figure
surf(ones(49),'VertexNormals',b,'EdgeColor','none');
lighting gouraud
camlight
