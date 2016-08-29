NAME
====

Numeric::Pack - Convert perl6 numerics to buffers and back again!

SYNOPSIS
========

    use Numeric::Pack :ALL;

    # pack and unpack floats
    my Buf $float-buf = pack-float-rat 2.5;
    say "{ $float-buf.perl } -> { unpack-float $float-buf }";

    # pack and unpack doubles
    my Buf $double-buf = pack-double-rat 2.5;
    say "{ $double-buf.perl } -> { unpack-double $double-buf }";

    # pack and unpack Int (see also int64 varients)
    my Buf $int-buf = pack-int32 11;
    say "{ $int-buf.perl } -> { unpack-int32 $int-buf }";

    # pack and unpack specific byte orders (big-endian is the default)
    my Buf $little-endian-buf = pack-int32 11, :endianness(little-endian);
    say "{ $little-endian-buf.perl } -> {
      unpack-int32 $little-endian-buf, :endianness(little-endian)
    }";

DESCRIPTION
===========

Numeric::Pack is a Perl6 module for packing values of the Numeric role into Buf objects. Currently there are no core language mechanisms for packing the majority of Numeric types into Bufs. Both the experimental pack language feature and the PackUnpack module do not yet impliment packing to and from floating-point represetnations, A feature used by many modules in the Perl5 pack and unpack routines. Numeric::Pack fills this gap in functionality via a packaged native library and a corosponding NativeCall interface. Useing a native library to pack Numeric types avoids many pitfalls of implimenting a pure perl solution and provides better performance.

Numeric::Pack exports the enum Endianness by default (Endianness is experted as :MANDATORY).

<table>
  <thead>
    <tr>
      <td>Endianness</td>
      <td>Desc.</td>
    </tr>
  </thead>
  <tr>
    <td>native-endian</td>
    <td>The native byte ordering of the current system</td>
  </tr>
  <tr>
    <td>little-endian</td>
    <td>Common byte ordering of contemporary CPUs</td>
  </tr>
  <tr>
    <td>big-endian</td>
    <td>Also known as network byte order</td>
  </tr>
</table>

By default Numeric::Pack's pack and unpack functions return and accept big-endian Bufs. To override this provide the :endianness named parameter with the enum value for your desired behaviour. To disable byte order management pass :endianness(native-endian).

Use Numeric::Pack :ALL to export all exportable fucntionality.

Use :floats or :ints flags to export subsets of the module's functionality.

<table>
  <thead>
    <tr>
      <td>:floats</td>
      <td>:ints</td>
    </tr>
  </thead>
  <tr>
    <td>pack-float-rat</td>
    <td>pack-int32</td>
  </tr>
  <tr>
    <td>unpack-float</td>
    <td>unpack-int32</td>
  </tr>
  <tr>
    <td>pack-double-rat</td>
    <td>pack-int64</td>
  </tr>
  <tr>
    <td>unpack-double</td>
    <td>unpack-int64</td>
  </tr>
</table>

AUTHOR
======

Sam Gillespie <samgwise@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2016 Sam Gillespie

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

FUNCTIONS
=========

### sub libnumpack

```
sub libnumpack() returns Mu
```

The Endianness enum is exported by default. Use native-endian, little-endian and big-endian to specify the byte orderings. For pack functions the :endianness parameter specifies the byte order of the output For unpack functions :endianness specifies the byte order of the input buffer While heard there are other endian behaviours about, little and big are the most common.

### sub pack-float-rat

```
sub pack-float-rat(
    Cool $rat, 
    Endianness :$endianness = Endianness::big-endian
) returns Buf
```

Pack a Rat into a single-precision floating-point Buf (e.g. float). Exported via tag :floats. Be aware that Rats and floats are not directly anaolgous storage schemes and as such you should expect some variation in the values packed via this method and the orginal value.

### sub unpack-float

```
sub unpack-float(
    Buf $float-buf, 
    Endianness :$endianness = Endianness::big-endian
) returns Numeric
```

Unpack a Buf containing a single-precision floating-point number (float) into a Numeric. Exported via tag :floats.

### sub pack-int32

```
sub pack-int32(
    Cool $int, 
    Endianness :$endianness = Endianness::big-endian
) returns Buf
```

Pack an Int to an 4 byte intger buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of a signed 32bit integer [−2,147,483,648 to 2,147,483,647] is undefined.

### sub pack-double-rat

```
sub pack-double-rat(
    Cool $rat, 
    Endianness :$endianness = Endianness::big-endian
) returns Buf
```

Pack a Rat into a double-precision floating-point Buf (e.g. double). Exported via tag :floats. Be aware that Rats and doubles are not directly anaolgous storage schemes and as such you should expect some variation in the values packed via this method and the orginal value.

### sub unpack-double

```
sub unpack-double(
    Buf $double-buf, 
    Endianness :$endianness = Endianness::big-endian
) returns Numeric
```

Unpack a Buf containing a single-precision floating-point number (float) into a Numeric. Exported via tag :floats.

### sub pack-int64

```
sub pack-int64(
    Cool $int, 
    Endianness :$endianness = Endianness::big-endian
) returns Buf
```

Pack an Int to an 8 byte integer buffer Exported via tag :ints. Be aware that the behaviour of Int values outside the range of a signed 64bit integer [−9,223,372,036,854,775,808 to 9,223,372,036,854,775,807] is undefined.
