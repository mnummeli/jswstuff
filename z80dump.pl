# z80dump.pl
# ==========
#
# Perl script for printing hex dumps of .z80 files for Spectrum
# emulators.
#
# Usage
# =====
#
# perl z80dump.pl [options] <file> [options]
#
# The options are zero or more of the following:
#
# -s<start address>
# -e<end address>
# -l<number of bytes per line>
#
# All of the arguments are hexadecimal if suffixed with "h" or "H",
# otherwise decimal.
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

##############################################################################

use z80;

foreach (@ARGV)
{
    /-s/i and $start = $', next;
    /-e/i and $end   = $', next;
    /-l/i and $len   = $', next;
    $file = $_;
}

@mem = z80::read($file);

$start = hex $` if $start =~ /h$/i;
$start ||= 0x8000;

$end = hex $` if $end =~ /h$/i;
$end ||= 0x10000;

$len ||= 16;

for(; $start < $end; $start += $len)
{
    printf "%04x  ", $start;

    foreach $i (0 .. $len - 1)
    {
        printf "%02x ", $mem[$start + $i];
    }

    foreach $i (0 .. $len - 1)
    {
        $c = $mem[$start + $i];
        if($c >= 32 and $c < 127) { $a = pack "C", $c; }
        else                      { $a = ".";          }
        printf $a;
    }

    print "\n";
}

##############################################################################
