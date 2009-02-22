# jswdump.pl
# ==========
#
# This Perl script prints out details of a JSW game in text
# format. The output is in the format used by jswclop.pl.
#
# Usage
# =====
#
# perl jswdump.pl [options] <file>
#
# <file> must be in .z80 format.
#
# Options are as follows:
#
# -a print everything
# -g print guardian classes
# -r<rooms> print only some rooms
# -s<pages> print only some sprite images
#
# Both <rooms> and <pages> are comma-separated lists of hex numbers or
# hex ranges. In other words, with the original JSW you can do
# "-r21,23-24" to get the Master Bedroom, Bathroom and A Bit of Tree.
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

use z80;

##############################################################################

sub dpeek
{
    my $mem  = shift;
    my $byte = shift;
    $ret = $$mem[$byte];
    $ret + ($$mem[$byte + 1] << 8);
}

##############################################################################

sub byte2bin
{
    my $byte = shift;
    my $ret  = "";

    foreach $col(0 .. 7)
    {
        $ret .= ($byte & 0x80 ? "%" : ".");
        $byte <<= 1;
    }

    $ret;
}

##############################################################################

sub print_half_page
{
    ($mem, $page, $startcol) = @_;

    foreach $row (0 .. 15)
    {
        foreach $col (0 .. 3)
        {
            print "    " if $col;
            $add = $page * 256 + 32 * ($col + $startcol) + $row * 2;
            print byte2bin $$mem[$add];
            print byte2bin $$mem[$add + 1];
        }
        print "\n";
    }
    print "\n";
}

##############################################################################

sub print_page
{
    ($mem, $page) = @_;
    return if $page < 0 or $page > 255;

    printf "Sprite page %02x\n", $page;
    print_half_page $mem, $page, 0;
    print_half_page $mem, $page, 4;
}

##############################################################################

sub get_guard_data
{
    ($mem, $data, $n, $geoffmode) = @_;
    my @types = qw(arrow hor ver rope);
    my $start = $data * 256 + $n * 8;
    my $ret = sprintf "%02X ", $n;

    #byte 0: dxxxxwtt
    my $byte = $$mem[$start];
    return $ret . " unused" unless $byte;

    my $type = $byte & 3;
    $ret .= sprintf " %-5s", $types[$type];

    $ret .= " " . ($byte & 0x80 ? "> " : "< ");

    if($type == 0)
    {
        $ret .= sprintf " %02x", $$mem[$start + 4];
        $ret .= sprintf " %02x", $$mem[$start + 6];
        return $ret;
    }

    if($type == 3)
    {
        $ret .= sprintf " %02x", $$mem[$start + 1];
        $ret .= sprintf " %02x", $$mem[$start + 4];
        $ret .= sprintf " %02x", $$mem[$start + 7];
        return $ret;
    }

    $ret .= " " . (($byte & 4) ? "  wrap" : "nowrap") if $geoffmode;
    $ret .= " " . (($byte & 0x18) >> 3) . " ";

    #byte 1: ppppcccc
    $byte = $$mem[$start + 1];
    $ph = (($byte >> 5) & 7) + 1;
    $ret .= " $ph  ";
    $ret .= $byte & 8 ? "b " : "n ";
    $ret .= $byte & 7 . " ";

    #byte 4: v
    my $v = $$mem[$start + 4];
#    $v >>=  4 if $type == 1;
#    $v -= 256 if $type == 2 and $v & 0x80;
    $v -= 256 if $v & 0x80;
    $ret .= sprintf " %3d ", $v;

    #byte 5: page
    $ret .= sprintf " %02x", $$mem[$start + 5];

    #byte 3: y0
    $ret .= sprintf "  %02x", $$mem[$start + 3];

    #bytes 6 and 7: start and end
    $ret .= sprintf " %02x", $$mem[$start + 6];
    $ret .= sprintf " %02x", $$mem[$start + 7];

    $ret;
}

##############################################################################

sub makehexlist
{
    my $s = shift;
    my @a = split /,/, $s;
    my @ret = ();
    my $x = "[0-9a-fA-F][0-9a-fA-F]";

    foreach (@a)
    {
        /^($x)$/ and push(@ret, hex $1), next;
        /^($x)-($x)$/ and push(@ret, (hex $1 .. hex $2)), next;
        die "Bad list specification $_";
    }

    @ret;
}

##############################################################################

