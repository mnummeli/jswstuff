# jswclop.pl
# ==========
#
# This Perl script takes a pre-existing Jet Set Willy game, modifies
# it according to a text file, and writes the output to a .z80
# file. It may thus be used as a kind of "Jet Set Willy compiler" by
# those who wish to create their own JSW games but have no room editor
# to hand.
#
# Both Matthew mode and Geoff mode are supported.
#
# Usage
# =====
#
# perl jswclop.pl <source file> <text file> <destination file>
#
# <source file> must be in .z80 format. NO WARNING is given if
# <destination file> will be overwritten!
#
# See the file "jswclop.txt" for the format of <text file>.
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

##############################################################################

sub poketext
{
    my ($mem, $addr, $text) = @_;
    my $len = length $text;
    my @namebytes = unpack("C$len", $text);
    foreach $i (0 .. $len - 1) { $mem[$addr + $i] = $namebytes[$i]; }
}

##############################################################################

sub addtext
{
    my $mem  = shift;
    my $line = shift;
    my ($addr, $text) = unpack "A4XA*", $line;
    $addr = hex $addr;
    die "Bad address for text ($.)!" if $addr < 0x8000 or $addr > 0xbfff;
    poketext $mem, $addr, $text;
}

##############################################################################

sub pokebytes
{
    my ($mem, $addr, @bytes) = @_;
    foreach (@bytes) { $mem[$addr ++] = hex $_; }
}

##############################################################################

sub addbytes
{
    my $mem  = shift;
    my $text = shift;
    while($text =~ /\\$/) { chop $text; $text .= <IN>; chop $text; }
    my @a    = split /\s+/, $text;
    my $addr = hex shift @a;
    die "Bad address for bytes ($.)!" if $addr < 0x8000 or $addr > 0xbfff;
    pokebytes $mem, $addr, @a;
}

##############################################################################

sub makestart
{
    my $mem  = shift;
    my $line = shift;
    my @a = split /\s+/, $line;

    my $x = shift @a;
    die "Bad start room $x ($.)!" if $x < 0 or $x > 63;
    $mem[0x87eb] = $x;

    $x = shift @a;
    die "Bad start x-coordinate $x ($.)!" if $x < 0 or $x > 30;
    my $y = shift @a;
    die "Bad start y-coordinate $x ($.)!" if $y < 0 or $y > 14;
    $mem[0x87e6] = $y << 4;
    $n = 0x5c00 + ($y << 5) + $x;
    $mem[0x87f0] = $n & 0xff;
    $mem[0x87f1] = $n  >> 8;

    $x = shift @a;
    die "Bad number of lives $x ($.)!" if $x < 0 or $x > 16;
    $mem[0x87e1] = $x;
}

##############################################################################

sub makeguard
{
    my $mem = shift;
    my $id  = shift;
    my $start = $sprtop + 8 * hex $id;

    # byte 0
    my $type = lc shift;
    die "Unknown type $type for guardian id $id ($.)"
        unless $type =~ /^(hor|ver|arrow|rope|unused)$/i;

    if($type eq "unused")
    {
        $mem[$start] = 0;
        return;
    }

    my $c = shift;
    die "Bad direction $c for guardian id $id ($.)"
        unless $c eq "<" or $c eq ">";

    $mem[$start] = $c eq ">" ? 0x80 : 0;

    if($type eq "arrow")
    {
        $mem[$start] |= 4;
        $mem[$start + 4] = hex shift;
        $mem[$start + 6] = hex shift;
        return;
    }

    if($type eq "rope")
    {
        $mem[$start] |= 3;
        $mem[$start + 1] = hex shift;
        $mem[$start + 4] = hex shift;
        $mem[$start + 7] = hex shift;
        return;
    }

    $mem[$start] |= $type eq "hor" ? 1 : 2;

    # byte 1
    if($mode =~ "Geoff mode")
    {
        $c = shift;
        die "Bad wrap $c for guardian id $id ($.)"
            unless $c =~ /^(wrap|nowrap)$/i;
        $mem[$start] |= 4 if $c eq "wrap";
    }

    if($mode eq "Geoff mode")
    {
        $c = shift;
        die "Bad diagonal $c for guardian id $id ($.)"
            unless $c =~ /^[0-3]$/;
        $mem[$start] |= $c << 3;
    }
    else
    {
        $c = shift;
        die "Bad animation $c for guardian id $id ($.)"
            unless $c =~ /^[0-3]$/;
        $mem[$start] |= $c << 3;
    }

    $c = shift;
    die "Bad number of phases $c for guardian id $id ($.)"
        unless $c =~ /^[1-8]$/;
    $mem[$start + 1] = ($c - 1) << 5;

    $c = shift;
    die "Bad brightness $c for guardian id $id ($.)"
        unless $c =~ /^[bn]$/i;
    $mem[$start + 1] |= 8 if $c eq "b";

    $c = shift;
    die "Bad colour $c for guardian id $id ($.)"
        unless $c =~ /^[0-7]$/i;
    $mem[$start + 1] |= $c;

    # byte 4
    $c = shift;
    die "Bad speed $c for guardian id $id ($.)"
        unless $c =~ /^-?[0-9][0-9]?$/;
    $c += 256 if $c < 0;
    $mem[$start + 4] = $c;

    # byte 5
    $c = shift;
    die "Bad id $c for guardian id $id ($.)"
        unless $c =~ /^[0-9a-f]{2}$/;
    $mem[$start + 5] = hex $c;

    # byte 3
    $c = shift;
    die "Bad start y $c for guardian id $id ($.)"
        unless $c =~ /^[0-9a-f]{2}$/;
    $mem[$start + 3] = hex $c;

    # byte 6
    $c = shift;
    die "Bad start $c for guardian id $id ($.)"
        unless $c =~ /^[0-9a-f]{2}$/;
    $s = hex $c;

    # byte 7
    $c = shift;
    die "Bad finish $c for guardian id $id ($.)"
        unless $c =~ /^[0-9a-f]{2}$/;
    $e = hex $c;

    die "Start ($s) must be less than end ($e) for guardian id $id ($.)"
        if $s > $e;

    $mem[$start + 6] = $s;
    $mem[$start + 7] = $e;
}

