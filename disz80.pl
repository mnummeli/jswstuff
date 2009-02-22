# disz80.pl: disassemble a Z80 file
# =================================
#
# Usage: perl disz80.pl <file> [options]
#
# where <file> is in .z80 format. Options are:
#
# -s<addr>: start address; defaults to 0x8000
# -e<addr>: end address; defaults to 0xc000
# -d<addr>-<addr>: data area; disassembled as DEFB
# -t<addr>-<addr>: text area; disassembled as DEFM
#
# All addresses are taken as hex if suffuxed with 'h' or 'H',
# decimal otherwise.
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

@regs8     = qw(B C D E H L (HL) A);
@regs16    = qw(BC DE HL SP);
@regs16alt = qw(BC DE HL AF);
@aluops    = qw(ADD ADC SUB SBC AND XOR OR CP);
@flags     = qw(NZ Z NC C PO PE P M);
@line7     = qw(RLCA RRCA RLA RRA DAA CPL SCF CCF);
@bitops    = qw(RLC RRC RL RR SLA SRA SLL SRL);
@cbops     = qw(BIT RES SET);
@edops     = qw(LD CP IN OUT);
@edtype    = qw(I D IR DR);

##############################################################################

sub nextbyte
{
    $c    = $mem[$add ++] & 0xff;
    $hex .= sprintf "%02X", $c;
    $c;
}

##############################################################################

sub makeoffset
{
    $byte = shift;

    return sprintf("+#%02X", $byte) if $byte < 0x80;
    return sprintf "-#%02X", 256 - $byte;
}

##############################################################################

sub makereg8
{
    ($r, $index, $dis, $needdis) = @_;
    $reg = $regs8[$r];

    $dis = nextbyte if $needdis and $index;

    if($index)
    {
        return "$index$reg" if $r == 4  or $r == 5;
        return ("($index" . makeoffset($dis). ")") if $r == 6;
    }

    return $reg;
}

##############################################################################

sub makereg16
{
    ($r, $index, $alt) = @_;
    $reg = $alt ? $regs16alt[$r] : $regs16[$r];

    return "$index" if $r == 2 and $index;
    return $reg;
}

##############################################################################

sub get16
{
    $dest  = nextbyte;
    $dest += 256 * nextbyte;
    sprintf "%04X", $dest;
}

##############################################################################

sub decode8
{
    ($inst, $r) = @_;
    $dest  = sprintf "%02X", nextbyte;
    return $inst, "$r", "#$dest" if $r;
    return $inst, "#$dest";
}

##############################################################################

sub decode8d
{
    ($inst, $r) = @_;
    $dest = sprintf "%02X", nextbyte;
    $dest = sprintf("%02X", ($add + $c)) if $c < 0x80;
    $dest = sprintf("%02X", ($add + $c - 256)) if $c >= 0x80;

    return $inst, "$r", "#$dest" if $r;
    return $inst, "#$dest";
}

##############################################################################

sub decode16
{
    ($inst, $r) = @_;
    $dest = get16;

    return $inst, "$r", "#$dest" if $r;
    return $inst, "#$dest";
}

##############################################################################

sub decode_cb
{
    $index = shift;

    $dis = nextbyte if $index;
    $c   = nextbyte;

    my $page = $c >> 6;
    my $r1   = ($c >> 3) & 7;
    my $r2   = $c & 7;
    my $reg  = makereg8($r2, $index, $dis, 0);

    return $bitops[$r1],      $reg if $page == 0;
    return $cbops[$page - 1], $r1, $reg;
}

##############################################################################

