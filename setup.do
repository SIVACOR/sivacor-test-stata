local scenario "B" 
* *** Add required packages from SSC to this list ***
local ssc_packages "reghdfe ftools estout require"

/* This works on all OS when running in batch mode, but may not work in interactive mode */
local pwd : pwd                     // This always captures the current directory

if "`scenario'" == "A" {             // If in Scenario A, we need to change directory first
    cd ..
}
if "`scenario'" == "C" {             // If in Scenario C, we need to go up twice
    cd ../..
}
global rootdir : pwd                // Now capture the directory to use as rootdir
display in red "Rootdir has been set to: $rootdir"



global logdir "${rootdir}/logs"
cap mkdir "$logdir"

/* check if the author creates a log file. If not, adjust the following code fragment */

local c_date = c(current_date)
local cdate = subinstr("`c_date'", " ", "_", .)
local c_time = c(current_time)
local ctime = subinstr("`c_time'", ":", "_", .)
local ldilog = "$logdir/logfile_`cdate'-`ctime'-`c(username)'.log"
local systeminfo = "$logdir/system_`cdate'-`ctime'-`c(username)'.log"

/* global logfile */
log using "`ldilog'", name(ldi) replace text

/* install any packages locally */
di "=== Redirecting where Stata searches for ado files ==="
capture mkdir "$rootdir/ado"
adopath - PERSONAL
adopath - OLDPLACE
adopath - SITE
sysdir set PLUS     "$rootdir/ado/plus"
sysdir set PERSONAL "$rootdir/ado"       // may be needed for some packages
sysdir

di "=== Verifying pre-existing ado files - normally, this should be EMPTY upon first run"
adopath
ado
di "=========================="

di "=== SYSTEM DIAGNOSTICS ==="
creturn list
query
di "------- displaying TMPDIR -------"
tempfile junk
display "`junk'"
di "=========================="


   
    display in red "============ Installing packages/commands from SSC ============="
    display in red "== Packages: `ssc_packages'"
    if !missing("`ssc_packages'") {
        foreach pkg in `ssc_packages' {
            capture which `pkg'
            if _rc == 111 {                 
               dis "Installing `pkg'"
                ssc install `pkg', replace
            }
            which `pkg'
        }
    }


di "=== Stata setup completed ==="
