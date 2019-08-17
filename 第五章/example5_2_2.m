clear;
p = rand(1,5);
q = ones(5);
save('pqfile.txt','p','q','-ascii')
type('pqfile.txt')