sub decode_ed
{
    my $c = nextbyte;

    return "NEG"     if $c == 0x44;
    return "RETI"    if $c == 0x45;
    return "RETN"    if $c == 0x4d;
    return "IM", "0" if $c == 0x46;
    return "IM", "1" if $c == 0x56;
    return "IM", "2" if $c == 0x5e;
    return "RRD"     if $c == 0x67;
    return "RLD"     if $c == 0x6f;

    return "LD", "I", "A" if $c == 0x47;
    return "LD", "R", "A" if $c == 0x4f;
    return "LD", "A", "I" if $c == 0x57;
    return "LD", "A", "R" if $c == 0x5f;

    if(($c & 0xe4) == 0xa0)
    {
        $r1 = (($c >> 3) & 3);
        $r2 = $c & 3;
        $inst = $edops[$r2] . $edtype[$r1];
        $inst =~ s/OUT/OT/ if $inst =~ /OUT.R/;
        return $inst;
    }

    my $page = $c >> 6;
    my $r1   = ($c >> 3) & 7;
    my $r2   = $c & 7;

    if($page == 1)
    {
        return "IN", "$regs8[$r1]", "(C)"  if $r2 == 0;
        return "OUT", "(C)", $regs8[$r1]   if $r2 == 1;

        $r1 = ($c >> 4) & 3;
        $r2 = $c & 0xf;
        $reg = $regs16[$r1];

        return "SBC", "HL", $reg        if $r2 == 0x02;
        return "ADC", "HL", $reg        if $r2 == 0x0a;

        ($dest) = get16($s);
        return "LD", "($dest)", $reg    if $r2 == 0x03;
        return "LD", "$reg", "(#$dest)" if $r2 == 0x0b;
    }

    return "XXX";
}

##############################################################################

sub decode
{
    my $c     = nextbyte;
    my $index = "";

    return decode_ed if $c == 0xed;

    if($c == 0xdd || $c == 0xfd)
    {
        $index = ($c == 0xfd) ? "IY" : "IX";
        $c = nextbyte;
    }

    return decode_cb($index) if $c == 0xcb;

    my $page = $c >> 6;
    my $r1   = ($c >> 3) & 7;
    my $r2   = $c & 7;

    if($page == 0)
    {
        return "NOP"                if $c == 0x00;
        return "EX", "AF", "AF'"    if $c == 0x08;
        return decode8d("DJNZ", "") if $c == 0x10;
        return decode8d("JR",   "") if $c == 0x18;
        return decode8d("JR", $flags[$r1 - 4]) if $r2 == 0;

        $reg = makereg8($r1, $index, 0, $r2 =~ /[456]/);

        return         "INC", $reg  if $r2 == 4;
        return         "DEC", $reg  if $r2 == 5;
        return decode8("LD",  $reg) if $r2 == 6;
        return         $line7[$r1]  if $r2 == 7;

        $r1 = ($c >> 4) & 3;
        $r2 = $c & 15;
        $reg = makereg16($r1, $index);

        return decode16("LD", "$reg") if $r2 == 1;

        if($r2 == 9)
        {
            return "ADD", $index, "$reg" if $index;
            return "ADD", "HL",   "$reg";
        }

        return "INC", "$reg" if $r2 == 3;
        return "DEC", "$reg" if $r2 == 0xb;

        return "LD", "(BC)", "A" if $c == 0x02;
        return "LD", "(DE)", "A" if $c == 0x12;
        return "LD", "A", "(BC)" if $c == 0x0a;
        return "LD", "A", "(DE)" if $c == 0x1a;

        $dest = get16;
        return "LD", "A", "(#$dest)" if $c == 0x3a;
        return "LD", "(#$dest)", "A" if $c == 0x32;

        $reg = makereg16(2, $index);
        return "LD", "$reg", "(#$dest)" if $c == 0x2a;
        return "LD", "(#$dest)", $reg   if $c == 0x22;

        return "XXX";
    }

    if($page == 1)
    {
        return "HALT" if $c == 0x76;

        if($index and ($r1 == 6 or $r2 == 6))
        {
            if($r1 == 6)
            {
                $reg1 = makereg8($r1, $index, 0, 1);
                $reg2 = makereg8($r2);
            }
            else
            {
                $reg1 = makereg8($r1);
                $reg2 = makereg8($r2, $index, 0, 1);
            }
        }
        else
        {
            $reg1 = makereg8($r1, $index);
            $reg2 = makereg8($r2, $index);
        }

        return "LD", "$reg1", $reg2;
    }

    if($page == 2)
    {
        $reg = makereg8($r2, $index, 0, 1);
        return $aluops[$r1], $reg;
    }

    if($page == 3)
    {
        return "RET" if $c == 0xc9;
        return "EXX" if $c == 0xd9;
        return "JP", "(" . makereg16(2, $index) . ")" if $c == 0xe9;
        return "LD", "SP", makereg16(2, $index)       if $c == 0xf9;

        return decode16("JP",   "") if $c == 0xc3;
        return decode16("CALL", "") if $c == 0xcd;

        return "EX", "(SP)", makereg16(2, $index) if $c == 0xe3;
        return "EX", "DE",   "HL" if $c == 0xeb;
        return "DI" if $c == 0xf3;
        return "EI" if $c == 0xfb;

        if($r2 == 3)
        {
            $dest = sprintf "#%02X", nextbyte;
            return "IN",  "A", "($dest)" if $c == 0xdb;
            return "OUT", "($dest)", "A" if $c == 0xd3;
        }

        return "RET", $flags[$r1] if $r2 == 0;
        return "RST", 8 * $r2     if $r2 == 7;

        return decode16("JP",   $flags[$r1]) if $r2 == 2;
        return decode16("CALL", $flags[$r1]) if $r2 == 4;
        return decode8($aluops[$r1], "")     if $r2 == 6;

        $r1 = ($c >> 4) & 3;
        $r2 = $c & 15;

        $reg = makereg16($r1, $index, 1);
        return "POP",  $reg if $r2 == 1;
        return "PUSH", $reg if $r2 == 5;
    }

    return "XXX";
}

