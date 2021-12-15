function superplot9399(col)

global n9399 nend9399 ini9399 end9399 x9399 y9399 typ9399

i1=indexofarr(x9399,ini9399(n9399));
i2=indexofarr(x9399,end9399(n9399));
switch typ9399
    case 0
        plot(x9399(i1:i2),y9399(i1:i2),col)
    case 1
        semilogx(x9399(i1:i2),y9399(i1:i2),col)
    case 2
        semilogy(x9399(i1:i2),y9399(i1:i2),col)
    case 3
        loglog(x9399(i1:i2),y9399(i1:i2),col)
end