#!/bin/bash

#tcp_1up tcp_2up tcp_4up tcp_5up tcp_6up tcp_8up tcp_12up tcp_50up
#5 10 16 20 30 40 60 80 100 150 200 300 400 500 550
#for test in tcp_5up
#do
for rtt in tcp_5up
do
rm plot-shell-${rtt}_delay
rm plot-shell-${rtt}_avg_dq_rate
paste time.dat ${rtt}_delay.dat > PIE-delay.dat
paste time.dat ${rtt}_avg_dq_rate.dat > PIE-avg_dq_rate.dat
#paste time.dat MPIE-${rtt}.dat > MPIE-delay.dat
echo "set terminal postscript eps color font 20 
set output \"${rtt}_delay.eps\"
set xlabel \"Time (s)\"
set ylabel \"Queue Delay (ms)\"
set xrange[0:100] 
set yrange[0:180]
set grid
show grid
set key left top horizontal
plot \"PIE-delay.dat\" using 1:2 title 'PIE' with lines lw 2 lc 'blue'" >> plot-shell-${rtt}_delay
gnuplot plot-shell-${rtt}_delay 

echo "set terminal postscript eps color font 20 
set output \"${rtt}_avg_dq_rate.eps\"
set xlabel \"Time (s)\"
set ylabel \"Avg. Deque Rate (bytes/ms)\"
set xrange[0:100] 
set yrange[1000000:2000000]
set grid
show grid
set key left top horizontal
plot \"PIE-avg_dq_rate.dat\" using 1:2 title 'PIE' with lines lw 2 lc 'blue'" >> plot-shell-${rtt}_avg_dq_rate
gnuplot plot-shell-${rtt}_avg_dq_rate 

done 
#done
