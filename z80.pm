# z80.pm
# ======
#
# Perl module for reading and writing .z80 files for Spectrum
# emulators.
#
# Usage
# =====
#
# use z80;
#
# To read from a .z80 file: @bytes = z80::read($file);
# To write to a .z80 file: z80::write($file, @bytes);
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

package z80;

sub read
{
    $file = shift;
    open IN, "<$file" or die "Can't open input file $file!";
    binmode IN;
    $length = read IN, $buf, 32767;
    close IN;

    print STDERR "Read $length bytes from $file\n";

    @bytes  = unpack "C$length", $buf;
    $i      = 6;
    $offset = 30;
    $oldc   = 1;

    print STDERR "Compression: $oldc\n";

    $pc  = $bytes[$i ++];
    $pc += $bytes[$i ++] << 8;

    unless($pc)
    {
        $i       = $offset;
        $offset += $bytes[$i ++];
        $offset += $bytes[$i ++] << 8;
        $offset += 2;
        $oldc    = 0;
    }

    $i = $offset;
    @header = @bytes[0 .. $offset - 1];

    while(1)
    {
        $n = 0x4000;
        $page = 0;

        unless($oldc)
        {
            last if $i >= $length;
            $len  = $bytes[$i ++];
            $len += $bytes[$i ++] << 8;
            $page = $bytes[$i ++];

            $n = 0x8000 if $page == 4;
            $n = 0xC000 if $page == 5;
        }

        print STDERR "Reading: page $page  start $n\n";

        while(1)
        {
            last if !$oldc and $len <= 0;

            $c1 = $bytes[$i ++]; $len --;
            if($c1 != 0xed) { $mem[$n ++] = $c1; next; }

            $c2 = $bytes[$i ++]; $len --;
            if($c2 != 0xed) { $mem[$n ++] = $c1; $mem[$n ++] = $c2; next; }

            $c1 = $bytes[$i ++]; $len --;
            $c2 = $bytes[$i ++]; $len --;
            last if $oldc and !$c1 and $len < 0;

            while($c1 --) { $mem[$n ++] = $c2; }
        }

        last if $oldc;
    }

    @mem;
}

##############################################################################

sub compressblock
{
    my ($page, $start, $oldc, @mem) = @_;
    my $done = 0, $n = 0;
    my $limit = $oldc ? 49151 : 16383;
    my @buf = ();

    print STDERR "Writing: page $page  start $start  comp $oldc\n";

    while(!$done)
    {
        $i = 1; $c = $mem[$start + $n];

        while($i + $n <= $limit && $i < 255
              && $mem[$start + $n + $i] == $c) { $i ++; }

        if($c == 0xed)
        {
            if($i > 1) { push @buf, 0xed, 0xed, $i, $c; }
            else
            {
                push @buf, $c;
                push @buf, $mem[$start + $n + $i ++] if $i + $n < $limit;
            }
        }
        else
        {
            if($i == 1) { push @buf, $c; }
            elsif($c == 0xed || $i >= 5)
            { push @buf, (0xed, 0xed, $i, $c); }
            else
            { for($j = 0; $j < $i; $j ++) { push @buf, $c; } }
        }

        $done = (($n += $i) > $limit);
    }

    $len = $#buf + 1;

    if($oldc) { push @buf, 0, 0xed, 0xed, 0; }
    else      { unshift @buf, $len & 0xff, $len >> 8, $page; }

    @buf;
}

##############################################################################

sub write
{
    my ($file, @mem) = @_;

    open OUT, ">$file" or die "Can't write to $file!";
    binmode OUT;
    @buf = @header;

    if($oldc) { push @buf, compressblock(0, 0x4000, 1, @mem); }
    else
    {
        push @buf, compressblock(4, 0x8000, 0, @mem);
        push @buf, compressblock(5, 0xc000, 0, @mem);
        push @buf, compressblock(8, 0x4000, 0, @mem);
    }

    $len = 1 + $#buf;
    $buf = pack "C$len", @buf;
    print OUT $buf;

    close OUT;

    print STDERR "Written $len bytes to $file\n";
}

##############################################################################

1;
