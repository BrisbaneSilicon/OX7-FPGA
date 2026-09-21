proc get_spartan7_size {part} {
    if {[regexp -nocase {^xc7s([0-9]+)} $part -> size]} {
        return $size
    }

    error "Unable to extract Spartan-7 size from part: $part"
}

set here [file normalize [file dirname [info script]]]
set outdir [file join $here reports]
file mkdir $outdir

set parts {
    xc7s6ftgb196-1
    xc7s15ftgb196-1
    xc7s25ftgb196-1
    xc7s50ftgb196-1
}

set failures 0

foreach part $parts {
    puts "\n============================================================"
    puts "PIN CHECK: $part"
    puts "============================================================"

    set size [get_spartan7_size $part]

    create_project -dir .tmp -name pincheck_ox$size.xpr -part $part -force
    read_verilog -sv [file join "$here/../../proj/common/src/" ox.sv]

    if {[catch {synth_design -top ox -part $part} synth_err]} {
        puts "ERROR: synthesis failed for $part"
        puts $synth_err
        incr failures
        close_project
        continue
    }

    read_xdc [file join "$here/../constraints/ox-$size/" "ox-${size}.xdc"]

    if {[catch {opt_design} opt_err]} {
        puts "ERROR: opt_design failed for $part"
        puts $opt_err
        incr failures
    }

    if {[catch {place_design} place_err]} {
        puts "ERROR: place_design failed for $part"
        puts $place_err
        incr failures
    }

    report_io -file [file join $outdir ${part}_io.rpt]
    report_drc -file [file join $outdir ${part}_drc.rpt]
    report_methodology -file [file join $outdir ${part}_methodology.rpt]

    set critical_drc [get_drc_violations -quiet -filter {SEVERITY == Critical Warning || SEVERITY == Error}]
    if {[llength $critical_drc] != 0} {
        puts "WARNING: $part has [llength $critical_drc] Error/Critical-Warning DRC item(s)."
        puts "Review: [file join $outdir ${part}_drc.rpt]"
        incr failures
    } else {
        puts "PASS: no Error/Critical-Warning DRC items reported for $part"
    }

    close_project
}

puts "\n============================================================"
if {$failures == 0} {
    puts "ALL FOUR FTGB196 PIN CHECKS PASSED"
} else {
    puts "PIN CHECK COMPLETED WITH $failures FAILURE/WARNING SET(S)"
}
puts "Reports directory: $outdir"
puts "============================================================"

if {$failures != 0} {
    exit 1
}
exit 0
