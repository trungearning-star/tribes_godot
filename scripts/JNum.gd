extends RefCounted
class_name JNum
## Emulates Java's (byte) and (short) narrowing-cast overflow semantics.
## GDScript `int` is 64-bit with no overflow, so every place the original code
## had an explicit `(byte)` or `(short)` cast (which is EVERY assignment of a
## computed value into a byte/short field or array slot — Java requires the
## cast, it won't compile otherwise) must go through these helpers to keep
## identical wraparound behavior.

static func to_byte(v: int) -> int:
	v = v & 0xFF
	if v > 127:
		v -= 256
	return v

static func to_short(v: int) -> int:
	v = v & 0xFFFF
	if v > 32767:
		v -= 65536
	return v

## Java `int` is 32-bit and does wrap; only needed where the original code
## relies on 32-bit overflow (rare in this codebase, but present in a few
## checksum/hash-like spots). Use only when explicitly ported that way.
static func to_int32(v: int) -> int:
	v = v & 0xFFFFFFFF
	if v > 0x7FFFFFFF:
		v -= 0x100000000
	return v
