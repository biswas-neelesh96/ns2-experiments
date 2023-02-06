#Create Simulator
set ns [new Simulator]

#Use colors to differentiate the traffic
$ns color 1 Blue
$ns color 2 Red

#Open trace and NAM trace file
set ntrace [open prog5.tr w]
$ns trace-all $ntrace
set namfile [open prog5.nam w]
$ns namtrace-all $namfile

#Finish Procedure
proc Finish {} {
global ns ntrace namfile

#Dump all trace data and close the files
$ns flush-trace
close $ntrace
close $namfile

#Execute the nam animation file
exec nam prog5.nam &
exit 0
}

#Create 6 nodes
for {set i 0} {$i<6} {incr i} {
set n($i) [$ns node]
}

#Create duplex links between the nodes
$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 4Mb 100ms DropTail

set lan [$ns newLan "$n(3) $n(4) $n(5)" 1Mb 40ms LL Queue/DropTail MAC/csma/cd Channel]
$ns duplex-link-op $n(0) $n(2) orient right-down
$ns duplex-link-op $n(1) $n(2) orient right-up
$ns duplex-link-op $n(2) $n(3) orient right

$ns queue-limit $n(2) $n(3) 20
$ns duplex-link-op $n(2) $n(3) queuePos 0.5

set tcp0 [new Agent/TCP]
$tcp0 set fid_ 1
#$tcp0 set window_ 8000
$tcp0 set packetSize_ 552
$ns attach-agent $n(0) $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n(4) $sink0
$ns connect $tcp0 $sink0

#Apply FTP Application over TCP
set ftp0 [new Application/FTP]
$ftp0 set type_ FTP
$ftp0 attach-agent $tcp0
#Setup UDP Connection between n(1) and n(5)

set udp0 [new Agent/UDP]
$udp0 set fid_ 2
$ns attach-agent $n(1) $udp0

set null0 [new Agent/Null]
$ns attach-agent $n(5) $null0
$ns connect $udp0 $null0

#Apply CBR Traffic over UDP
set cbr0 [new Application/Traffic/CBR]
$cbr0 set type_ CBR
$cbr0 set packetSize_ 1000
#$cbr0 set rate_ 0.1Mb
$cbr0 set random_ false
$cbr0 attach-agent $udp0

#Schedule events
$ns at 0.1 "$cbr0 start"
$ns at 1.0 "$ftp0 start"
$ns at 20.0 "$ftp0 stop"
$ns at 24.0 "$cbr0 stop"
$ns at 25.0 "Finish"
#Run Simulation
$ns run