sub extract_room
{
    my $room     = shift;
    print "Room $room\n";

    my $start    = 0xc000 + 256 * $room;
    my @roomdata = @mem[$start .. $start + 255];

    # Name
    my $name = pack("C32", @roomdata[0x80 .. 0x9f]);

    # Platforms
    my @roomtext = ();
    my @blocks   = ( ".", "=", "%", "*" );

    foreach $row (0 .. 15)
    {
        foreach $col (0 .. 7)
        {
            $byte = $roomdata[$row * 8 + $col];
            foreach $n (6, 4, 2, 0)
            {
                $roomtext[$row] .= $blocks[($byte >> $n) & 3];
            }
        }
    }

    #Conveyor
    my $convlen   = $roomdata[0xd9];
    my $convchar  = $roomdata[0xd6] ? ">" : "<";
    my $convstart = dpeek(\@roomdata, 0xd7) - 0x5e00;
    $row = ($convstart >> 5) & 0xf;
    $col = $convstart & 0x1f;
    substr($roomtext[$row], $col, $convlen) = $convchar x $convlen;

    warn "Bad conveyor length ($convlen at $row, $col) in room $room!"
        if $col + $convlen > 32;

    #Stair
    my $stairdir   = $roomdata[0xda] ? 1 : -1;
    my $stairlen   = $roomdata[0xdd];
    my $stairchar  = $roomdata[0xda] ? "/" : "\\";
    my $stairstart = dpeek(\@roomdata, 0xdb) - 0x5e00;
    $row = ($stairstart >> 5) & 0xf;
    $col = $stairstart & 0x1f;

    warn "Bad stair length ($stairlen, $stairdir" .
         " at $row, $col) in room $room!"
        if $row - $stairlen < -1
        or $col + $stairlen * $stairdir < -1
        or $col + $stairlen * $stairdir > 32;

    foreach $i (1 .. $stairlen)
    {
        last if $row < 0 || $col < 0 || $col > 31;
        substr($roomtext[$row --], $col, 1) = $stairchar;
        $col += $stairdir;
    }

    #Objects / Items
    my $objcount = $geoffmode == 2 ? 0x8451 : 0xa3ff;
    my $objtop   = $geoffmode == 2 ? 0xba00 : 0xa400;

    for($i = 255; $i >= $mem[$objcount]; $i --)
    {
        $lo   = $mem[$objtop + $i];
        next if ($lo & 0x3f) != $room;
        $hi   = $mem[$objtop + $i + 0x100];
        $col  = $hi & 0x1f;
        $row  = ($hi & 0xe0) >> 5;
        $row += ($lo & 0x80) >> 4;
        substr($roomtext[$row], $col, 1) = "\$";
    }

    # Print it all out
    print "Room data:\n";
    foreach $i (0 .. 15) { print "$roomtext[$i]\n"; }
    print "$name\n";

    #Blocks
    print "Block data:\n";
    foreach $block (0 .. 5)
    {
        print "   " if $block;
        $attr = $roomdata[0xa0 + 9 * $block];
        print (($attr >> 7) & 1); print " ";
        print (($attr >> 6) & 1); print " ";
        print (($attr >> 3) & 7); print " ";
        print ($attr & 7);
    }

    print "\n";

    foreach $row (0 .. 7)
    {
        foreach $block (0 .. 6)
        {
            print "  " if $block;
            $start = $block == 6 ? 0xe1 : 0xa1 + 9 * $block;
            print byte2bin($roomdata[$start + $row]);
        }
        print "\n";
    }

    #Border
    print "Border:  ", $roomdata[0xd6] & 7, "\n";

    #Exits
    print "Exits: ";
    my @exits = qw(Left Right Up Down);
    foreach $i (0 .. 3)
    {
        print "  $exits[$i] ", $roomdata[0xe9 + $i];
    }
    print "\n";

    printf "Sprites: ";
    foreach $i (0 .. 7)
    {
        last if $roomdata[0xf0 + $i * 2] == 0xff;
        print " " if $i;
        printf "%02x:", $roomdata[0xf0 + $i * 2];
        printf "%02x",  $roomdata[0xf1 + $i * 2];
    }
    print "\n";

    #Etc
    if($geoffmode)
    {
        $patch = dpeek(\@roomdata, 0xee);
        if($mem[$patch] != 0xc9)
        {
            printf "Patch:   %04x ", $patch;
            foreach $i (0 .. 19) { printf " %02x", $mem[$patch + $i]; }
            print "\n";
        }

        printf("Willy:   bottom %04x   ", dpeek(\@roomdata, 0xdf));
        printf("screen %04x\n",
            ($roomdata[0xd6] & 0xc0) + 256 * $roomdata[0xed]);
    }

    print "\n";
}

##############################################################################

foreach (@ARGV)
{
    /^-g/ and $guard = 1, next;
    /^-s/ and $spr   = $', next;
    /^-r/ and $rooms = $', next;
    /^-a/ and $all   = 1, next;

    $file = $_, next;
}

@mem = z80::read($file);

@modes = ("Matthew", "Old Geoff", "Geoff");

$geoffmode = 0;
$geoffmode = 1 if $mem[0x840c] == 0xc9;
$geoffmode = 2 if $mem[0x8400] != 0xf3;

@allspr = qw(9b-9f,a6-bf 9b-9f,a6-a7,aa-bf 98-b6);

@rooms = makehexlist $all ? "00-3f" : $rooms;
@spr   = makehexlist $all ? $allspr[$geoffmode] : $spr;

foreach $room (@rooms) { extract_room $room; }

foreach $spr (@spr) { print_page \@mem, $spr; }

if($all || $guard)
{
    print "Guardians\n";
    $start = $geoffmode == 2 ? 0xbc : 0xa0;

    foreach $i (0 .. 127)
    {
        print get_guard_data \@mem, $start, $i, $geoffmode;
        print "\n";
    }

    $n = dpeek($mem, 0x87f0) - 0x5c00;

    print "Start $mem[0x87eb] ", ($n & 0x1f), " ", ($n >> 5);
    print " $mem[0x87e1]\n";
}

##############################################################################
