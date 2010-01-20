#!/usr/bin/perl
#
use Encode;
use MIME::Base64 qw(encode_base64 decode_base64);

my $indent = 8;
my $icode = "utf-8";
my $ocode = "utf-16be";

my @test = qw(
    田中
    表示する。
    田中とASCII
    田中とカタカナ
);

sub make_pair {
    my $str = shift;
    my $utf8 = Encode::decode('utf-8', $str);
    my $jis = Encode::encode($icode, $utf8);
    my $euc = Encode::encode($ocode, $utf8);
    $jis = encode_base64($jis);
    $euc = encode_base64($euc);
    chomp $jis;
    chomp $euc;
    return [$jis, $euc];
}

for (my $i = 0; $i < scalar(@test); $i++) {
    my $pair = &make_pair($test[$i]);
    my $test = sprintf("assertEquals('%s', '%s', encode('%s'));",
        "Encoding Test [$icode]->[$ocode] [$i]", $pair->[1], $pair->[0]);
    print " " x $indent;
    print $test;
    print "\n";
}


my $n1 = 0xa0;
my $sum = 0x60 + ($n1 < 0xe0);
print $sum;
print "\n";
