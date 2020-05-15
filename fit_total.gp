n0 =  2.964233235090E+001 + 1.702e-05 * 660
xmin = 660
x0 = xmin
a = 0.0000000000001
#b = 1 # 0.996

n(x) =  exp(-a*(x-x0)) + n0 - 1

set xrange[xmin:*]
fit n(x) "q.dat" u 2:(-$3 + 1.702e-05 * $2) via a  , x0 #, n0

plot "q.dat" u  2:(-$3 + 1.702e-05 * $2) w l, n(x) w l 

print a 

pause -1