##############################################################################

sub makeguards
{
    my $mem = shift;

    while(<IN>)
    {
        chop;
        last if /^$/;
        next if /^\#/;

        @a = split;
        $id = shift @a;
        die "Bad guardian id $id ($.)"
            unless $id =~ /^[0-7][0-9a-f]$/i;
        makeguard $mem, $id, @a;
    }
}

##############################################################################

sub makespr
{
    my ($mem, $spr) = @_;
    $spr = hex $spr;
    die "Bad sprite page $spr ($.)" if $spr < 0x98 or $spr > 0xbf;

    my @spr = ();

    foreach $i (0 .. 15)
    {
        chop ($line = <IN>);
        push @spr, $line;
    }

    $rev = <IN> =~ /reverse/i;

    foreach $i (0 .. 15)
    {
        if($rev) { $line = reverse $spr[$i]; }
        else     { chop ($line = <IN>); }
        $spr[$i] .= " $line";
    }

    <IN>;

    foreach $row (0 .. 15)
    {
        @a = split / +/, $spr[$row];
        die "Wrong number of columns for row $row of sprite page $spr"
            if scalar @a != 8;

        foreach $col (0 .. 7)
        {
            $data = shift @a;
            die "Bad column $col in row $row of sprite page $spr"
                if $data !~ /^[.%]{16}$/;
            $data =~ y/.%/01/;
            $data = oct "0b$data";
            $start = $spr * 0x100 + $col * 32 + $row * 2;
            $mem[$start    ] = $data >> 8;
            $mem[$start + 1] = $data & 0xff;
        }
    }
}

##############################################################################

sub findconvorstair
{
    ($conv, $mem, $start, @roomdata) = @_;
    my $lchar = $conv ? "<" : "\\";
    my $rchar = $conv ? ">" : "/";

    foreach $i (0 .. 15)
    {
        $row = 15 - $i;

        $col = index $roomdata[$row], $lchar;
        $dir = 0, last if $col >= 0;

        $col = index $roomdata[$row], $rchar;
        $dir = 1, last if $col >= 0;
    }

    if($col < 0)
    {
        $mem[$start]     = 0;
        $mem[$start + 1] = 0;
        $mem[$start + 2] = 0;
        $mem[$start + 3] = 0;
        return;
    }
 
    my $c = $dir ? $rchar : $lchar;
    my $len = 0, my $x = $col, my $y = $row;

    while($row >= 0 and $col >= 0 and $col <= 31)
    {
        last if substr($roomdata[$row], $col, 1) ne $c;
        -- $row unless $conv;
        if($conv or $dir == 1) { ++ $col; } else { -- $col; }
        ++ $len;
    }

    my $addr = 0x5e00 + $x + ($y << 5);

    $mem[$start]     = $dir;
    $mem[$start + 1] = $addr & 0xff;
    $mem[$start + 2] = $addr >> 8;
    $mem[$start + 3] = $len;
}

