# sprlist.pl: show sprite/guardian usage in Jet Set Willy
# =======================================================
#
# This Perl script shows, for each sprite (guardian) class, how many
# more instances of that class are used in each room.
#
# Usage: perl sprlist.pl <file>
#
# where <file> is in .z80 format.
#
# History
# =======
#
# 14 June 2002: version 1.0 by Geoff Eddy (geoff@morven.compulink.co.uk)
#
# Copyright status
# ================
#
# This is FREE SOFTWARE in the PUBLIC DOMAIN; you may do what you like
# with it, as long as you do not prevent others from doing likewise,
# or remove any lines from this header.
#
##############################################################################

use z80;

$file = shift @ARGV;

@mem = z80::read($file);

$geoffmode = 0;
$geoffmode = 1 if $mem[0x840c] == 0xc9;
$geoffmode = 2 if $mem[0x8400] != 0xf3;

foreach $id (0 .. 0x7f)
{
    $sprites[$id] = " " x 64;
}

foreach $room (0 .. 63)
{
    $start = 0xc000 + ($room << 8);

    foreach $spr (0 .. 7)
    {
        $id = $mem[$start + 0xf0 + 2 * $spr];
        next if !$id or $id > 0x7f;
        $i = substr $sprites[$id], $room, 1;
        substr($sprites[$id], $room, 1) = $i + 1;
        $total[$id] ++;
    }
}

print "##|tot";

foreach $i (0 .. 7)
{
    printf "| %02x->%02x ", 8 * $i, 8 * $i + 7;
}

print "|\n";

foreach $id (0 .. 0x7f)
{
    printf "%02x|%3d", $id, $total[$id];
    ($a = $sprites[$id]) =~ y/ /./;

    foreach $i (0 .. 7)
    {
        print "|", substr($a, 8 * $i, 8);
    }

    print "|\n";
}

##############################################################################

