set ns [new Simulator]

set ntrace [open prog.tr w]
$ns trace-all $ntrace

set namfile [open prog.nam w]
$ns namtrace-all $namfile

proc finish {} {
global ns ntrace namfile

$ns flush-trace
close $ntrace
close $namfile

exec nam prog.nam &
exit 0
}
set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 1Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set null0 [new Agent/UDP]
$ns attach-agent $n1 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500 $cbr0
set interval_ 0.005

$cbr0 attach-agent $udp0
$ns connect $udp0 $null0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set null1 [new Agent/UDP]
$ns attach-agent $n0 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500 $cbr1 
set interval_ 0.005

$cbr1 attach-agent $udp1

$ns connect $null1 $udp1

$ns at 0.5 "$cbr0 start"
$ns at 2.0 "$cbr1 start"
$ns at 2.5 "$cbr0 stop"
$ns at 5.0 "$cbr1 stop"

$ns at 5.5 "finish"

$ns run
