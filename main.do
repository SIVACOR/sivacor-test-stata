include "setup.do"

global results "${rootdir}/results"
cap mkdir "$results"

sysuse auto, clear


sysuse auto
reghdfe price weight, noa

estout using "$results/results.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(2))) ///
    stats(N r2, fmt(0 3) labels("Observations" "R-squared")) ///
    title("Regression Results") ///
    varlabels(_cons "Constant") ///
    starlevels(* 0.10 ** 0.05 *** 0.01) 
    