##############################################################################

sub makeblockdata
{
    my ($mem, $room) = @_;
    my $start = $room * 256 + 0xc000;
    my @blockdata = ();

    chop ($attrs = <IN>);
    @attrs = split / +/, $attrs;
    die "Wrong number of attributes in room $room ($.)"
        unless scalar @attrs == 24;

    foreach $i (0 .. 7)
    {
        chop ($line = <IN>);
        die "Invalid block line length in block line $i ($.) of room $room"
            if length $line != 68;
        push @blockdata, split / +/, $line;
    }

    foreach $block (0 .. 6)
    {
        foreach $row (0 .. 7)
        {
            $byte = $blockdata[7 * $row + $block];
            die "Bad block byte $row for block $block in room $room ($.)"
                unless $byte =~ /^[.%]{8}$/;
            $byte =~ y/.%/01/;
            $n = ($block == 6) ? 0xe1 : (0xa1 + 9 * $block);
            $mem[$start + $n + $row] = oct "0b$byte";
        }

        last if $block == 6;

        $fla = shift @attrs;
        die "Bad flash $fla for block $block in room $room ($.)"
            if $fla !~ /^[01]$/;
        $brt = shift @attrs;
        die "Bad bright $brt for block $block in room $room ($.)"
            if $brt !~ /^[01]$/;
        $pap = shift @attrs;
        die "Bad paper $pap for block $block in room $room ($.)"
            if $pap !~ /^[0-7]$/;
        $ink = shift @attrs;
        die "Bad ink $ink for block $block in room $room ($.)"
            if $ink !~ /^[0-7]$/;

        $attr = ($fla << 7) + ($brt << 6) + ($pap << 3) + $ink;
        $mem[$start + 0xa0 + 9 * $block] = $attr;
    }
}

##############################################################################

sub makeroomdata
{
    my ($mem, $room) = @_;
    my $start = $room * 256 + 0xc000;

    my @roomdata = ();

    # Read it all in
    foreach $i (0 .. 15)
    {
        chop ($line = <IN>);
        die "Invalid room line length in row $i ($.) of room $room"
            if length $line != 32;
        die "Unknown character in row $i ($.) of room $room"
            if $line != m~^[.=%\*<>\\/\$]+$~;
        push @roomdata, $line;
    }

    chop ($name  = <IN>);
    $name .= " " x (32 - length $name) if length $name < 32;
    $name = substr $name, 0, 32;

    # Stairs and conveyors
    findconvorstair(0, $mem, $start + 0xda, @roomdata);
    findconvorstair(1, $mem, $start + 0xd6, @roomdata);

    my $n = 0, $byte = 0;

    # Objects and room layout
    foreach $row (0 .. 15)
    {
        foreach $col (0 .. 31) 
        {
            $c = substr $roomdata[$row], $col, 1;
            if($c eq "\$")
            {
                $obj = $mem[$objcount] --;
                $lo  = $room | (($row & 8) ? 0xc0 : 0x40) ;
                $hi  = $col + (($row & 7) << 5);
                $mem[$objtop + $obj]         = $lo;
                $mem[$objtop + $obj + 0x100] = $hi;
            }

            $c =~ y:=%*\.<>/\\$:1230:;
            $byte <<= 2; $byte += $c;
            next if ($col + 1) % 4;

            $mem[$start + $n ++] = $byte & 0xff;
            $byte = 0;
        }
    }

    poketext $mem, $start + 0x80, $name;
}

##############################################################################

sub makeborder
{
    my ($mem, $room, $bord) = @_;
    my $start = $room * 256 + 0xc000;

    die "Bad border $bord for room $room ($.)" if $bord !~ /[0-7]/;
    $mem[$start + 0xd6] &= 0xf8;
    $mem[$start + 0xd6] |= $bord;
}

##############################################################################

sub makeexits
{
    my ($mem, $room, $line) = @_;
    my $start = $room * 256 + 0xc000;
    my %a = split / +/, $line;

    foreach $dir (keys %a)
    {
        $ex = $a{$dir};
        die "Bad exit number \"$ex\" ($.)" if $ex !~ /^\d+$/i;
        die "Invalid exit number \"$ex\" ($.)" if $ex < 0 or $ex > 63;
        $dir =~ /Left/  and $mem[$start + 0xe9] = $ex, next;
        $dir =~ /Right/ and $mem[$start + 0xea] = $ex, next;
        $dir =~ /Up/    and $mem[$start + 0xeb] = $ex, next;
        $dir =~ /Down/  and $mem[$start + 0xec] = $ex, next;
        die "Bad exit name \"$dir\" ($.)";
    }
}

