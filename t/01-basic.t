use v6;
use Test;
use Numeric::Pack;

use-ok 'Numeric::Pack';
use Numeric::Pack :ALL;

#
# Test byte order management
#
is ( pack-int32 0x01, :endianness(big-endian)    )[0], 0x00, "Endian test: pack big-endian int32";
is ( pack-int32 0x01, :endianness(little-endian) )[0], 0x01, "Endian test: pack little-endian int32";

is ( unpack-int32 Buf.new(0, 0, 0, 0x01), :endianness(big-endian)     ), 0x01, "Endian test: unpack big-endian int32";
is ( unpack-int32 Buf.new(0x01, 0, 0, 0), :endianness(little-endian)  ), 0x01, "Endian test: unpack big-endian int32";

#
# Test packing
#
is pack-float-rat(  12.375, :endianness(big-endian) ).perl, Buf.new(0x41, 0x46, 0x00, 0).perl,              "pack-float-rat 12.375";
is pack-double-rat( 12.375, :endianness(big-endian) ).perl, Buf.new(0x40, 0x28, 0xC0, 0, 0, 0, 0, 0).perl,  "pack-double-rat 12.375";

is pack-int32(1024, :endianness(big-endian)).perl, Buf.new(0, 0, 0x04, 0).perl,                 "pack-int32 1024";
is pack-int64(1024, :endianness(big-endian)).perl, Buf.new(0, 0, 0x00, 0, 0, 0, 0x04, 0).perl,  "pack-int64 1024";

#
# Test unpacking
#
is unpack-float(  Buf.new(0x41, 0x46, 0x00, 0),             :endianness(big-endian) ), 12.375, "unpack-float 12.375";
is unpack-double( Buf.new(0x40, 0x28, 0xC0, 0, 0, 0, 0, 0), :endianness(big-endian) ), 12.375, "unpack-float 12.375";

is unpack-int32(Buf.new(0, 0, 0x04, 0),                :endianness(big-endian)), 1024, "unpack-int32 1024";
is unpack-int64(Buf.new(0, 0, 0x00, 0, 0, 0, 0x04, 0), :endianness(big-endian)), 1024, "unpack-int64 1024";

#
# Test limits
#
is unpack-int32( pack-int32 0 ),               0,             "pack -> unpack int32 0";
is unpack-int32( pack-int32 −2_147_483_648 ), −2_147_483_648, "pack -> unpack int32 lower limit";
is unpack-int32( pack-int32  2_147_483_647 ),  2_147_483_647, "pack -> unpack int32 upper limit";

is unpack-int64( pack-int64 0 ),                           0,                         "pack -> unpack int64 0";
is unpack-int64( pack-int64 −9_223_372_036_854_775_808 ), −9_223_372_036_854_775_808, "pack -> unpack int64 lower limit";
is unpack-int64( pack-int64  9_223_372_036_854_775_807 ),  9_223_372_036_854_775_807, "pack -> unpack int64 upper limit";

is unpack-float(  pack-float-rat 0 ), 0.Rat, "pack -> unpack float-rat 0";
is unpack-double( pack-double-rat 0), 0.Rat, "pack -> unpack double-rat 0";

my Buf $nan-buffer .= new(0xff, 0xff, 0xff, 0xff);
is unpack-float($nan-buffer), NaN, "unpack-float NaN";

$nan-buffer .= new(|$nan-buffer[0..3], 0xff, 0xff, 0xff, 0xff);
is unpack-double($nan-buffer), NaN, "unpack-double NaN";

done-testing;
