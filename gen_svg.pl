#! /usr/bin/perl

##
## post proc of the output, e.g.
## convert -background none -resize 300x300 -density 300 file.svg  file.png
##

use strict;

print <<EOT;
<?xml version="1.0"?>
    <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
    "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
    <svg xmlns="http://www.w3.org/2000/svg" version="1.1"
         viewBox="-120 -120 240 240">
EOT
#          width="800px"
#         height="800px"

    ; # emacs indent gets confused...



my %node;
my @connect;
my $area = "";

while(<>) {
    if (/^node/) {
	my ($n, $id, $x, $y, $r, $l) = split /\s+/;
	$node{$id} = "$x $y $r $l";
    } elsif (/^connect/) {
	my ($n, $id0, $id1, $s) = split /\s+/;
	push @connect, "$id0 $id1 $s";
    } elsif (/^data/) {
	my ($rm, $fk, $px, $py, $pr) = split /\s+/;
	$area = "$px $py $pr";
    }
}

# connection first...
foreach my $c (@connect) {
    my ($id0, $id1, $s) = split /\s+/, $c;
    next if ($s*1.0) < 0.1;
    my ($x1, $y1, $r1, $l1) = split /\s+/, $node{$id0};
    my ($x2, $y2, $r2, $l2) = split /\s+/, $node{$id1};
    my $col = "#bababa";
    if (($s*1.0) > 0.7) {
	$col = "black";
    }
    print "<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" fill=\"none\" stroke=\"$col\" stroke-width=\"0.2\" />";
}

# then node
foreach my $n (keys %node) {
    my ($x, $y, $r, $l) = split /\s+/, $node{$n};
    my $col = "#C0C0C0";
    my $op = 0.5;
    if ($l > 0) {
	$col = "black";
	$op = 1.0;
    }
    print "<circle cx=\"$x\" cy=\"$y\" r=\"$r\" " .
	"stroke=\"none\" fill=\"$col\" fill-opacity=\"$op\" />\n";
}

my ($px, $py, $pr) = split /\s+/, $area;
print "<circle cx=\"$px\" cy=\"$py\" r=\"$pr\" stroke=\"none\" fill=\"red\" fill-opacity=\"0.2\" />";

print "</svg>\n";

exit 0;
