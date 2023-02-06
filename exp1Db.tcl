set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nf [open ju1.nam w]
$ns namtrace-all $nf

set nd [open ju1.tr w]
$ns trace-all $nd

proc finish {} {

global ns nf nd
$ns flush-trace

close $nf
close $nd

exec nam ju1.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns color 1 Blue
$ns color 2 Red

$ns at 0.0 "$n0 label Sender"
$ns at 0.0 "$n1 label Sender"
$ns at 0.0 "$n3 label Receiver"

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail

$ns duplex-link $n2 $n3 2Mb 20ms RED

$ns queue-limit $n3 $n2 4

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

$ns duplex-link-op $n2 $n3 queuePos 0.5
# $ns duplex-link-op $n0 $n2 queuePos 0.5
# $ns duplex-link-op $n1 $n2 queuePos 0.5

set tcp0 [new Agent/TCP]
set tcp1 [new Agent/TCP]

$tcp0 set fid_ 1
$tcp1 set fid_ 2

$tcp0 set packetSize_ 1000
$tcp1 set packetSize_ 1000

$tcp0 set rate_ 1.0Mb
$tcp1 set rate_ 1.0Mb

$ns attach-agent $n0 $tcp0
$ns attach-agent $n1 $tcp1

set sink0 [new Agent/TCPSink]
set sink1 [new Agent/TCPSink]

$ns attach-agent $n3 $sink0
$ns attach-agent $n3 $sink1

$ns connect $tcp0 $sink0
$ns connect $tcp1 $sink1

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

$ns at 0.5 "$ftp0 start"
$ns at 4.5 "$ftp0 stop"
$ns at 1.0 "$ftp1 start"
$ns at 4.0 "$ftp1 stop"

$ns at 5.0 "finish"

$ns run

