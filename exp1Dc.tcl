set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nf [open ju5.nam w]
$ns namtrace-all $nf

set nd [open ju5.tr w]
$ns trace-all $nd

proc finish {} {

global ns nf nd
$ns flush-trace

close $nf
close $nd

exec nam ju5.nam &
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
$ns duplex-link $n2 $n3 4Mb 20ms DropTail

$ns queue-limit $n2 $n3 4

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

$ns duplex-link-op $n2 $n3 queuePos 0.5
# $ns duplex-link-op $n0 $n2 queuePos 0.5
# $ns duplex-link-op $n1 $n2 queuePos 0.5

set tcp [new Agent/TCP]

$tcp set class_ 2
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

$ns connect $tcp $sink

$tcp set fid_ 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

$ns connect $udp $null
$udp set fid_ 2

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1000

$ns at 0.0 "$cbr start"
$ns at 10.0 "$ftp start"
$ns at 80.0 "$ftp stop"
$ns at 90.0 "$cbr stop"

$ns at 100.0 "finish"

$ns run