##############################################################################

sub mark
{
    ($type, $a) = @_;
    die "Bad format $a" unless $a =~ /\-/;
    ($s, $e) = ($`, $');
    $s = hex $` if $s =~ /h$/i;
    $e = hex $` if $e =~ /h$/i;

    while($s <= $e) { $mem[$s ++] |= $type << 8; }
}

##############################################################################

$start = 0x8000;
$end   = 0xc000;

@data = ();
@text = ();

foreach (@ARGV)
{
    /-s/ and $start = $', next;
    /-e/ and $end   = $', next;
    /-d/ and push(@data, $'), next;
    /-t/ and push(@text, $'), next;
}

$file  = shift;

$start = hex $` if $start =~ /h$/i;
$end   = hex $` if $end   =~ /h$/i;

@mem = z80::read($file);

foreach (@data) { mark(1, $_); }
foreach (@text) { mark(2, $_); }

$add = $start;

while($add < $end)
{
    $hex = "";

    unless($type = ($mem[$add] >> 8))
    {
        printf "%04X ", $add;
        ($inst, $arg1, $arg2) = decode($add);
        printf "%-9s%-5s", $hex, $inst;
        print "$arg1" if defined $arg1;
        print ", $arg2" if $arg2;
        print "\n";
        next;
    }

    $count = 0;
    $inst = ($type == 2) ? "DEFM" : "DEFB";
    $arg1 = "";
    $oldadd = $add;

    while(($mem[$add] >> 8) == $type)
    {
        if($count == 4)
        {
            printf "%04X ", $oldadd;
            $arg1 = "\"$arg1\"" if $type == 2;
            chop $arg1 if $type == 1;
            printf "%-9s%-5s%s\n", $hex, $inst, $arg1;
            $arg1 = $hex = "";
            $count = 0;
            $oldadd = $add;
        }

        $c = nextbyte;

        if(   $type == 1)            { $arg1 .= sprintf("\#%02X,", $c); }
        elsif($c >= 32 and $c < 127) { $arg1 .= pack "C1", $c; }
        else                         { $arg1 .= "."; }

        ++ $count;
    }

    next unless $count;

    $arg1 = "\"$arg1\"" if $type == 2;
    chop $arg1 if $type == 1;
    printf "%04X ", $oldadd;
    printf "%-9s%-5s%s\n", $hex, $inst, $arg1;
}

##############################################################################
