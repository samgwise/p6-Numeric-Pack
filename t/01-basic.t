#! /usr/bin/env perl6
use v6;
use Test;
use Numeric::Pack;

plan 53;

use-ok 'Numeric::Pack';
use Numeric::Pack :ALL;

#
# Test byte order management
#
is ( pack-int32 0x01, :byte-order(big-endian)    )[0], 0x00, "Endian test: pack big-endian int32";
is ( pack-int32 0x01, :byte-order(little-endian) )[0], 0x01, "Endian test: pack little-endian int32";

is ( unpack-int32 Buf.new(0, 0, 0, 0x01), :byte-order(big-endian)     ), 0x01, "Endian test: unpack big-endian int32";
is ( unpack-int32 Buf.new(0x01, 0, 0, 0), :byte-order(little-endian)  ), 0x01, "Endian test: unpack little-endian int32";

#
# Test packing
#
is pack-float(  12.375, :byte-order(big-endian) ).perl, Buf.new(0x41, 0x46, 0x00, 0).perl,              "pack-float 12.375";
is pack-double( 12.375, :byte-order(big-endian) ).perl, Buf.new(0x40, 0x28, 0xC0, 0, 0, 0, 0, 0).perl,  "pack-double 12.375";

is pack-int8(127, :byte-order(big-endian)).perl, Buf.new(127).perl,                             "pack-int8 127";
is pack-int16(1024, :byte-order(big-endian)).perl, Buf.new(0x04, 0).perl,                       "pack-int16 1024";
is pack-int32(1024, :byte-order(big-endian)).perl, Buf.new(0, 0, 0x04, 0).perl,                 "pack-int32 1024";
is pack-int64(1024, :byte-order(big-endian)).perl, Buf.new(0, 0, 0x00, 0, 0, 0, 0x04, 0).perl,  "pack-int64 1024";

is pack-uint8(127, :byte-order(big-endian)).perl, Buf.new(127).perl,                            "pack-uint8 127";
is pack-uint16(1024, :byte-order(big-endian)).perl, Buf.new(0x04, 0).perl,                      "pack-uint16 1024";
is pack-uint32(1024, :byte-order(big-endian)).perl, Buf.new(0, 0, 0x04, 0).perl,                "pack-uint32 1024";
is pack-uint64(1024, :byte-order(big-endian)).perl, Buf.new(0, 0, 0x00, 0, 0, 0, 0x04, 0).perl, "pack-uint64 1024";

# 01 8100 8101 81807F
# 1, 128, 128+1, 128*128+127
is-deeply pack-ber(0)[],                Buf.new(0x00)[],                'pack-ber for 0';
is-deeply pack-ber(1)[],                Buf.new(0x01)[],                'pack-ber for 1';
is-deeply pack-ber(128)[],              Buf.new(0x81, 0x00)[],          'pack-ber for 128';
is-deeply pack-ber(128 + 1)[],          Buf.new(0x81, 0x01)[],          'pack-ber for 128 + 1';
is-deeply pack-ber(128 * 128 + 127)[],  Buf.new(0x81, 0x80, 0x7F)[],    'pack-ber for 128 * 128 + 127';

#
# Test unpacking
#
is unpack-float(  Buf.new(0x41, 0x46, 0x00, 0),             :byte-order(big-endian) ), 12.375, "unpack-float 12.375";
is unpack-double( Buf.new(0x40, 0x28, 0xC0, 0, 0, 0, 0, 0), :byte-order(big-endian) ), 12.375, "unpack-double 12.375";

is unpack-int8(Buf.new(127),                            :byte-order(big-endian)),   127,    "unpack-int8 127";
is unpack-int16(Buf.new(0x04, 0),                       :byte-order(big-endian)),   1024,   "unpack-int16 1024";
is unpack-int32(Buf.new(0, 0, 0x04, 0),                :byte-order(big-endian)),    1024,   "unpack-int32 1024";
is unpack-int64(Buf.new(0, 0, 0x00, 0, 0, 0, 0x04, 0), :byte-order(big-endian)),    1024,   "unpack-int64 1024";

