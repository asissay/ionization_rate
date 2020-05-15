reset

# set te du
# set te svg
# set out "xx.svg"

###
### 2e14 cap tuning
###
#datafile = "q_i_2_aug_mab_cap_3.5.dat"
#datafile = "q_i_2_aug_mab_cap_3.dat"
# datafile = "q_i_2_aug_mab_cap_4.5.dat"
#datafile = "q_i_2_aug_mab_cap_4.dat"
# datafile = "q_i_2_aug_mab_cap_5.375.dat"
#datafile = "q_i_2_aug_mab_cap_5.5.dat"
#datafile = "q_i_2_aug_mab_cap_5.dat"
#datafile = "q_i_2_aug_mab_cap_6.5.dat"
#datafile = "q_i_2_aug_mab_cap_6.dat"
# datafile = "q_i_2_aug_mab_cap_7.5.dat"
#datafile = "q_i_2_aug_mab_cap_7.dat"
#datafile = "q_i_2_aug_mab_cap_8.dat"


###
### 5e14 cap tuning
###
#datafile = "q_i_5e14_aug_mab_cap_3.5.dat"
#datafile = "q_i_5e14_aug_mab_cap_3.dat"
# datafile = "q_i_5e14_aug_mab_cap_4.5.dat"
#datafile = "q_i_5e14_aug_mab_cap_4.dat"
# datafile = "q_i_5e14_aug_mab_cap_5.375.dat"
# datafile = "q_i_5e14_aug_mab_cap_5.5.dat"
# datafile = "q_i_5e14_aug_mab_cap_5.dat"
# datafile = "q_i_5e14_aug_mab_cap_6.5.dat"
# datafile = "q_i_5e14_aug_mab_cap_6.dat"
# datafile = "q_i_5e14_aug_mab_cap_7.5.dat"
# datafile = "q_i_5e14_aug_mab_cap_7.dat"
#datafile = "q_i_5e14_aug_mab_cap_8.dat"




###
### R = 6.5 A data
###
#datafile = "q_con_dens_i_1.1719e14_new.dat"
#datafile = "q_con_dens_i_3e14_new.dat"
#datafile = "q_con_dens_i_1.3102e14_new.dat"
#datafile = "q_con_dens_i_1.465e14_new.dat"
#datafile = "q_con_dens_i_1.6379e14_new.dat"
#datafile = "q_con_dens_i_1.8313e14_new.dat"
#datafile = "q_con_dens_i_1.9573e13_new.dat"
#datafile = "q_con_dens_i_1e13_new.dat"
#datafile = "q_con_dens_i_1e14_new.dat"
#datafile = "q_con_dens_i_1e15_new.dat"
#datafile = "q_con_dens_i_2.2893e14_new.dat"
#datafile = "q_con_dens_i_2.5596e14_new.dat"
#datafile = "q_con_dens_i_2.8619e14_new.dat"
#datafile = "q_con_dens_i_2e14_new.dat"
#datafile = "q_con_dens_i_3.1998e14_new.dat"
#datafile = "q_con_dens_i_3.577e14_new.dat"
#datafile = "q_con_dens_i_3.8312e13_new.dat"
#datafile = "q_con_dens_i_4.4723e14_new.dat"
#datafile = "q_con_dens_i_4e14_new.dat"
#datafile = "q_con_dens_i_5e14_new.dat"
#datafile = "q_con_dens_i_6.299e14_new.dat"
#datafile = "q_con_dens_i_7.4989e13_new.dat"
#datafile = "q_con_dens_i_7.9372e14_new.dat"
#datafile = "q_con_dens_i_8.3844e13_new.dat"
#datafile = "q_con_dens_i_9.3744e13_new.dat"

#datafile = "q_1e14_perp.dat"
#datafile = "q_4e14_perp.dat"
datafile = "q_3e14_perp.dat"

# Angle data

# datafile = "../angles/q_angle_0_2e14.dat"
# datafile = "q_angle_9_2e14.dat
# datafile = "q_angle_18_2e14.dat"
# datafile = "q_angle_27_2e14.dat"
# datafile = "q_angle_36_2e14.dat"
# datafile = "q_angle_45_2e14.dat"
# datafile = "q_angle_54_2e14.dat"
# datafile = "q_angle_63_2e14.dat"
# datafile = "q_angle_72_2e14.dat"
# datafile = "q_angle_81_2e14.dat"
# datafile = "../angles/q_angle_90_2e14.dat"
# datafile = "q_angle_108_2e14.dat"
# datafile = "q_angle_135_2e14.dat"
# datafile = "q_angle_180_2e14.dat"

nelec = 14

## autoionizing rate: assumes linear near t=0
aai = -1e-5
cai = nelec
nai(x) = aai*x + cai
set xrange[0:10]
fit nai(x) datafile u 2:(-$3) via aai, cai
#plot nai(x), datafile u 2:(-$3) w l 
delta_nai(x) = -nelec + nai(x)  #number of electrons we have lost due to autoionizing.  This should be negative

## physical ionization: exponential shifted in time
araw = -0.2
x0raw = 120
craw = nelec - 1

acorr = araw
x0corr = x0raw
ccorr = craw

nraw(x) = exp(araw*(x-x0raw)) + craw
ncorr(x) = exp(acorr*(x-x0corr)) + ccorr

set xrange[x0raw:*]

## without autoionization correction
fit nraw(x) datafile u 2:(-$3) via araw,craw,x0raw

## with autoionizing removed
fit ncorr(x) datafile u 2:(-$3 - delta_nai($2)) via acorr, ccorr, x0corr

plot datafile u 2:(-$3) w l, nraw(x) w l
plot datafile u 2:(-$3) w l ti "Raw (data)", \
     nraw(x) w lp ti "Raw (fit)", \
     datafile u 2:(-$3 - delta_nai($2)) w l ti "Corrected (data)", \
     ncorr(x) w lp ti "Corrected (fit)", \
     nai(x) w l

#datafile u 2:(-$3) w l ti "Raw", nai(x) w l ti "Autoionizing"

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