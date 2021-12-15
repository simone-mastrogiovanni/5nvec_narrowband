function cel=multi_token(strin)
%MULTI_TOKEN  divides in tokens a string

rem=strin;
i=0;
cel{1}=' ';

while length(rem) > 0
    [token rem]=strtok(rem);
    i=i+1;
    cel{i}=token;
end