##############################################################################

sub makesprites
{
    my ($mem, $room, $line) = @_;
    my $start = $room * 256 + 0xc000;
    my @spr = split / +/, $line;
    die "Too many sprites in room $room ($.)" if $#a > 8;

    my @sprmem = ( 0xff, 0, 0xff, 0, 0xff, 0, 0xff, 0,
                   0xff, 0, 0xff, 0, 0xff, 0, 0xff, 0 );
    my $i = 0;

    foreach $spr (@spr)
    {
        die "Bad format for sprite $i in room $room ($.)"
            unless $spr =~ /([0-7][0-9a-f]):([0-9a-f]{2})/i;
        $sprmem[$i + $i    ] = hex $1;
        $sprmem[$i + $i + 1] = hex $2;
        ++ $i;
    }

    splice @$mem, $start + 0xf0, 16, @sprmem;
}

##############################################################################

sub makepatch
{
    my ($mem, $room, $line) = @_;
    my $start = $room * 256 + 0xc000;
    die "Patch vectors (room $room) available in Geoff mode only"
        unless $mode =~ /Geoff/;

    while($line =~ /\\$/) { chop $line; $line .= <IN>; chop $line; }

    my @a = split / +/, $line;
    my $addr = hex shift @a;
    die "Bad address $addr for patch vector in room $room"
        if $addr < 0x8000 or $addr > 0xbfff;

    $mem[$start + 0xee] = $addr & 0xff;
    $mem[$start + 0xef] = $addr  >> 8;

    pokebytes $mem, $addr, @a;
}

##############################################################################

sub makewilly
{
    my ($mem, $room, $line) = @_;
    my $start = $room * 256 + 0xc000;
    die "Different Willies (room $room) available in Geoff mode only"
        unless $mode =~ /Geoff/;

    die "Bad Willy format for room $room"
        unless $line =~ /bottom ([0-9a-f]{4}) +screen ([0-9a-f]{4})/;
    my $scr = hex $1; my $bot = hex $2;

    $mem[$start + 0xdf] = $bot & 0x80;
    $mem[$start + 0xe0] = $bot >> 8;

    $mem[$start + 0xed] = $scr >> 8;
    $mem[$start + 0xd6] &= 7;
    $mem[$start + 0xd6] |= $scr & 0xc0;
}

##############################################################################

sub makeroom
{
    my ($mem, $room) = @_;

    die "Bad room number $room at line $." if $room < 0 or $room > 63;

    while(<IN>)
    {
        chop;
        /^$/ and return;
        /^\#/ and next;

        /Room data:/i    and makeroomdata( $mem, $room), next;
        /Block data:/i   and makeblockdata($mem, $room), next;
        /Border: +(\d)/i and makeborder(   $mem, $room, $1), next;
        /Exits: +/i      and makeexits(    $mem, $room, $'), next;
        /Sprites: +/i    and makesprites(  $mem, $room, $'), next;
        /Patch: +/i      and makepatch(    $mem, $room, $'), next;
        /Willy: +/i      and makewilly(    $mem, $room, $'), next;
    }
}

##############################################################################

($origfile, $descfile, $outfile) = @ARGV;

@mem = z80::read($origfile);

$mode = "Matthew mode";
$mode = "Old Geoff mode" if $mem[0x840c] == 0xc9;
$mode = "Geoff mode"     if $mem[0x8400] != 0xf3;

open IN, "<$descfile" or die "Can't open $descfile!";

chop ($wantmode = <IN>);

die "Mode mismatch: have $mode; want $wantmode" if $mode ne $wantmode;

if($mode eq "Geoff mode")
{
    $sprtop   = 0xbc00;
    $objcount = 0x8451;
    $objtop   = 0xba00;
}
else
{
    $sprtop   = 0xa000;
    $objcount = 0xa3ff;
    $objtop   = 0xa400;
}

$mem[$objcount] = 0xff;

while(<IN>)
{
    chop;
    next if /^$/ or /^\#/;

    /Room (\d+)/i                and makeroom(  \@mem, $1), next;
    /Sprite page ([0-9a-f]{2})/i and makespr(   \@mem, $1), next;
    /Guardians/i                 and makeguards(\@mem),     next;
    /Text\s+/i                   and addtext(   \@mem, $'), next;
    /Poke\s+/i                   and addbytes(  \@mem, $'), next;
    /Start\s+/i                  and makestart( \@mem, $'), next;
    die "Unknown command $_!";
}

z80::write $outfile, @mem;

##############################################################################
