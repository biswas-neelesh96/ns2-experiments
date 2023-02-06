set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nf [open prog1eb1.nam w]
$ns namtrace-all $nf

set nd [open prog1eb1.tr w]
$ns trace-all $nd

proc finish {} {

global ns nf nd
$ns flush-trace

close $nf
close $nd

exec nam prog1eb1.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns color 1 Blue
$ns color 2 Red

$ns at 0.0 "$n0 label Sender"
$ns at 0.0 "$n1 label Sender"
$ns at 0.0 "$n2 label Sender"
$ns at 0.0 "$n3 label Receiver"

$ns at 0.0 "$n5 label Sender"

$ns duplex-link $n0 $n4 3Mb 10ms DropTail
$ns duplex-link $n1 $n4 3Mb 10ms DropTail
$ns duplex-link $n2 $n4 3Mb 10ms DropTail
$ns duplex-link $n3 $n4 3Mb 10ms DropTail

$ns duplex-link $n4 $n5 12Mb 20ms RED

$ns queue-limit $n5 $n4 8

$ns duplex-link-op $n0 $n4 orient right-down
$ns duplex-link-op $n1 $n4 orient right-down

$ns duplex-link-op $n2 $n4 orient right-up
$ns duplex-link-op $n3 $n4 orient right-up

$ns duplex-link-op $n4 $n5 queuePos 0.5

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

set null0 [new Agent/Null]
$ns attach-agent $n3 $null0

set null1 [new Agent/Null]
$ns attach-agent $n3 $null1

$ns connect $udp0 $null0
$ns connect $udp1 $null1

$ns at 0.0 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 0.0 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"

$ns at 5.0 "finish"

$ns run
