[![Build Status](https://travis-ci.org/samgwise/p6-Numeric-Pack.svg?branch=master)](https://travis-ci.org/samgwise/p6-Numeric-Pack)

NAME
====

Numeric::Pack - Convert Raku Numerics to Bufs and back again!

SYNOPSIS
========

    use Numeric::Pack :ALL;

    # pack and unpack floats
    my Buf $float-buf = pack-float 2.5;
    say "{ $float-buf.perl } -> { unpack-float $float-buf }";

    # pack and unpack doubles
    my Buf $double-buf = pack-double 2.5;
    say "{ $double-buf.perl } -> { unpack-double $double-buf }";

    # pack and unpack Int (see also int64 variants)
    my Buf $int-buf = pack-int32 11;
    say "{ $int-buf.perl } -> { unpack-int32 $int-buf }";

    # pack and unpack specific byte orders (native-endian is the default)
    my Buf $little-endian-buf = pack-int32 11, :byte-order(little-endian);
    say "{ $little-endian-buf.perl } -> {
      unpack-int32 $little-endian-buf, :byte-order(little-endian)
    }";

DESCRIPTION
===========

Numeric::Pack is a Raku module for packing values of the Numeric role into Buf objects (With the exception of Complex numbers). This module provides a Rakudo compatible, non-experimental, numeric packing and unpacking facility, built with utilities of NativeCall. Integer ranges from 8 to 64 bits are supported and floating point as well as double precision floating point numbers. Byte order defaults to the native byte order of the system and can be specified with the ByteOrder enum.

Numeric::Pack exports the enum ByteOrder by default (ByteOrder is exported as :MANDATORY).

<table class="pod-table">
<thead><tr>
<th>ByteOrder</th> <th>Description</th>
</tr></thead>
<tbody>
<tr> <td>native-endian</td> <td>The native byte ordering of the current system</td> </tr> <tr> <td>little-endian</td> <td>Common byte ordering of contemporary CPUs</td> </tr> <tr> <td>big-endian</td> <td>Also known as network byte order</td> </tr>
</tbody>
</table>

By default Numeric::Pack's pack and unpack functions return and accept big-endian Bufs. To override this provide the :byte-order named parameter with the enum value for your desired behaviour. To disable byte order management pass :byte-order(native-endian).

Use Numeric::Pack :ALL to export all exportable functionality.

Use :floats or :ints flags to export subsets of the module's functionality.

<table class="pod-table">
<thead><tr>
<th>Export tag</th> <th>Functions</th>
</tr></thead>
<tbody>
<tr> <td>:floats</td> <td>pack-float, unpack-float, pack-double, unpack-double</td> </tr> <tr> <td>:ints</td> <td>pack-uint32, pack-int32, unpack-int32, unpack-uint32, pack-int64, unpack-int64, pack-uint64, unpack-uint64, pack-int16, unpack-int16, pack-uint16, unpack-uint16, pack-int8, unpack-int8, pack-uint8, unpack-uint8</td> </tr> <tr> <td>:ber</td> <td>pack-ber, unpack-ber, collect-ber</td> </tr>
</tbody>
</table>

CHANGES
=======

<table class="pod-table">
<tbody>
<tr> <td>Added ber encoding and decoding ala perl pack &#39;w&#39;</td> <td>Expanded potential use cases</td> <td>2020-04-28</td> </tr> <tr> <td>Added 8 and 16 bit integer types</td> <td>Expanded potential use cases</td> <td>2020-04-27</td> </tr> <tr> <td>Removed bundled native library, now pure perl6</td> <td>Improved portability and reliability</td> <td>2018-06-20</td> </tr> <tr> <td>Added pack-uint32, pack-uint32 and unpack-uint32</td> <td>Added support for unsigned types</td> <td>2017-04-20</td> </tr> <tr> <td>Changed named argument :endianness to :byte-order</td> <td>Signatures now read more naturally</td> <td>2016-08-30</td> </tr>
</tbody>
</table>

SEE ALSO
========

Rakudo core from 6.d 2018 and later supports reading values from a blob8 with a very similar interface to this module, see the docs here: [https://docs.perl6.org/type/Blob#Methods_on_blob8_only_(6.d,_2018.12_and_later)](https://docs.perl6.org/type/Blob#Methods_on_blob8_only_(6.d,_2018.12_and_later)).

The [Native::Packing](https://github.com/pdf-raku/Native-Packing-raku) module provides a role based packing mechanism for classes.

The [Binary::Structured](https://github.com/avuserow/perl6-binary-structured) module appears to be similar to Native::Packing but implemented via a class inheritance interface.

The [P5pack](https://modules.raku.org/dist/P5pack:cpan:ELIZABETH) module is a re-implementation of perl 5's pack subroutine (Raku's pack subroutine is currently experimental in rakudo).

AUTHOR
======

Sam Gillespie <samgwise@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2016 Sam Gillespie

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

FUNCTIONS
=========

### sub pack-float

```perl6
sub pack-float(
    Rat(Cool) $rat,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack a Rat into a single-precision floating-point Buf (e.g. float). Exported via tag :floats. Be aware that Rats and floats are not directly analogous and as such you should expect some variation in the values packed via this method and the original value.

### sub unpack-float

```perl6
sub unpack-float(
    Buf $float-buf,
    ByteOrder :$byte-order = { ... }
) returns Rat
```

Unpack a Buf containing a single-precision floating-point number (float) into a Numeric. Returns a Rat object on a NaN buffer. Exported via tag :floats.

### sub pack-int32

```perl6
sub pack-int32(
    Int(Cool) $int,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack an Int to a 4 byte integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of a signed 32 bit integer [ΓêÆ2,147,483,648 to 2,147,483,647] is undefined.

### sub unpack-int32

```perl6
sub unpack-int32(
    Buf $int-buf,
    ByteOrder :$byte-order = { ... }
) returns Int
```

Unpack a signed 4 byte integer buffer. Exported via tag :ints.

### sub pack-uint32

```perl6
sub pack-uint32(
    UInt(Cool) $int,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack an Int to a 4 byte unsigned integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of an unsigned 32 bit integer [0 to 4,294,967,295] is undefined.

### sub unpack-uint32

```perl6
sub unpack-uint32(
    Buf $int-buf,
    ByteOrder :$byte-order = { ... }
) returns Int
```

Unpack an unsigned 4 byte integer buffer. Exported via tag :ints.

### sub pack-double

```perl6
sub pack-double(
    Rat(Cool) $rat,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack a Rat into a double-precision floating-point Buf (e.g. double). Exported via tag :floats. Be aware that Rats and doubles are not directly analogous and as such you should expect some variation in the values packed via this method and the original value.

### sub unpack-double

```perl6
sub unpack-double(
    Buf $double-buf,
    ByteOrder :$byte-order = { ... }
) returns Rat
```

Unpack a Buf containing a double-precision floating-point number (double) into a Numeric. Returns a Rat on NaN buffer. Exported via tag :floats.

### sub pack-int64

```perl6
sub pack-int64(
    Int(Cool) $int,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack an Int to an 8 byte integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of a signed 64 bit integer [ΓêÆ9,223,372,036,854,775,808 to 9,223,372,036,854,775,807] is undefined.

### sub unpack-int64

```perl6
sub unpack-int64(
    Buf $int-buf,
    ByteOrder :$byte-order = { ... }
) returns Int
```

Unpack a signed 8 byte integer buffer. Exported via tag :ints.

### sub pack-uint64

```perl6
sub pack-uint64(
    UInt(Cool) $int,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack an UInt to an 8 byte unsigned integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of an unsigned 64bit integer [0 to 18,446,744,073,709,551,615] is undefined.

### sub unpack-uint64

```perl6
sub unpack-uint64(
    Buf $int-buf,
    ByteOrder :$byte-order = { ... }
) returns Int
```

Unpack an unsigned 8 byte integer buffer. Exported via tag :ints.

### sub pack-int16

```perl6
sub pack-int16(
    Int(Cool) $int,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack an Int to a 2 byte integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of a signed 16bit integer [ΓêÆ32,768 to 32,767] is undefined.

### sub unpack-int16

```perl6
sub unpack-int16(
    Buf $int-buf,
    ByteOrder :$byte-order = { ... }
) returns Int
```

Unpack a signed 2 byte integer buffer. Exported via tag :ints.

### sub pack-uint16

```perl6
sub pack-uint16(
    UInt(Cool) $int,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack an Int to a 2 byte unsigned integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of an unsigned 16bit integer [0 to 65,535] is undefined.

### sub unpack-uint16

```perl6
sub unpack-uint16(
    Buf $int-buf,
    ByteOrder :$byte-order = { ... }
) returns Int
```

Unpack an unsigned 2 byte integer buffer. Exported via tag :ints.

### sub pack-int8

```perl6
sub pack-int8(
    Int(Cool) $int,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack an Int to a 1 byte integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of a signed 8 bit integer [ΓêÆ128 to 127] is undefined.

### sub unpack-int8

```perl6
sub unpack-int8(
    Buf $int-buf,
    ByteOrder :$byte-order = { ... }
) returns Int
```

Unpack a signed 1 byte integer buffer. Exported via tag :ints.

### sub pack-uint8

```perl6
sub pack-uint8(
    UInt(Cool) $int,
    ByteOrder :$byte-order = { ... }
) returns Buf
```

Pack an Int to a 1 byte unsigned integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of an unsigned 16bit integer [0 to 255] is undefined.

### sub unpack-uint8

```perl6
sub unpack-uint8(
    Buf $int-buf,
    ByteOrder :$byte-order = { ... }
) returns Int
```

Unpack an unsigned 1 byte integer buffer. Exported via tag :ints.

### sub pack-ber

```perl6
sub pack-ber(
    Int $val where { ... }
) returns Buf
```

Analogue to the perl pack 'w' option. Which is stated to be different to ANS.1 BER format, see: https://perldoc.perl.org/perlpacktut.html#Another-Portable-Binary-Encoding This encoding handles an unsigned integer value of an arbitrary size in the minimum number of bytes. Each byte has 7 bits available with the first bit signalling continuation or conclusion of the encoded value.

### sub unpack-ber

```perl6
sub unpack-ber(
    Buf $bytes
) returns UInt
```

Corresponding unpacker for pack-ber, the resulting Int will be 0 to an arbitrary limit. Decoding will always result in a value but an error in the encoding will not be reported. You can use collect-ber() to obtain a sub buffer for decoding from another buffer.

### sub collect-ber

```perl6
sub collect-ber(
    Buf $bytes,
    Int :$offset where { ... } = 0
) returns Buf
```

This utility returns a copy of the sub buffer containing a ber encoded integer from the given offset. The sub buffer can then be given to unpack ber to decode the buffer into an Int.
