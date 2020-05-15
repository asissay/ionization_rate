reset

data0 = "occs_0.dat"

datafile = "90_2e14_moocc.dat"

nelec = 1
orb = 2

colnum = orb+2

## autoionizing rate: assumes linear near t=0
aai = -1e-5
cai = nelec
nai(x) = aai*x + cai
set xrange[10:*]
fit nai(x) data0 u 1:(column(colnum)) via aai, cai
#plot nai(x), datafile u 2:(-$3) w l 
delta_nai(x) = - nelec + nai(x)  #number of electrons we have lost due to autoionizing.  This should be negative XXX CHECK

## physical ionization: exponential shifted in time
araw = -0.001
x0raw = 120
craw = nelec - 1 + 0.1 #+ 0.0001

acorr = araw
x0corr = x0raw
ccorr = craw

nraw(x) = exp(araw*(x-x0raw)) + craw
ncorr(x) = exp(acorr*(x-x0corr)) + ccorr


set xrange[x0raw:*]

## without autoionization correction
fit nraw(x) datafile u 1:(column(colnum)) via araw,craw,x0raw

## with autoionizing removed
fit ncorr(x) datafile u 1:(column(colnum) - delta_nai($1)) via acorr,ccorr,x0corr


plot datafile u 1:(column(colnum)) w lp ti "Raw (data)", \
     nraw(x) w lp ti "Raw (fit)", \
     datafile u 1:(column(colnum) - delta_nai($1)) w lp ti "Corrected (data)", \
     ncorr(x) w lp ti "Corrected (fit)", \
     nai(x) w lp, \
     "occs_0.dat" u 1:(column(colnum)) w lp ti "Zero field" ls 8

# plot datafile u 1:(column(colnum)) w l ti "Raw (data)", \
#      nraw(x) w lp ti "Raw (fit)"


print("")
print("---------------------------------------------------")
rate_invsec = aai / 0.02419 / 1e-15
out = sprintf("Nonphysical autoionizing rate [s-1] = %g", rate_invsec)
print (out)

rate_invsec = araw / 0.02419 / 1e-15
out = sprintf("Uncorrected ionization rate [s-1]   = %g", rate_invsec)
print (out)

rate_invsec = acorr / 0.02419 / 1e-15
out = sprintf("Corrected ionization rate [s-1]     = %g", rate_invsec)
print (out)
print("---------------------------------------------------")
print("")

pause -1