clear;
txtPath = 'TestData.txt';
fid = fopen(txtPath,'w');
fprintf(fid,'09/12/2005 Level1 12.34 45 1.23e10 inf Nan Yes 5.1+3i\n');
fprintf(fid,'10/12/2005 Level2 23.54 60 9e19 -inf  0.001 No 2.2-.5i\n');
fprintf(fid,'11/12/2005 Level3 34.90 12 2e5  10  100  No 3.1+.1i\n');
fclose(fid);

fileID = fopen(txtPath,'r');
C = textscan(fileID,'%s %s %f32 %d8 %u %f %f %s %f')
fclose(fileID);
