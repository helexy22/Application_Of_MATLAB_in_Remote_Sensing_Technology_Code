function myErrorDemo()  

for k = 1:10
    myErrorFunction();
end

end

function myErrorFunction()
error('The fact error is here.');
end