is unpack-uint8(Buf.new(127),                           :byte-order(big-endian)),   127,    "unpack-uint8 127";
is unpack-uint16(Buf.new(0x04, 0),                      :byte-order(big-endian)),   1024,   "unpack-uint16 1024";
is unpack-uint32(Buf.new(0, 0, 0x04, 0),                :byte-order(big-endian)),   1024,   "unpack-uint32 1024";
is unpack-uint64(Buf.new(0, 0, 0x00, 0, 0, 0, 0x04, 0), :byte-order(big-endian)),   1024,   "unpack-uint64 1024";

# 01 8100 8101 81807F
# 1, 128, 128+1, 128*128+127
is unpack-ber(Buf.new()),                   0,                  'unpack-ber for Empty';
is unpack-ber(Buf.new(0x00)),               0,                  'unpack-ber for 0';
is unpack-ber(Buf.new(0x01)),               1,                  'unpack-ber for 1';
is unpack-ber(Buf.new(0x81, 0x00)),         128,                'unpack-ber for 128';
is unpack-ber(Buf.new(0x81, 0x01)),         128 + 1,            'unpack-ber for 128 + 1';
is unpack-ber(Buf.new(0x81, 0x80, 0x7F)),   128 * 128 + 127,    'unpack-ber for 128 * 128 + 127';
# Collect-ber
is unpack-ber(collect-ber(Buf.new(0x01, 0x81, 0x80, 0x7F))),        1,          'collect-ber then unpack-ber for 1';
is unpack-ber(collect-ber(Buf.new(0x81, 0x01, 0x81, 0x80, 0x7F))),  128 +1,     'collect-ber then unpack-ber for 128 + 1';

#
# Test limits
#
is unpack-int32( pack-int32 0 ),               0,             "pack -> unpack int32 0";
is unpack-int32( pack-int32 −2_147_483_648 ), −2_147_483_648, "pack -> unpack int32 lower limit";
is unpack-int32( pack-int32  2_147_483_647 ),  2_147_483_647, "pack -> unpack int32 upper limit";

is unpack-uint32( pack-uint32 0 ),               0,             "pack -> unpack uint32 0";
is unpack-uint32( pack-uint32 4_294_967_295 ),  4_294_967_295, "pack -> unpack uint32 upper limit";

is unpack-int64( pack-int64 0 ),                           0,                         "pack -> unpack int64 0";
is unpack-int64( pack-int64 −9_223_372_036_854_775_808 ), −9_223_372_036_854_775_808, "pack -> unpack int64 lower limit";
is unpack-int64( pack-int64  9_223_372_036_854_775_807 ),  9_223_372_036_854_775_807, "pack -> unpack int64 upper limit";

is unpack-uint64( pack-uint64 0 ),                           0,                         "pack -> unpack uint64 0";
is pack-uint64(0xFFFF_FFFF_FFFF_FFFF)[].join(' '), Buf.new(  0xFF xx 8 )[].join(' '), "pack uint64 upper limit";
is unpack-uint64( pack-uint64 18_446_744_073_709_551_615 ), 18_446_744_073_709_551_615, "pack -> unpack uint64 upper limit";

is unpack-float(  pack-float 0 ), 0.Rat, "pack -> unpack float-rat 0";
is unpack-double( pack-double 0), 0.Rat, "pack -> unpack double-rat 0";

my Buf $nan-buffer .= new(0xff, 0xff, 0xff, 0xff);
is unpack-float($nan-buffer), Rat, "unpack-float NaN";

$nan-buffer .= new(|$nan-buffer[0..3], 0xff, 0xff, 0xff, 0xff);
is unpack-double($nan-buffer), Rat, "unpack-double NaN";
